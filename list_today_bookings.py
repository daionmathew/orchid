from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
from datetime import datetime

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

print("--- All Bookings Today ---")
today_start = datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)
res = db.execute(text("SELECT id, guest_name, check_in, checked_in_at, status, 'regular' FROM bookings WHERE check_in >= :today UNION SELECT id, guest_name, check_in, checked_in_at, status, 'package' FROM package_bookings WHERE check_in >= :today"), {"today": today_start}).fetchall()
for r in res:
    print(r)

db.close()
