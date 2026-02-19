from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

loc_id = 16 # Room 102
print(f"Checking Location {loc_id}")

res = db.execute(text("""
    SELECT si.id, i.name, si.issue_date, si.booking_id, si.notes, sid.issued_quantity, sid.is_payable 
    FROM stock_issues si 
    JOIN stock_issue_details sid ON si.id = sid.issue_id 
    JOIN inventory_items i ON sid.item_id = i.id
    WHERE si.destination_location_id = :loc_id
    ORDER BY si.issue_date DESC
"""), {"loc_id": loc_id}).fetchall()

for r in res:
    print(r)

db.close()
