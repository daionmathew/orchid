from app.database import SessionLocal
from app.api.inventory import get_location_items
from unittest.mock import MagicMock
import json

db = SessionLocal()
current_user = MagicMock()
current_user.name = "admin"

try:
    result = get_location_items(location_id=13, db=db, current_user=current_user)
    # Only print internal items
    print("--- ITEMS ---")
    for item in result.get("items", []):
        print(f"Item: {item['item_name']}, Qty: {item['current_stock']}, Type: {item['type']}, Comp: {item.get('complimentary_qty')}, Pay: {item.get('payable_qty')}")
except Exception as e:
    print(f"Error: {e}")
finally:
    db.close()
