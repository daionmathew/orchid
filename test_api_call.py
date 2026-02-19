from app.database import SessionLocal
from app.api.inventory import get_location_items
from unittest.mock import MagicMock

db = SessionLocal()
# Mock the dependencies
current_user = MagicMock()
current_user.name = "admin"

# Call the function directly
try:
    result = get_location_items(location_id=13, db=db, current_user=current_user)
    import json
    print(json.dumps(result, indent=2, default=str))
except Exception as e:
    print(f"Error: {e}")
    import traceback
    traceback.print_exc()
finally:
    db.close()
