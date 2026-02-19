from app.database import SessionLocal
from app.models.inventory import InventoryTransaction, InventoryItem
db = SessionLocal()
ids = [289, 290, 318, 320]
txs = db.query(InventoryTransaction).filter(InventoryTransaction.id.in_(ids)).all()
for t in txs:
    print(f"ID: {t.id}, Item ID: {t.item_id}, Type: {t.transaction_type}, Qty: {t.quantity}, Date: {t.created_at}")

db.close()
