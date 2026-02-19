from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

booking_id = 4 # BK-000004

# Get booking and rooms
res = db.execute(text("SELECT id, guest_name, check_in, check_out FROM bookings WHERE id = :id"), {"id": booking_id}).fetchone()
print(f"Booking: {res}")

rooms = db.execute(text("SELECT r.id, r.number, r.inventory_location_id FROM rooms r JOIN booking_rooms br ON r.id = br.room_id WHERE br.booking_id = :id"), {"id": booking_id}).fetchall()
print(f"Rooms: {rooms}")

for r in rooms:
    loc_id = r.inventory_location_id
    if not loc_id: continue
    
    print(f"\nInventory for Location {loc_id} (Room {r.number}):")
    
    # Location Stock
    stocks = db.execute(text("SELECT i.name, ls.quantity FROM location_stocks ls JOIN inventory_items i ON ls.item_id = i.id WHERE ls.location_id = :loc_id"), {"loc_id": loc_id}).fetchall()
    print("Location Stock:")
    for s in stocks:
        print(f"  - {s.name}: {s.quantity}")
        
    # Stock Issues
    issues = db.execute(text("SELECT i.name, sid.issued_quantity, sid.is_payable, si.issue_date, si.booking_id FROM stock_issue_details sid JOIN stock_issues si ON sid.stock_issue_id = si.id JOIN inventory_items i ON sid.item_id = i.id WHERE si.destination_location_id = :loc_id"), {"loc_id": loc_id}).fetchall()
    print("Stock Issues:")
    for iss in issues:
        print(f"  - {iss.name}: {iss.issued_quantity} (Payable: {iss.is_payable}), Date: {iss.issue_date}, Booking: {iss.booking_id}")

db.close()
