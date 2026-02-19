
from app.database import SessionLocal
from app.models.inventory import InventoryItem, InventoryCategory
from sqlalchemy import text

def fix_asset_items():
    db = SessionLocal()
    try:
        print("--- FIXING ASSET FLAGS ---")
        
        # Get all categories marked as fixed assets
        fixed_cats = db.query(InventoryCategory).filter(InventoryCategory.is_asset_fixed == True).all()
        fixed_cat_ids = [c.id for c in fixed_cats]
        print(f"Fixed Asset Categories: {[c.name for c in fixed_cats]}")
        
        if not fixed_cat_ids:
            print("No fixed asset categories found.")
            return

        # Find items in these categories that are NOT marked as fixed assets
        items = db.query(InventoryItem).filter(
            InventoryItem.category_id.in_(fixed_cat_ids),
            InventoryItem.is_asset_fixed == False
        ).all()
        
        print(f"Found {len(items)} items to update:")
        for item in items:
            print(f" - Updating '{item.name}' (Category ID: {item.category_id}) to Fixed Asset")
            item.is_asset_fixed = True
            
        if items:
            db.commit()
            print("✅ Successfully updated items.")
        else:
            print(" All items in fixed asset categories are already marked correctly.")
            
    except Exception as e:
        db.rollback()
        print(f"Error: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    fix_asset_items()
