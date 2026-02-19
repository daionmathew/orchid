from app.database import SessionLocal
from app.models.inventory import Location
db = SessionLocal()
locs = db.query(Location).filter(Location.id.in_([13, 17])).all()
for l in locs:
    print(f"ID: {l.id}, Name: '{l.name}', Area: '{l.room_area}'")
db.close()
