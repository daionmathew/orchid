from app.database import SessionLocal
from app.models.inventory import StockIssue
db = SessionLocal()
issue = db.query(StockIssue).filter(StockIssue.issue_number == "ISS-20260215-001").first()
if issue:
    print(f"Issue: {issue.issue_number}, Notes: {issue.notes}")
db.close()
