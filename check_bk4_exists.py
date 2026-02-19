from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

booking_id = 4
res = db.execute(text("SELECT id, guest_name FROM bookings WHERE id = :id"), {"id": booking_id}).fetchone()
print(f"Booking {booking_id}: {res}")

db.close()
