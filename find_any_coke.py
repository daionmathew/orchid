from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

res = db.execute(text("SELECT ls.location_id, l.name, i.name, ls.quantity, i.id FROM location_stocks ls JOIN locations l ON ls.location_id = l.id JOIN inventory_items i ON ls.item_id = i.id WHERE i.name ILIKE '%coca%' AND ls.quantity > 0")).fetchall()
for r in res: print(r)

db.close()
