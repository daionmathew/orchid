
import sys
import os
from sqlalchemy import create_engine, text

# Database connection details
DATABASE_URL = "postgresql://orchid_user:admin123@localhost/orchid_resort"

# We will wipe ALL inventory and transaction data to ensure a clean state
TABLES_TO_WIPE = [
    # Transactions & Operational Data
    "inventory_transactions", "stock_issues", "stock_issue_details", 
    "stock_requisitions", "stock_requisition_details", "location_stocks",
    "asset_registry", "asset_mappings", "room_assets", "room_inventory_items",
    "room_inventory_audits", "laundry_logs", "laundry_services",
    "waste_logs", "wastage_logs", "inventory_expenses", "expenses",
    "purchase_masters", "purchase_details", "purchase_orders", "po_items",
    "purchase_entries", "purchase_entry_items", "goods_received_notes", "grn_items",
    "bookings", "booking_rooms", "package_bookings", "package_booking_rooms",
    "checkouts", "checkout_payments", "checkout_requests", "service_requests",
    "food_orders", "food_order_items", "activity_logs", "notifications",
    "assigned_services", "employee_inventory_assignments",
    "leaves", "attendances", "salary_payments", "stock_movements", "stock_usage",
    "stock_levels", "outlet_stocks", "linen_stocks", "perishable_batches",
    "indent_items", "indents", "accounting_ledgers", "journal_entries", "journal_entry_lines",
    "vouchers", "payments", "lost_found", "maintenance_tickets", "work_orders",
    "working_logs", "restock_alerts", "expiry_alerts", "eod_audits", "eod_audit_items",
    
    # Master Data to be cleared for a fresh start (EXCEPT Users, Rooms, Employees, Vendors)
    "inventory_items", "inventory_categories", "food_items", "food_categories", "recipes", "recipe_ingredients",
    "service_inventory_items", "room_consumable_assignments", "room_consumable_items"
]

def full_wipe():
    engine = create_engine(DATABASE_URL)
    with engine.connect() as conn:
        # Get list of existing tables
        existing_tables_result = conn.execute(text(
            "SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname = 'public';"
        ))
        existing_tables = [row[0] for row in existing_tables_result]
        
        tables_to_truncate = [t for t in TABLES_TO_WIPE if t in existing_tables]
        
        try:
            print("=== PERFORMING COMPLETE SYSTEM WIPE (Preserving Users/Rooms/Emp/Vend) ===")
            
            if tables_to_truncate:
                table_list_str = ", ".join(['"' + t + '"' for t in tables_to_truncate])
                truncate_query = "TRUNCATE TABLE " + table_list_str + " RESTART IDENTITY CASCADE"
                conn.execute(text(truncate_query))
                print(f"  - Successfully cleared {len(tables_to_truncate)} tables.")
            
            # Reset room statuses
            conn.execute(text("UPDATE rooms SET status = 'Available'"))
            print("  - Reset all rooms to 'Available'.")
            
            conn.commit()
            print("\n=== CLEANUP COMPLETE - SYSTEM IS NOW FRESH ===")
            
        except Exception as e:
            print(f"\n[ERROR] Cleanup Failed: {e}")

if __name__ == "__main__":
    full_wipe()
