from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
from app.models.checkout import CheckoutRequest
from app.models.booking import Booking, BookingRoom
from app.models.inventory import StockIssue, StockIssueDetail, InventoryItem
from app.models.room import Room
from app.database import Base, SQLALCHEMY_DATABASE_URL as DATABASE_URL
import json
import datetime

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
db = SessionLocal()

room_no = "103"
print(f"--- Inspecting Data for Room {room_no} ---")

# 1. Booking Info
room = db.query(Room).filter(Room.number == room_no).first()
if room:
    print(f"Room ID: {room.id}, Location ID: {room.inventory_location_id}")
    
    # Active Booking
    booking_link = (db.query(BookingRoom)
                    .join(Booking)
                    .filter(BookingRoom.room_id == room.id)
                    .order_by(Booking.id.desc()).first())
    if booking_link:
        b = booking_link.booking
        print(f"Active/Last Booking ID: {b.id}, Guest: {b.guest_name}, Status: {b.status}")
        print(f"Check-in: {b.check_in} (Type: {type(b.check_in)})")
        print(f"Check-out: {b.check_out}")
    else:
        print("No booking found.")
        
    # 2. Checkout Request
    cr = db.query(CheckoutRequest).filter(CheckoutRequest.room_number == room_no).order_by(CheckoutRequest.id.desc()).first()
    if cr:
        print(f"\nCheckout Request ID: {cr.id}")
        print(f"Status: {cr.status}")
        print(f"Inventory Checked: {cr.inventory_checked}")
        if cr.inventory_data:
            print(json.dumps(cr.inventory_data, indent=2))
        else:
            print("Inventory Data is Empty/None")

    # 3. Stock Issues
    if room.inventory_location_id:
        print(f"\nStock Issues for Location {room.inventory_location_id}:")
        issues = db.query(StockIssue).filter(StockIssue.destination_location_id == room.inventory_location_id).order_by(StockIssue.issue_date.desc()).limit(10).all()
        for issue in issues:
            print(f"Issue {issue.issue_number} | Date: {issue.issue_date} | Notes: {issue.notes}")
            for d in issue.details:
                print(f"  - {d.item.name}: Qty {d.issued_quantity}, Payable: {getattr(d, 'is_payable', 'N/A')}, Rental: {d.rental_price}")

else:
    print("Room 103 not found")
