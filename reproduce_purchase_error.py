
import requests
import json

BASE_URL = "http://localhost:8000/api" # Assuming local backend
# I don't know the port for sure, but let's try 8000 or look in main.py

def test_create_purchase():
    payload = {
        "purchase_number": "PO-20260206-TEST-01",
        "vendor_id": 1,
        "purchase_date": "2026-02-06",
        "status": "received",
        "destination_location_id": 8, # Main Warehouse from my check
        "details": [
            {
                "item_id": 1, # Assuming item 1 exists
                "quantity": 10,
                "unit": "pcs",
                "unit_price": 100,
                "gst_rate": 18
            }
        ]
    }
    
    # We need a token. I'll try to find one or just see if I get 401/403 vs 500.
    # Actually, I can use the DB directly to simulate the call to inventory_crud.
    pass

if __name__ == "__main__":
    # Simulate the CRUD call directly to see where it fails
    import os
    from sqlalchemy import create_engine
    from sqlalchemy.orm import sessionmaker
    from app.curd.inventory import create_purchase_master
    from app.schemas.inventory import PurchaseMasterCreate, PurchaseDetailCreate
    from decimal import Decimal

    DATABASE_URL = "postgresql+psycopg2://postgres:qwerty123@localhost:5432/orchiddb"
    engine = create_engine(DATABASE_URL)
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
    db = SessionLocal()

    try:
        detail = PurchaseDetailCreate(
            item_id=1,
            quantity=10,
            unit="pcs",
            unit_price=Decimal("100.00"),
            gst_rate=Decimal("18.00")
        )
        data = PurchaseMasterCreate(
            purchase_number="PO-20260206-TEST-03",
            vendor_id=1,
            purchase_date="2026-02-06",
            status="received",
            destination_location_id=8,
            details=[detail]
        )
        
        print("Creating purchase master...")
        created = create_purchase_master(db, data, created_by=1)
        print(f"Created purchase ID: {created.id}")
        
        from app.curd.inventory import update_purchase_status
        print("Updating purchase status to received...")
        updated = update_purchase_status(db, created.id, "received")
        print(f"Updated status: {updated.status}")

        from app.utils.accounting_helpers import create_purchase_journal_entry
        print("Creating journal entry...")
        create_purchase_journal_entry(
            db=db,
            purchase_id=updated.id,
            created_by=1
        )
        print("Journal entry created successfully!")
        
    except Exception as e:
        import traceback
        print(f"Error: {e}")
        traceback.print_exc()
    finally:
        db.close()
