from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

print("Stock Issues with booking_id:")
res = db.execute(text("SELECT id, booking_id, notes, destination_location_id FROM stock_issues WHERE booking_id IS NOT NULL")).fetchall()
for r in res: print(r)

db.close()
