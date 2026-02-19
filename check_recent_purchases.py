
import os
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def check_purchases():
    db = SessionLocal()
    try:
        result = db.execute(text("SELECT id, purchase_number, status, total_amount FROM purchase_masters ORDER BY id DESC LIMIT 5"))
        print("\n=== Recent Purchases ===")
        for row in result:
            print(row)
            
        result = db.execute(text("SELECT id, name FROM vendors LIMIT 5"))
        print("\n=== Vendors ===")
        for row in result:
            print(row)
            
        result = db.execute(text("SELECT id, name, location_type FROM locations LIMIT 5"))
        print("\n=== Locations ===")
        for row in result:
            print(row)
    except Exception as e:
        print(f"Error: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    check_purchases()
