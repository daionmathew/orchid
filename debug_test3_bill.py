from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
from datetime import datetime

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

# 1. Find booking for 'test3'
print("--- Booking 'test3' ---")
res = db.execute(text("SELECT id, guest_name, check_in, checked_in_at, status FROM bookings WHERE guest_name ILIKE '%test3%'")).fetchone()
if res:
    bid, name, ci, ci_at, status = res
    print(f"ID: {bid}, Name: {name}, Check-in: {ci}, Checked-in At: {ci_at}, Status: {status}")
    
    # 2. Find rooms for this booking
    rooms = db.execute(text("SELECT r.number, r.id, r.inventory_location_id FROM rooms r JOIN booking_rooms br ON r.id = br.room_id WHERE br.booking_id = :bid"), {"bid": bid}).fetchall()
    print(f"Rooms: {rooms}")
    
    # 3. Find stock issues for these rooms TODAY
    if rooms:
        loc_ids = [r[2] for r in rooms if r[2]]
        print(f"\n--- Stock Issues for Locations {loc_ids} since today 00:00 ---")
        today_start = datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)
        issues = db.execute(text("""
            SELECT si.id, si.issue_number, si.issue_date, si.notes, si.booking_id, i.name, sid.issued_quantity, sid.is_payable, sid.rental_price
            FROM stock_issues si
            JOIN stock_issue_details sid ON si.id = sid.issue_id
            JOIN inventory_items i ON sid.item_id = i.id
            WHERE si.destination_location_id IN :loc_ids AND si.issue_date >= :today
        """), {"loc_ids": tuple(loc_ids), "today": today_start}).fetchall()
        for i in issues:
            print(i)
            
    # 4. Check if there was a previous guest today
    if rooms:
        room_nums = [r[0] for r in rooms]
        print(f"\n--- Previous Checkouts for Rooms {room_nums} today ---")
        checkouts = db.execute(text("""
            SELECT id, room_number, guest_name, checkout_date, booking_id
            FROM checkouts
            WHERE room_number IN :room_nums AND checkout_date >= :today
        """), {"room_nums": tuple(room_nums), "today": today_start}).fetchall()
        for co in checkouts:
            print(co)

db.close()
