from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

item_id = 18
print(f"Checking LocationStock for item {item_id}")

res = db.execute(text("SELECT ls.location_id, l.name, ls.quantity FROM location_stocks ls JOIN locations l ON ls.location_id = l.id WHERE ls.item_id = :item_id AND ls.quantity > 0"), {"item_id": item_id}).fetchall()
for r in res: print(r)

db.close()
