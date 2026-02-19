from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

ids = [2, 3]
print("--- Stock Issues 2, 3 details ---")
res = db.execute(text("SELECT id, source_location_id, destination_location_id, notes FROM stock_issues WHERE id IN :ids"), {"ids": tuple(ids)}).fetchall()
for r in res:
    print(r)

db.close()
