
from app.database import SessionLocal
from app.models.inventory import InventoryItem, InventoryCategory, Location
from sqlalchemy import text

def check_master_data():
    db = SessionLocal()
    try:
        print("\n--- ALL ITEMS ---")
        items = db.query(InventoryItem).all()
        for item in items:
            print(f"- Name: {item.name}, Category: {item.category.name if item.category else 'None'}, Fixed Asset: {item.is_asset_fixed}")
            
    except Exception as e:
        print(f"Error: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    check_master_data()
