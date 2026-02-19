from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

print("--- Recent Bookings ---")
res = db.execute(text("SELECT id, guest_name, check_in, checked_in_at, status FROM bookings ORDER BY id DESC LIMIT 5")).fetchall()
for r in res:
    print(f"REG: {r}")

res = db.execute(text("SELECT id, guest_name, check_in, checked_in_at, status FROM package_bookings ORDER BY id DESC LIMIT 5")).fetchall()
for r in res:
    print(f"PKG: {r}")

db.close()
