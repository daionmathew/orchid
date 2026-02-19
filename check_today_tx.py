from app.database import SessionLocal
from app.models.inventory import InventoryTransaction, InventoryItem
from datetime import datetime, time
db = SessionLocal()
today_7am = datetime.combine(datetime.now().date(), time(7, 0))
txs = db.query(InventoryTransaction).filter(
    InventoryTransaction.created_at >= today_7am,
    InventoryTransaction.item_id.in_([18, 19])
).all()
print(f"--- Transactions for Cokes/Water since 7 AM today ---")
for t in txs:
    item = db.query(InventoryItem).filter(InventoryItem.id == t.item_id).first()
    print(f"ID: {t.id}, Item: {item.name}, Type: {t.transaction_type}, Qty: {t.quantity}, Date: {t.created_at}, Notes: {t.notes}")
db.close()
