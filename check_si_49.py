from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

issue_id = 49
print(f"Details for Issue {issue_id}:")
res = db.execute(text("SELECT sid.item_id, i.name, sid.issued_quantity, sid.is_payable FROM stock_issue_details sid JOIN inventory_items i ON sid.item_id = i.id WHERE sid.issue_id = :id"), {"id": issue_id}).fetchall()
for r in res: print(r)

db.close()
