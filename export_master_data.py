import json
from app.database import get_db
from sqlalchemy import text

def export_master_data():
    """Export inventory items, categories, vendors, and location stocks"""
    db = next(get_db())
    
    data = {
        'inventory_categories': [],
        'inventory_items': [],
        'vendors': [],
        'locations': [],
        'location_stocks': []
    }
    
    # Export Categories
    categories = db.execute(text("""
        SELECT id, name, description, created_at, updated_at
        FROM inventory_categories
        ORDER BY id
    """)).fetchall()
    
    for cat in categories:
        data['inventory_categories'].append({
            'id': cat[0],
            'name': cat[1],
            'description': cat[2],
            'created_at': str(cat[3]) if cat[3] else None,
            'updated_at': str(cat[4]) if cat[4] else None
        })
    
    # Export Inventory Items
    items = db.execute(text("""
        SELECT id, name, category_id, unit, reorder_level, is_consumable, 
               is_rentable, is_fixed_asset, rental_price_per_day, 
               purchase_price, selling_price, gst_percentage, hsn_code,
               created_at, updated_at
        FROM inventory_items
        ORDER BY id
    """)).fetchall()
    
    for item in items:
        data['inventory_items'].append({
            'id': item[0],
            'name': item[1],
            'category_id': item[2],
            'unit': item[3],
            'reorder_level': float(item[4]) if item[4] else 0,
            'is_consumable': item[5],
            'is_rentable': item[6],
            'is_fixed_asset': item[7],
            'rental_price_per_day': float(item[8]) if item[8] else None,
            'purchase_price': float(item[9]) if item[9] else None,
            'selling_price': float(item[10]) if item[10] else None,
            'gst_percentage': float(item[11]) if item[11] else 0,
            'hsn_code': item[12],
            'created_at': str(item[13]) if item[13] else None,
            'updated_at': str(item[14]) if item[14] else None
        })
    
    # Export Vendors
    vendors = db.execute(text("""
        SELECT id, name, contact_person, phone, email, address, 
               gst_number, created_at, updated_at
        FROM vendors
        ORDER BY id
    """)).fetchall()
    
    for vendor in vendors:
        data['vendors'].append({
            'id': vendor[0],
            'name': vendor[1],
            'contact_person': vendor[2],
            'phone': vendor[3],
            'email': vendor[4],
            'address': vendor[5],
            'gst_number': vendor[6],
            'created_at': str(vendor[7]) if vendor[7] else None,
            'updated_at': str(vendor[8]) if vendor[8] else None
        })
    
    # Export Locations
    locations = db.execute(text("""
        SELECT id, name, location_type, description, created_at, updated_at
        FROM locations
        ORDER BY id
    """)).fetchall()
    
    for loc in locations:
        data['locations'].append({
            'id': loc[0],
            'name': loc[1],
            'location_type': loc[2],
            'description': loc[3],
            'created_at': str(loc[4]) if loc[4] else None,
            'updated_at': str(loc[5]) if loc[5] else None
        })
    
    # Export Location Stocks
    stocks = db.execute(text("""
        SELECT id, location_id, item_id, quantity, last_updated
        FROM location_stocks
        ORDER BY id
    """)).fetchall()
    
    for stock in stocks:
        data['location_stocks'].append({
            'id': stock[0],
            'location_id': stock[1],
            'item_id': stock[2],
            'quantity': float(stock[3]) if stock[3] else 0,
            'last_updated': str(stock[4]) if stock[4] else None
        })
    
    # Save to JSON file
    with open('master_data_export.json', 'w') as f:
        json.dump(data, f, indent=2)
    
    print(f"✅ Exported:")
    print(f"  - {len(data['inventory_categories'])} Categories")
    print(f"  - {len(data['inventory_items'])} Inventory Items")
    print(f"  - {len(data['vendors'])} Vendors")
    print(f"  - {len(data['locations'])} Locations")
    print(f"  - {len(data['location_stocks'])} Location Stocks")
    print(f"\n📁 Saved to: master_data_export.json")

if __name__ == "__main__":
    export_master_data()
