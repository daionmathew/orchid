from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

print("--- Stock Issues Columns ---")
res = db.execute(text("SELECT column_name FROM information_schema.columns WHERE table_name = 'stock_issues'")).fetchall()
for r in res:
    print(r[0])

db.close()
