from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

bid = 4
res = db.execute(text("SELECT id, display_id FROM bookings WHERE id = :bid"), {"bid": bid}).fetchone()
print(f"Booking {bid}: ID={res[0]}, DisplayID=|{res[1]}|")

db.close()
