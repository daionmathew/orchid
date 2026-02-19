from app.database import SessionLocal
from app.models.checkout import CheckoutRequest

def list_reqs():
    db = SessionLocal()
    reqs = db.query(CheckoutRequest).filter(
        CheckoutRequest.room_number == "103",
        CheckoutRequest.status == "completed"
    ).all()
    for r in reqs:
        print(f"ID:{r.id} | Date:{r.completed_at}")
    db.close()

if __name__ == "__main__":
    list_reqs()
