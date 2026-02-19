from app.database import SessionLocal
from app.models.inventory import InventoryTransaction, InventoryItem
from sqlalchemy import or_
db = SessionLocal()
room_number = "001"
# Find all transactions that mention Room 001 in notes or reference
# Note: InventoryTransaction doesn't have a direct room link, we rely on notes/ref
txs = db.query(InventoryTransaction).filter(
    or_(
        InventoryTransaction.notes.like(f"%Room {room_number}%"),
        InventoryTransaction.notes.like(f"%RM{room_number}%"),
        InventoryTransaction.notes.like(f"%Rm {room_number}%"),
        InventoryTransaction.reference_number.like(f"%RM{room_number}%"),
        InventoryTransaction.reference_number.like(f"%{room_number}%")
    )
).order_by(InventoryTransaction.created_at.desc()).all()

print(f"--- Inventory Transactions for Room {room_number} ---")
for t in txs:
    item = db.query(InventoryItem).filter(InventoryItem.id == t.item_id).first()
    print(f"ID: {t.id}, Item: {item.name if item else 'Unknown'}, Type: {t.transaction_type}, Qty: {t.quantity}, Ref: {t.reference_number}, Date: {t.created_at}")
    print(f"  Notes: {t.notes}")

db.close()
