from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

loc_id = 17
print(f"--- ALL Stock Issue Details for Loc {loc_id} ---")
res = db.execute(text("""
    SELECT sid.id, sid.item_id, i.name, sid.rental_price, sid.unit_price, sid.issued_quantity, si.notes
    FROM stock_issue_details sid
    JOIN stock_issues si ON sid.issue_id = si.id
    JOIN inventory_items i ON sid.item_id = i.id
    WHERE si.destination_location_id = :loc_id
"""), {"loc_id": loc_id}).fetchall()
for r in res:
    print(r)

db.close()
