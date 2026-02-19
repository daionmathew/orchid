from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

loc_id = 17
print(f"--- LocationStock for Location {loc_id} ---")
res = db.execute(text("""
    SELECT ls.item_id, i.name, ls.quantity, i.selling_price, i.unit_price, i.is_asset_fixed 
    FROM location_stocks ls 
    JOIN inventory_items i ON ls.item_id = i.id 
    WHERE ls.location_id = :loc_id
"""), {"loc_id": loc_id}).fetchall()
for r in res:
    print(r)

db.close()
