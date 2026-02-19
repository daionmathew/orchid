from app.database import SessionLocal
from app.models.checkout import CheckoutRequest as CheckoutRequestModel
db = SessionLocal()
req = db.query(CheckoutRequestModel).filter(CheckoutRequestModel.id == 24).first()
if req:
    print(f"Request 24 status: {req.status}")
    # Check for inventory verification data if any (though status is in_progress)
db.close()
