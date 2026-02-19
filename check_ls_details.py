from app.database import SessionLocal
from app.models.inventory import LocationStock, InventoryItem
db = SessionLocal()
ls = db.query(LocationStock).filter(LocationStock.location_id == 13, LocationStock.item_id == 18).first()
if ls:
    print(f"Item 18, Room 001: Quantity {ls.quantity}, Last Updated {ls.last_updated}")
ls = db.query(LocationStock).filter(LocationStock.location_id == 13, LocationStock.item_id == 19).first()
if ls:
    print(f"Item 19, Room 001: Quantity {ls.quantity}, Last Updated {ls.last_updated}")
db.close()
