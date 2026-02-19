from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

ids = [18, 19]
print("--- Inventory Items 18, 19 ---")
res = db.execute(text("SELECT id, name, category_id, is_asset_fixed, selling_price, unit_price, gst_rate, complimentary_limit FROM inventory_items WHERE id IN :ids"), {"ids": tuple(ids)}).fetchall()
for r in res:
    print(r)
    cat = db.execute(text("SELECT name FROM inventory_categories WHERE id = :cid"), {"cid": r[2]}).fetchone()
    print(f"  Category: {cat[0] if cat else 'None'}")

db.close()
