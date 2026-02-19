from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

print("--- Stock Issues 2, 3 EXACT notes ---")
res = db.execute(text("SELECT id, notes FROM stock_issues WHERE id IN (2, 3)")).fetchall()
for r in res:
    print(f"ID: {r[0]}, Notes: |{r[1]}|")

db.close()
