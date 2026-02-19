from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

iid = 18
loc_id = 17
print(f"--- Stock Issue Details for Item {iid} (Coke) in Loc {loc_id} ---")
res = db.execute(text("""
    SELECT sid.id, sid.issue_id, sid.rental_price, sid.is_payable, sid.issued_quantity, si.issue_date, si.notes
    FROM stock_issue_details sid
    JOIN stock_issues si ON sid.issue_id = si.id
    WHERE sid.item_id = :iid AND si.destination_location_id = :loc_id
"""), {"iid": iid, "loc_id": loc_id}).fetchall()
for r in res:
    print(r)

db.close()
