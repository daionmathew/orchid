
from app.database import SessionLocal
from app.models.inventory import InventoryItem

db = SessionLocal()
items = db.query(InventoryItem).filter(InventoryItem.name.ilike('%Tv%')).all()

print(f"{'ID':<5} {'Name':<30} {'IsFixed':<10} {'IsRentable':<10} {'Laundry':<10}")
print("-" * 75)
for item in items:
    print(f"{item.id:<5} {item.name:<30} {html_bool(item.is_fixed_asset):<10} {html_bool(item.is_rentable):<10} {html_bool(item.track_laundry_cycle):<10}")

def html_bool(val):
    return "TRUE" if val else "FALSE"
