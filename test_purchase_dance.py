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

def test_create_received_purchase():
    print("=== Testing Create Received Purchase (with draft dance) ===")
    
    # 1. Prepare Data
    purchase_data = PurchaseMasterCreate(
        purchase_number="PO-DANCE-04",
        vendor_id=1,
        purchase_date=datetime.date.today(),
        status="received",
        destination_location_id=8, # Main Warehouse
        details=[
            PurchaseDetailCreate(
                item_id=12, # TV (Exists)
                quantity=2,
                unit="pcs",
                unit_price=10000.0,
                gst_rate=18.0
            )
        ]
    )
    
    try:
        # 2. Mimic API Logic
        print("Step 1: Calling create_purchase_master...")
        created = create_purchase_master(db, purchase_data, created_by=1)
        print(f"Created purchase ID: {created.id}, status: {created.status}, details: {len(created.details)}")
        
        if purchase_data.status.lower() == "received":
            print("Step 2: Performing draft dance...")
            if created.status.lower() == "received":
                created.status = "draft"
                db.commit()
                print(f"Committed status to 'draft'. Details after commit: {len(created.details)}")
            
            db.expire_all()
            
            print("Step 3: Calling update_purchase_status('received')...")
            created = update_purchase_status(db, created.id, "received")
            print(f"Update successful. New status: {created.status}")
            
            # Check for transactions
            transactions = db.query(InventoryTransaction).filter(
                InventoryTransaction.purchase_master_id == created.id
            ).all()
            print(f"Transactions in DB for PO {created.id}: {len(transactions)}")
            for t in transactions:
                print(f"  Transaction ID: {t.id}, Type: {t.transaction_type}, Qty: {t.quantity}")
                
            # Check for location stock
            loc_stock = db.query(LocationStock).filter(
                LocationStock.location_id == 8,
                LocationStock.item_id == 12
            ).first()
            if loc_stock:
                print(f"Location Stock Detail - Item 12 at Loc 8: {loc_stock.quantity}")
            else:
                print("ERROR: No location stock found!")

    except Exception as e:
        print(f"ERROR: {str(e)}")
        import traceback
        traceback.print_exc()
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    test_create_received_purchase()
