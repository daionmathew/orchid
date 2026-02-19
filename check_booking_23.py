from app.database import SessionLocal
from app.models.booking import Booking
db = SessionLocal()
b = db.query(Booking).filter(Booking.id == 23).first()
if b:
    print(f"Booking 23: {b.guest_name}, Status: {b.status}, Check-in: {b.check_in}, Checked-in At: {b.checked_in_at}")
db.close()
