from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
from app.models.checkout import CheckoutRequest
from app.models.inventory import StockIssue, StockIssueDetail, InventoryItem
from app.database import Base, SQLALCHEMY_DATABASE_URL as DATABASE_URL
import json

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
db = SessionLocal()

print("--- Inspecting Checkout Data for Room 103 ---")

# 1. Check Checkout Request
cr = db.query(CheckoutRequest).filter(CheckoutRequest.room_number == "103").order_by(CheckoutRequest.id.desc()).first()

if cr:
    print(f"Found Checkout Request ID: {cr.id}")
    print(f"Status: {cr.status}")
    print(f"Inventory Checked: {cr.inventory_checked}")
    
    if cr.inventory_data:
        print("\nInventory Data Content:")
        try:
            # It's likely already a dict/list if using SQLAlchemy with JSON type, but let's handle it
            data = cr.inventory_data
            if isinstance(data, str):
                data = json.loads(data)
            
            for item in data:
                name = item.get('item_name', 'Unknown')
                used = item.get('used_qty', 0)
                missing = item.get('missing_qty', 0)
                charge = item.get('total_charge', 0)
                payable_qty = item.get('payable_usage_qty', 0)
                comp_limit = item.get('complimentary_limit', 0)
                
                if used > 0 or missing > 0 or charge > 0:
                     print(f" - {name}: Used={used}, Missing={missing}, PayQty={payable_qty}, Limit={comp_limit}, Charge={charge}")
        except Exception as e:
            print(f"Error parse inventory: {e}")
    else:
        print("Inventory Data is Empty")

else:
    print("No Checkout Request found for Room 103")

# 2. Check Stock Issues (Fallback source)
print("\n--- Recent Stock Issues for Room 103 ---")
# Need to find location ID for room 103 first
from app.models.room import Room
room = db.query(Room).filter(Room.number == "103").first()
if room and room.inventory_location_id:
    issues = db.query(StockIssue).filter(StockIssue.destination_location_id == room.inventory_location_id).order_by(StockIssue.issue_date.desc()).limit(5).all()
    if issues:
        for issue in issues:
            print(f"Issue #{issue.issue_number} Date: {issue.issue_date}")
            for d in issue.details:
                 print(f"   - {d.item.name}: Qty={d.issued_quantity}, Rental=${d.rental_price}, Payable={d.is_payable}")
    else:
        print("No stock issues found.")
else:
    print("Room 103 not found or no location ID")
