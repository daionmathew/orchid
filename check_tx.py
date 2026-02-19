from app.database import SessionLocal
from app.models.inventory import InventoryTransaction, InventoryItem
db = SessionLocal()
item_id = 18
txs = db.query(InventoryTransaction).filter(InventoryTransaction.item_id == item_id).order_by(InventoryTransaction.created_at.desc()).limit(10).all()
print(f"--- Recent Transactions for Item ID: {item_id} ---")
for t in txs:
    print(f"ID: {t.id}, Type: {t.transaction_type}, Qty: {t.quantity}, Ref: {t.reference_number}, Date: {t.created_at}")
    print(f"  Notes: {t.notes}")

db.close()
