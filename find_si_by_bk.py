from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

print("Stock Issues for booking_id = 4:")
res = db.execute(text("SELECT si.id, si.destination_location_id, si.issue_date, si.notes, i.name, sid.issued_quantity FROM stock_issues si JOIN stock_issue_details sid ON si.id = sid.issue_id JOIN inventory_items i ON sid.item_id = i.id WHERE si.booking_id = 4")).fetchall()
for r in res: print(r)

print("\nStock Issues for booking_id = 14 (first regular booking in list):")
res = db.execute(text("SELECT si.id, si.destination_location_id, si.issue_date, si.notes, i.name, sid.issued_quantity FROM stock_issues si JOIN stock_issue_details sid ON si.id = sid.issue_id JOIN inventory_items i ON sid.item_id = i.id WHERE si.booking_id = 14")).fetchall()
for r in res: print(r)

db.close()
