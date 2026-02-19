
from app.database import SessionLocal
from app.models.inventory import InventoryItem
from sqlalchemy import text

def check_tv_item():
    db = SessionLocal()
    try:
        print("--- CHECKING TV ITEM ---")
        items = db.query(InventoryItem).filter(InventoryItem.name.ilike('%Tv%')).all()
        for item in items:
            print(f"Item: {item.name}")
            print(f"  ID: {item.id}")
            print(f"  Category ID: {item.category_id}")
            print(f"  Is Fixed Asset: {item.is_asset_fixed}")
            
            # If not fixed asset, fix it
            if not item.is_asset_fixed:
                print("  -> FIXING: Marking as Fixed Asset")
                item.is_asset_fixed = True
                db.commit()
                print("  -> Fixed.")
            else:
                print("  -> Already marked as Fixed Asset")

    except Exception as e:
        print(f"Error: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    check_tv_item()
