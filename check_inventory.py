from app.database import SessionLocal
from app.models.inventory import LocationStock, InventoryItem, StockIssue, StockIssueDetail
db = SessionLocal()
location_id = 13
stocks = db.query(LocationStock).filter(LocationStock.location_id == location_id).all()
print("--- Current Location Stock ---")
for s in stocks:
    item = db.query(InventoryItem).filter(InventoryItem.id == s.item_id).first()
    print(f"Item: {item.name} (ID: {item.id}), Quantity: {s.quantity}")

print("\n--- Stock Issues to this Location ---")
issues = db.query(StockIssue).filter(StockIssue.destination_location_id == location_id).all()
for issue in issues:
    print(f"Issue Number: {issue.issue_number}, Date: {issue.issue_date}")
    for detail in issue.details:
        item = db.query(InventoryItem).filter(InventoryItem.id == detail.item_id).first()
        print(f"  Item: {item.name}, Issued Qty: {detail.issued_quantity}, Is Payable: {detail.is_payable}, Rental Price: {detail.rental_price}")

db.close()
