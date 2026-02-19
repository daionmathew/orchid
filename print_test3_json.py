from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
import json

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

bid = 4
print(f"--- Checkout Request Detail for Booking {bid} ---")
res = db.execute(text("SELECT inventory_data FROM checkout_requests WHERE booking_id = :bid"), {"bid": bid}).fetchone()
if res and res[0]:
    data = res[0]
    if isinstance(data, str):
        data = json.loads(data)
    print(json.dumps(data, indent=2))

db.close()
