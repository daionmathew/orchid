from app.database import SessionLocal
from app.models.booking import Booking
from app.models.room import Room
from app.models.inventory import StockIssue, StockIssueDetail
from sqlalchemy.orm import joinedload
from datetime import datetime, timedelta
import re

db = SessionLocal()

def test_billing_fallback(room_number, booking_id):
    # 1. Get Room
    room = db.query(Room).filter(Room.number == room_number).first()
    if not room:
        print(f"Room {room_number} not found")
        return

    # 2. Get Booking
    booking = db.query(Booking).filter(Booking.id == booking_id).first()
    if not booking:
        print(f"Booking {booking_id} not found")
        return

    check_in_datetime = booking.checked_in_at or datetime.now()
    
    # 3. Simulate Fallback Logic
    stock_issues = (db.query(StockIssue)
                    .options(joinedload(StockIssue.details).joinedload(StockIssueDetail.item))
                    .filter(StockIssue.destination_location_id == room.inventory_location_id,
                            StockIssue.issue_date >= check_in_datetime - timedelta(hours=24))
                    .all())
    
    print(f"--- Fallback Items for Room {room_number}, Booking {booking_id} ---")
    
    # Logic from checkout.py
    booking_id_padded = str(booking.id).zfill(6)
    possible_ids = [f"BK-{booking_id_padded}", f"PK-{booking_id_padded}"]
    if getattr(booking, 'display_id', None):
        possible_ids.append(booking.display_id)

    items_found = []
    for issue in stock_issues:
        issue_notes_upper = (issue.notes or "").upper()
        if "BK-" in issue_notes_upper or "PK-" in issue_notes_upper:
            if not any(pid in issue_notes_upper for pid in possible_ids):
                print(f"[SKIPPED] Issue {issue.issue_number} - Belongs to different booking: {issue.notes}")
                continue
        
        for detail in issue.details:
            if not detail.item: continue
            clean_name = re.sub(r'\s*\(\s*[xX]\d+[^)]*\)', '', detail.item.name).strip()
            items_found.append(f"{clean_name} (Issue: {issue.issue_number})")
            print(f"[ADDED] {clean_name} from {issue.issue_number}")

    if not items_found:
        print("No fallback consumables found (Success!)")
    else:
        print(f"Unexpected items found: {items_found}")

if __name__ == "__main__":
    # Test for current guest 'as' (Booking 23) in Room 001
    test_billing_fallback("001", 23)

db.close()
