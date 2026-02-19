from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
from ResortApp.app.api.checkout import _calculate_bill_for_single_room
from unittest.mock import MagicMock

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

room_number = "103"
print(f"--- Calculating Bill for Room {room_number} ---")
try:
    bill = _calculate_bill_for_single_room(db, room_number)
    print("Consumables Items:")
    for item in bill.get('consumables_items', []):
        print(f"  {item['item_name']} x{item['actual_consumed']} = {item['total_charge']}")
    
    print("\nInventory Usage:")
    for item in bill.get('inventory_usage', []):
        print(f"  {item['item_name']} x{item['quantity']} = {item['rental_charge']} (Notes: {item['notes']})")

except Exception as e:
    import traceback
    print(f"Error: {e}")
    traceback.print_exc()

db.close()
