from app.database import SessionLocal
from app.models.inventory import LocationStock, InventoryItem
db = SessionLocal()
location_id = 13
stocks = db.query(LocationStock).filter(LocationStock.location_id == location_id).all()
print(f"--- All LocationStock for Location {location_id} ---")
for s in stocks:
    item = db.query(InventoryItem).filter(InventoryItem.id == s.item_id).first()
    print(f"Item: {item.name if item else 'Unknown'} (ID: {s.item_id}), Quantity: {s.quantity}")
db.close()
