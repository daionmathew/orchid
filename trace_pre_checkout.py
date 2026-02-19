from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
import json

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

# Mocking the get_pre_checkout_verification_data logic partially
room_number = "103"
room = db.execute(text("SELECT id, inventory_location_id FROM rooms WHERE number = :rn"), {"rn": room_number}).fetchone()
loc_id = room[1]

print(f"--- Verification Data Mock for Room {room_number} (Loc {loc_id}) ---")

# From checkout.py logic
# 1. Fetch Consumables
loc_stocks = db.execute(text("""
    SELECT ls.item_id, ls.quantity, i.name, ic.classification, i.is_asset_fixed, ic.is_asset_fixed
    FROM location_stocks ls
    JOIN inventory_items i ON ls.item_id = i.id
    JOIN inventory_categories ic ON i.category_id = ic.id
    WHERE ls.location_id = :loc_id AND ic.classification != 'Asset'
"""), {"loc_id": loc_id}).fetchall()

for stock in loc_stocks:
    iid, qty, name, classif, i_fixed, c_fixed = stock
    print(f"Item: {name} (ID {iid}), Stock: {qty}")
    
    issue_details = db.execute(text("""
        SELECT sid.rental_price, sid.issued_quantity, sid.is_payable
        FROM stock_issue_details sid
        JOIN stock_issues si ON sid.issue_id = si.id
        WHERE sid.item_id = :iid AND si.destination_location_id = :loc_id
    """), {"iid": iid, "loc_id": loc_id}).fetchall()
    
    rented_details = [d for d in issue_details if (d[0] and d[0] > 0)]
    print(f"  Rented details count: {len(rented_details)}")
    rented_qty_total = sum(d[1] for d in rented_details)
    print(f"  Rented qty total: {rented_qty_total}")

db.close()
