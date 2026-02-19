from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

# Check both regular and package bookings for ID 4
print("--- Checking Booking ID 4 ---")
res = db.execute(text("SELECT id, guest_name, status, check_in, check_out FROM bookings WHERE id = 4")).fetchone()
if res:
    print(f"Regular Booking 4: {res}")
    rooms = db.execute(text("SELECT r.number, r.inventory_location_id FROM rooms r JOIN booking_rooms br ON r.id = br.room_id WHERE br.booking_id = 4")).fetchall()
    print(f"Rooms for Regular 4: {rooms}")
else:
    print("Regular Booking 4 not found")

res = db.execute(text("SELECT id, guest_name, status, check_in, check_out FROM package_bookings WHERE id = 4")).fetchone()
if res:
    print(f"Package Booking 4: {res}")
    rooms = db.execute(text("SELECT r.number, r.inventory_location_id FROM rooms r JOIN package_booking_rooms pbr ON r.id = pbr.room_id WHERE pbr.package_booking_id = 4")).fetchall()
    print(f"Rooms for Package 4: {rooms}")
else:
    print("Package Booking 4 not found")

# Search by name 'subin'
print("\n--- Searching for 'subin' ---")
res = db.execute(text("SELECT id, guest_name, 'regular' as type FROM bookings WHERE guest_name ILIKE '%subin%' UNION SELECT id, guest_name, 'package' as type FROM package_bookings WHERE guest_name ILIKE '%subin%'")).fetchall()
for r in res:
    print(r)

db.close()
