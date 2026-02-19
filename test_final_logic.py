from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.models.inventory import PurchaseMaster, PurchaseDetail, Vendor, InventoryItem, Location, LocationStock, InventoryTransaction
from app.curd.inventory import create_purchase_master, update_purchase_status
from app.schemas.inventory import PurchaseMasterCreate, PurchaseDetailCreate
from decimal import Decimal
import datetime
import os

# Set PYTHONPATH to include ResortApp
import sys
sys.path.append(os.path.join(os.getcwd(), 'ResortApp'))

# Database setup
DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(bind=engine)
db = SessionLocal()

def test_final_purchase_logic():
    print("=== Testing Final Purchase Logic (New CRUD) ===")
    
    # Generate unique PO number
    ts = datetime.datetime.now().strftime("%H%M%S")
    po_num = f"PO-FINAL-{ts}"
    
    # 1. Prepare Data
    purchase_data = PurchaseMasterCreate(
        purchase_number=po_num,
        vendor_id=1,
        purchase_date=datetime.date.today(),
        status="received",
        destination_location_id=8, # Main Warehouse
        details=[
            PurchaseDetailCreate(
                item_id=12, # TV
                quantity=1,
                unit="pcs",
                unit_price=15000.0,
                gst_rate=18.0
            )
        ]
    )
    
    try:
        # 2. Call API-like Logic (POST)
        print(f"Creating received purchase {po_num}...")
        created = create_purchase_master(db, purchase_data, created_by=1)
        
        # Mimic API "dance"
        if created.status.lower() == "received":
            created.status = "draft"
            db.commit()
            
        print("Trigerring RECEIVED status...")
        created = update_purchase_status(db, created.id, "received", current_user_id=1)
        
        # Verify
        print(f"Status: {created.status}")
        transactions = db.query(InventoryTransaction).filter(InventoryTransaction.purchase_master_id == created.id).all()
        print(f"Transactions: {len(transactions)}")
        
        from app.models.account import JournalEntry
        entry = db.query(JournalEntry).filter(JournalEntry.reference_id == created.id, JournalEntry.reference_type == "purchase").first()
        print(f"Journal Entry: {'YES' if entry else 'NO'}")
        
        # Now test CANCELLATION
        print("Cancelling purchase...")
        created = update_purchase_status(db, created.id, "cancelled", current_user_id=1)
        print(f"New Status: {created.status}")
        
        transactions = db.query(InventoryTransaction).filter(InventoryTransaction.purchase_master_id == created.id).all()
        print(f"Total Transactions (should be 2: in then out): {len(transactions)}")
        for t in transactions:
            print(f"  - {t.transaction_type}: {t.quantity} unit @ {t.unit_price}")

    except Exception as e:
        print(f"ERROR: {str(e)}")
        import traceback
        traceback.print_exc()
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    test_final_purchase_logic()
