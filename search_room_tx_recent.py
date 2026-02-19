from app.database import SessionLocal
from app.models.inventory import InventoryTransaction, InventoryItem
from sqlalchemy import or_
from datetime import datetime, timedelta

def safe_print(msg):
    try:
        print(msg)
    except UnicodeEncodeError:
        print(msg.encode('ascii', 'ignore').decode('ascii'))

db = SessionLocal()
room_number = "001"
three_days_ago = datetime.now() - timedelta(days=3)
txs = db.query(InventoryTransaction).filter(
    or_(
        InventoryTransaction.notes.like(f"%Room {room_number}%"),
        InventoryTransaction.notes.like(f"%RM{room_number}%"),
        InventoryTransaction.notes.like(f"%Rm {room_number}%"),
        InventoryTransaction.reference_number.like(f"%RM{room_number}%"),
        InventoryTransaction.reference_number.like(f"%{room_number}%")
    ),
    InventoryTransaction.created_at >= three_days_ago
).order_by(InventoryTransaction.created_at.desc()).all()

safe_print(f"--- Inventory Transactions for Room {room_number} (Last 3 Days) ---")
for t in txs:
    item = db.query(InventoryItem).filter(InventoryItem.id == t.item_id).first()
    safe_print(f"ID: {t.id}, Item: {item.name if item else 'Unknown'} (ID: {t.item_id}), Type: {t.transaction_type}, Qty: {t.quantity}, Ref: {t.reference_number}, Date: {t.created_at}")
    safe_print(f"  Notes: {t.notes}")

db.close()
