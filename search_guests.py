from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

print("--- Searching for 'test3' or 'alphi' ---")
# Try lower case and ILIKE
res = db.execute(text("SELECT id, guest_name FROM bookings WHERE guest_name ILIKE '%test3%' OR guest_name ILIKE '%alphi%'")).fetchall()
print(f"Bookings: {res}")

res = db.execute(text("SELECT id, guest_name FROM package_bookings WHERE guest_name ILIKE '%test3%' OR guest_name ILIKE '%alphi%'")).fetchall()
print(f"Package Bookings: {res}")

db.close()
