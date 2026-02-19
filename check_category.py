
from app.database import SessionLocal
from app.models.inventory import InventoryCategory
from sqlalchemy import text

def check_category_structure():
    db = SessionLocal()
    try:
        print("\n--- CATEGORY STRUCTURE ---")
        cat = db.query(InventoryCategory).first()
        if cat:
            print(f"Name: {cat.name}")
            print(f"Is Fixed Asset: {getattr(cat, 'is_asset_fixed', 'Not Found')}")
            print(f"Dict keys: {cat.__dict__.keys()}")
        else:
            print("No categories found")
            
    except Exception as e:
        print(f"Error: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    check_category_structure()
