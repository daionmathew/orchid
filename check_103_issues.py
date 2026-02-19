from app.database import SessionLocal
from app.models.inventory import StockIssue, StockIssueDetail, InventoryItem
db = SessionLocal()
loc_id = 17 # Room 103
issues = db.query(StockIssue).filter(StockIssue.destination_location_id == loc_id).all()
print(f"--- Issues to Location {loc_id} (Room 103) ---")
for issue in issues:
    print(f"Ref: {issue.issue_number}, Date: {issue.issue_date}, Notes: {issue.notes}")
    for d in issue.details:
        item = db.query(InventoryItem).filter(InventoryItem.id == d.item_id).first()
        print(f"  - {item.name}: {d.issued_quantity}")
db.close()
