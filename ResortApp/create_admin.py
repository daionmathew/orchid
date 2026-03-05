import sys
import os
sys.path.append(os.getcwd())
from app.utils.auth import get_password_hash 
from app.database import SessionLocal
from app.models.user import User, Role

def create_admin():
    db = SessionLocal()
    
    # 1. Ensure Admin Role Exists
    admin_role = db.query(Role).filter(Role.name == 'Admin').first()
    if not admin_role:
        print("Creating Admin role...")
        admin_role = Role(name='Admin', permissions='{"all": true}')
        db.add(admin_role)
        db.commit()
    
    # 2. Add Admin User
    admin_email = 'admin@orchid.com'
    admin_user = db.query(User).filter(User.email == admin_email).first()
    
    password = "admin"
    hashed_pwd = get_password_hash(password)
    
    if not admin_user:
        print(f"Creating new admin user: {admin_email} / {password} ...")
        admin_user = User(
            email=admin_email,
            name='Admin User',
            hashed_password=hashed_pwd,
            role_id=admin_role.id,
            is_active=True
        )
        db.add(admin_user)
        try:
            db.commit()
            print("✓ SUCCESS: Admin credentials created.")
        except Exception as e:
            db.rollback()
            print(f"✗ ERROR creating admin: {e}")
    else:
        print(f"Admin user {admin_email} already exists. Resetting password to: '{password}' ...")
        admin_user.hashed_password = hashed_pwd
        if not admin_user.role_id:
            admin_user.role_id = admin_role.id
        admin_user.is_active = True
        try:
            db.commit()
            print("✓ SUCCESS: Admin credentials updated.")
        except Exception as e:
            db.rollback()
            print(f"✗ ERROR updating admin: {e}")

if __name__ == "__main__":
    create_admin()
