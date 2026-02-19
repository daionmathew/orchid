from app.database import SessionLocal
from app.models.inventory import InventoryTransaction
db = SessionLocal()
ref = "CONSUME-CHK-23"
txs = db.query(InventoryTransaction).filter(InventoryTransaction.reference_number == ref).all()
print(f"--- Transactions for Reference: {ref} ---")
for t in txs:
    from app.models.inventory import InventoryItem
    item = db.query(InventoryItem).filter(InventoryItem.id == t.item_id).first()
    print(f"Item: {item.name}, Type: {t.transaction_type}, Qty: {t.quantity}, Notes: {t.notes}")

db.close()
