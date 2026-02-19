import requests
import json

# Define the base URL for the API
base_url = "http://localhost:8012/api"

def get_bill(room_number):
    try:
        response = requests.get(f"{base_url}/bill/{room_number}?checkout_mode=multiple")
        if response.status_code == 200:
            data = response.json()
            print(f"--- Bill for Room {room_number} ---")
            print(f"Guest: {data.get('guest_name')}")
            print(f"Grand Total: {data.get('grand_total')}")
            
            charges = data.get('charges', {})
            consumables = charges.get('consumables_items', [])
            
            if consumables:
                print("\nConsumables:")
                for item in consumables:
                    print(f"- {item.get('item_name')}: Qty {item.get('actual_consumed')}, Total {item.get('total_charge')}")
            else:
                print("\nNo consumables found.")
        else:
            print(f"Error: {response.status_code} - {response.text}")
    except Exception as e:
        print(f"Exception: {e}")

if __name__ == "__main__":
    get_bill("001")
