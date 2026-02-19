
from app.database import SessionLocal
from app.models.inventory import LocationStock, StockIssue
from sqlalchemy import text

def count_items():
    db = SessionLocal()
    try:
        loc_count = db.query(LocationStock).count()
        issue_count = db.query(StockIssue).count()
        print(f"Location Stocks: {loc_count}")
        print(f"Stock Issues: {issue_count}")
        
        # Check specific items
        print("\n--- Items in Room 102 ---")
        items = db.execute(text("""
            SELECT i.name, ls.quantity, l.name 
            FROM location_stocks ls 
            JOIN inventory_items i ON ls.item_id = i.id 
            JOIN locations l ON ls.location_id = l.id
            WHERE l.name = 'Room 102'
        """)).fetchall()
        
        for item in items:
            print(f"- {item[0]}: {item[1]}")
            
    except Exception as e:
        print(f"Error: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    count_items()
