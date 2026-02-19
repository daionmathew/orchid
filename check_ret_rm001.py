from app.database import SessionLocal
from app.models.inventory import InventoryTransaction, InventoryItem
db = SessionLocal()
ref = "RET-RM001"
txs = db.query(InventoryTransaction).filter(InventoryTransaction.reference_number == ref).all()
print(f"--- Transactions for Reference: {ref} ---")
for t in txs:
    item = db.query(InventoryItem).filter(InventoryItem.id == t.item_id).first()
    print(f"ID: {t.id}, Item: {item.name}, Type: {t.transaction_type}, Qty: {t.quantity}")

db.close()
