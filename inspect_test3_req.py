from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
import json

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

bid = 4
print(f"--- Checkout Requests for Booking {bid} ---")
requests = db.execute(text("SELECT id, room_number, status, inventory_data FROM checkout_requests WHERE booking_id = :bid"), {"bid": bid}).fetchall()
for req in requests:
    print(f"ID: {req[0]}, Room: {req[1]}, Status: {req[2]}")
    if req[3]:
        print("Inventory Data:")
        data = req[3]
        if isinstance(data, str):
            data = json.loads(data)
        for item in data:
            print(f"  Item: {item.get('item_name')}, ID: {item.get('item_id')}, Used: {item.get('used_qty')}, Missing: {item.get('missing_qty')}, Damage: {item.get('damage_qty')}, Charge: {item.get('total_charge')}")

db.close()
