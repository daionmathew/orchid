from app.database import SessionLocal
from app.models.checkout import CheckoutRequest as CheckoutRequestModel
db = SessionLocal()
room_number = "001"
requests = db.query(CheckoutRequestModel).filter(CheckoutRequestModel.room_number == room_number).order_by(CheckoutRequestModel.id.desc()).all()
print(f"--- Checkout Requests for Room {room_number} ---")
for r in requests:
    print(f"ID: {r.id}, Booking ID: {r.booking_id}, Status: {r.status}, Inventory Checked: {r.inventory_checked}, Date: {r.requested_at}")
    print(f"  Notes: {r.inventory_notes}")

db.close()
