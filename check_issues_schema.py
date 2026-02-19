import os
from sqlalchemy import create_engine, inspect
from dotenv import load_dotenv

load_dotenv()
DATABASE_URL = os.getenv("DATABASE_URL")
if not DATABASE_URL:
    print("No DATABASE_URL found")
    exit(1)

engine = create_engine(DATABASE_URL)
inspector = inspect(engine)

target_tables = ["stock_issues", "stock_issue_details"]

for table_name in inspector.get_table_names():
    if table_name in target_tables:
        print(f"\nTable: {table_name}")
        for column in inspector.get_columns(table_name):
            print(f"  Column: {column['name']} ({column['type']})")
