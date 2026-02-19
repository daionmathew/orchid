
import sys
import os
from sqlalchemy import create_engine, text

# Database connection details
DATABASE_URL = "postgresql://orchid_user:admin123@localhost/orchid_resort"

ASSET_TABLES = [
    "asset_registry", 
    "asset_mappings", 
    "room_assets", 
    "room_inventory_items", 
    "room_inventory_audits", 
    "asset_maintenance", 
    "asset_inspections", 
    "damage_reports",
    "linen_movements",
    "linen_wash_logs",
    "laundry_logs",
    "laundry_services",
    "room_consumable_assignments"
]

def clear_assets():
    engine = create_engine(DATABASE_URL)
    with engine.connect() as conn:
        # Get list of existing tables
        existing_tables_result = conn.execute(text(
            "SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname = 'public';"
        ))
        existing_tables = [row[0] for row in existing_tables_result]
        
        tables_to_truncate = [t for t in ASSET_TABLES if t in existing_tables]
        
        try:
            print("=== CLEARING ASSET DATA FROM orchid_resort ===")
            
            if tables_to_truncate:
                table_list_str = ", ".join(['"' + t + '"' for t in tables_to_truncate])
                truncate_query = "TRUNCATE TABLE " + table_list_str + " RESTART IDENTITY CASCADE"
                conn.execute(text(truncate_query))
                print("  - Successfully truncated " + str(len(tables_to_truncate)) + " asset mapping/registry tables.")
            
            print("  - Deleting Fixed Asset items from inventory_items...")
            # We delete the master record for fixed assets
            res = conn.execute(text("DELETE FROM inventory_items WHERE is_asset_fixed = True"))
            print("  - Deleted " + str(res.rowcount) + " fixed asset entries from inventory_items.")

            # Also clear any room specific inventory mapping if any table like room_inventory_items exists
            if "room_inventory_items" in existing_tables:
                conn.execute(text("TRUNCATE TABLE room_inventory_items RESTART IDENTITY CASCADE"))
            
            conn.commit()
            print("\n=== FIXED ASSET AND ROOM ASSET DATA CLEARED SUCCESSFULLY ===")
            
        except Exception as e:
            print("\n[ERROR] Asset Cleanup Failed: " + str(e))

if __name__ == "__main__":
    clear_assets()
