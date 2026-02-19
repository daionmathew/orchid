from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

issue_id = 49
res = db.execute(text("SELECT booking_id, notes FROM stock_issues WHERE id = :id"), {"id": issue_id}).fetchone()
print(f"Issue 49: {res}")

db.close()
