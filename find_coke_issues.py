from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

# Item ID for Coca-Cola
item = db.execute(text("SELECT id FROM inventory_items WHERE name ILIKE '%coca%'")).fetchone()
if not item:
    print("Coco-Cola not found")
    db.close()
    exit()

item_id = item.id
print(f"Item ID: {item_id}")

# Find all issues for this item
res = db.execute(text("""
    SELECT si.id, si.destination_location_id, l.name as loc_name, si.issue_date, si.booking_id, si.notes, sid.issued_quantity, sid.is_payable 
    FROM stock_issues si 
    JOIN stock_issue_details sid ON si.id = sid.issue_id 
    JOIN locations l ON si.destination_location_id = l.id
    WHERE sid.item_id = :item_id
    ORDER BY si.issue_date DESC
"""), {"item_id": item_id}).fetchall()

for r in res:
    print(r)

db.close()
