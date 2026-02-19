from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

bid = 4
print(f"--- Checking Booking {bid} (test3) ---")
booking = db.execute(text("SELECT * FROM bookings WHERE id = :bid"), {"bid": bid}).fetchone()
print(f"Booking: {booking}")

rooms = db.execute(text("SELECT r.number, r.id, r.inventory_location_id FROM rooms r JOIN booking_rooms br ON r.id = br.room_id WHERE br.booking_id = :bid"), {"bid": bid}).fetchall()
print(f"Rooms: {rooms}")

if rooms:
    room_num = rooms[0][0]
    loc_id = rooms[0][2]
    print(f"\n--- Checkout Requests for Room {room_num} (Booking {bid}) ---")
    requests = db.execute(text("SELECT * FROM checkout_requests WHERE booking_id = :bid AND room_number = :rn ORDER BY id DESC"), {"bid": bid, "rn": room_num}).fetchall()
    for req in requests:
        print(f"Req ID: {req[0]}, Status: {req[4]}, Data: {req[5]}")

    print(f"\n--- Stock Issues for Location {loc_id} associated with Booking {bid} ---")
    issues = db.execute(text("""
        SELECT si.id, si.issue_number, i.name, sid.issued_quantity, sid.rental_price, sid.is_payable, si.notes, si.issue_date
        FROM stock_issues si
        JOIN stock_issue_details sid ON si.id = sid.issue_id
        JOIN inventory_items i ON sid.item_id = i.id
        WHERE si.destination_location_id = :loc_id AND si.booking_id = :bid
    """), {"loc_id": loc_id, "bid": bid}).fetchall()
    for i in issues:
        print(i)

    print(f"\n--- Stock Issues for Location {loc_id} (Untagged) ---")
    issues = db.execute(text("""
        SELECT si.id, si.issue_number, i.name, sid.issued_quantity, sid.rental_price, sid.is_payable, si.notes, si.issue_date, si.booking_id
        FROM stock_issues si
        JOIN stock_issue_details sid ON si.id = sid.issue_id
        JOIN inventory_items i ON sid.item_id = i.id
        WHERE si.destination_location_id = :loc_id AND si.booking_id IS NULL
    """), {"loc_id": loc_id}).fetchall()
    for i in issues:
        print(i)

db.close()
