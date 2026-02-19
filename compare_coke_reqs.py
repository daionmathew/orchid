from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
import json

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

print("--- Checking all recent Inventory Data in Checkout Requests ---")
res = db.execute(text("SELECT id, booking_id, guest_name, inventory_data FROM checkout_requests ORDER BY id DESC LIMIT 5")).fetchall()
for r in res:
    print(f"\nReq ID: {r[0]}, Booking: {r[1]}, Guest: {r[2]}")
    if r[3]:
        data = r[3]
        if isinstance(data, str): data = json.loads(data)
        for item in data:
            if item.get('item_name') == 'coca cola':
                print(f"  COKE: is_rentable={item.get('is_rentable')}, is_fixed={item.get('is_fixed_asset')}, price={item.get('unit_price')}")

db.close()
