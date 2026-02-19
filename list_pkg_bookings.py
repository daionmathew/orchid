from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

print("--- Package Bookings ---")
res = db.execute(text("SELECT id, guest_name, status, check_in FROM package_bookings ORDER BY id DESC")).fetchall()
for r in res:
    print(r)

db.close()
