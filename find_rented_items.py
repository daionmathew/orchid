from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

print("--- Stock Issue Details with Rental Price > 0 ---")
res = db.execute(text("""
    SELECT sid.id, i.name, sid.rental_price, sid.is_payable, si.destination_location_id, si.notes
    FROM stock_issue_details sid
    JOIN stock_issues si ON sid.issue_id = si.id
    JOIN inventory_items i ON sid.item_id = i.id
    WHERE sid.rental_price > 0
""")).fetchall()
for r in res:
    print(r)

db.close()
