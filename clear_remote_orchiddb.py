
import sys
import os
from sqlalchemy import create_engine, text

# Database connection details - UPDATED FROM SERVER .ENV
DATABASE_URL = "postgresql://orchid_user:admin123@localhost/orchid_resort"

TABLES_TO_CLEAR = [
    "activity_logs", "bookings", "booking_rooms", "package_bookings", 
    "package_booking_rooms", "checkouts", "checkout_payments", 
    "checkout_verification", "checkout_requests", "service_requests", 
    "food_orders", "food_order_items", "inventory_transactions", 
    "stock_issues", "stock_issue_details", "stock_requisitions", 
    "stock_requisition_details", "stock_movements", "stock_usage", 
    "stock_levels", "location_stocks", "outlet_stocks", "linen_stocks", 
    "purchase_masters", "purchase_details", "purchase_orders", "po_items", 
    "purchase_entries", "purchase_entry_items", "goods_received_notes", 
    "grn_items", "wastage_logs", "waste_logs", "expenses", 
    "inventory_expenses", "notifications", "working_logs", 
    "maintenance_tickets", "work_orders", "work_order_parts", 
    "work_order_part_issues", "lost_found", "laundry_services", 
    "linen_movements", "linen_wash_logs", "room_consumable_assignments", 
    "room_inventory_audits", "journal_entries", "journal_entry_lines", 
    "vouchers", "payments", "key_movements", "guest_suggestions", 
    "fire_safety_incidents", "fire_safety_inspections", 
    "fire_safety_maintenance", "security_maintenance", 
    "security_uniforms", "restock_alerts", "expiry_alerts", 
    "eod_audits", "eod_audit_items", "perishable_batches", 
    "indent_items", "indents", "accounting_ledgers", 
    "assigned_services", "employee_inventory_assignments", 
    "leaves", "attendances", "salary_payments"
]

def clear_data():
    engine = create_engine(DATABASE_URL)
    with engine.connect() as conn:
        # Get list of existing tables in the database
        existing_tables_result = conn.execute(text(
            "SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname = 'public';"
        ))
        existing_tables = [row[0] for row in existing_tables_result]
        
        tables_to_truncate = [t for t in TABLES_TO_CLEAR if t in existing_tables]
        
        if not tables_to_truncate:
            print("No matching tables found to clear.")
            return

        try:
            print("=== DELETING OPERATIONAL DATA FROM orchid_resort ===")
            
            # Use one single TRUNCATE command with CASCADE to handle all dependencies
            # Traditional string building to avoid f-string backslash limitations
            table_list_str = ", ".join(['"' + t + '"' for t in tables_to_truncate])
            truncate_query = "TRUNCATE TABLE " + table_list_str + " RESTART IDENTITY CASCADE"
            
            conn.execute(text(truncate_query))
            conn.commit()
            print("  Successfully cleared " + str(len(tables_to_truncate)) + " tables.")
            
            # Reset specific statuses
            print("\n=== RESETTING MASTER DATA STATUSES ===")
            print("  - Resetting Room status to 'Available'...")
            conn.execute(text("UPDATE rooms SET status = 'Available'"))
            
            print("  - Resetting Inventory Item stock to 0...")
            conn.execute(text("UPDATE inventory_items SET current_stock = 0.0"))
            
            conn.commit()
            print("\n=== SYSTEM DATA CLEARED SUCCESSFULLY ===")
            
        except Exception as e:
            print("\n[ERROR] Cleanup Failed: " + str(e))

if __name__ == "__main__":
    clear_data()
