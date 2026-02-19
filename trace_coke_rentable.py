from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
import json

DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

# EXACT logic from get_pre_checkout_verification_data
room_num = "103"
room = db.execute(text("SELECT id, inventory_location_id FROM rooms WHERE number = :rn"), {"rn": room_num}).fetchone()
loc_id = room[1]

print(f"--- Verification Data for Room {room_num} (Loc {loc_id}) ---")

# Item ID for Coke is 18
iid = 18

issue_details = db.execute(text("""
    SELECT sid.rental_price, sid.issued_quantity, sid.is_payable, sid.unit_price
    FROM stock_issue_details sid
    JOIN stock_issues si ON sid.issue_id = si.id
    WHERE sid.item_id = :iid AND si.destination_location_id = :loc_id
"""), {"iid": iid, "loc_id": loc_id}).fetchall()

# Split logic from checkout.py
rented_details = [d for d in issue_details if (d[0] and d[0] > 0)]
non_rented_details = [d for d in issue_details if not (d[0] and d[0] > 0)]

print(f"Rented details count: {len(rented_details)}")
print(f"Non-rented details count: {len(non_rented_details)}")

# Aggregation logic
is_rentable = False
if len(rented_details) > 0:
    is_rentable = True # (Simplified but matches logic)

print(f"Resulting is_rentable: {is_rentable}")

# Wait! Let's check if there is ANY other place is_rentable is set.
# Logic at line 1666: "is_rentable": data["is_rentable"]

# Let's check if r_price > 0 in ANY detail in the DB for item 18
res = db.execute(text("SELECT id, rental_price FROM stock_issue_details WHERE item_id = 18 AND rental_price > 0")).fetchall()
print(f"Any Coke issue with rental_price > 0 in the WHOLE DB: {res}")

db.close()
