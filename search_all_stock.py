from app.database import SessionLocal
from app.models.inventory import Location, LocationStock, InventoryItem
db = SessionLocal()
item_id = 18 # Coke
stocks = db.query(LocationStock).filter(LocationStock.item_id == item_id, LocationStock.quantity > 0).all()
print(f"--- Locations with Coca Cola (Qty > 0) ---")
for s in stocks:
    loc = db.query(Location).filter(Location.id == s.location_id).first()
    print(f"Location: {loc.name if loc else 'Unknown'} (ID: {s.location_id}), Qty: {s.quantity}")

item_id = 19 # Water
stocks = db.query(LocationStock).filter(LocationStock.item_id == item_id, LocationStock.quantity > 0).all()
print(f"\n--- Locations with Mineral Water (Qty > 0) ---")
for s in stocks:
    loc = db.query(Location).filter(Location.id == s.location_id).first()
    print(f"Location: {loc.name if loc else 'Unknown'} (ID: {s.location_id}), Qty: {s.quantity}")

db.close()
