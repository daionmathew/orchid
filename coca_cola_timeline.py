from app.database import SessionLocal
from app.models.booking import Booking
from app.models.room import Room
from app.models.inventory import InventoryTransaction, InventoryItem, StockIssue, StockIssueDetail
from sqlalchemy import or_

db = SessionLocal()

def get_booking_info(bid):
    b = db.query(Booking).filter(Booking.id == bid).first()
    if b:
        rooms = [br.room.number for br in b.booking_rooms]
        return {
            "id": b.id,
            "guest": b.guest_name,
            "status": b.status,
            "checkin": b.checked_in_at,
            "checkout": b.check_out,
            "rooms": rooms
        }
    return None

print("--- Booking Details ---")
b23 = get_booking_info(23)
if b23: print(f"Booking 23 (Current): Guest={b23['guest']}, Rooms={b23['rooms']}, Checkin={b23['checkin']}")

b21 = get_booking_info(21)
if b21: print(f"Booking 21 (Previous): Guest={b21['guest']}, Rooms={b21['rooms']}, Checkin={b21['checkin']}, Checkout={b21['checkout']}")

print("\n--- Room 001 Inventory Timeline (Since Feb 14) ---")
# Room 001 -> Location ID 13
loc_id = 13
item_id = 18 # Coca Cola

# Issues
issues = db.query(StockIssue).filter(StockIssue.destination_location_id == loc_id, StockIssue.issue_date >= '2026-02-14').all()
for issue in issues:
    for d in issue.details:
        if d.item_id == item_id:
            print(f"[{issue.issue_date}] ISSUE: {d.issued_quantity} Cokes (Ref: {issue.issue_number})")

# Transactions
txs = db.query(InventoryTransaction).filter(
    InventoryTransaction.item_id == item_id,
    InventoryTransaction.created_at >= '2026-02-14',
    or_(
        InventoryTransaction.notes.like("%Room 001%"),
        InventoryTransaction.notes.like("%RM001%")
    )
).order_by(InventoryTransaction.created_at).all()

for t in txs:
    print(f"[{t.created_at}] TX: {t.transaction_type}, Qty: {t.quantity}, Ref: {t.reference_number}, Notes: {t.notes}")

db.close()
