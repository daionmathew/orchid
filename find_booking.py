from app.database import SessionLocal
from app.models.booking import Booking
from app.models.room import Room
db = SessionLocal()
booking_id = 23
booking = db.query(Booking).filter(Booking.id == booking_id).first()
if booking:
    print(f"Booking ID: {booking.id}")
    print(f"Status: {booking.status}")
    rooms = [br.room for br in booking.booking_rooms]
    print(f"Rooms: {[r.number for r in rooms]}")
    for r in rooms:
        print(f"Room ID: {r.id}, Number: {r.number}, Location ID: {r.inventory_location_id}")
else:
    print("Booking not found")
db.close()
