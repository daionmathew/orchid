from app.database import SessionLocal
from app.models.inventory import AssetMapping, InventoryItem
db = SessionLocal()
mappings = db.query(AssetMapping).filter(AssetMapping.location_id == 13, AssetMapping.is_active == True).all()
print(f"--- Asset Mappings for Room 001 ---")
for m in mappings:
    item = db.query(InventoryItem).filter(InventoryItem.id == m.item_id).first()
    print(f"Item: {item.name} (ID: {item.id}), Quantity: {m.quantity}")
db.close()
