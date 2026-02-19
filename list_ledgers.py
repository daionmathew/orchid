import psycopg2
from psycopg2.extras import RealDictCursor

def check_ledgers():
    try:
        conn = psycopg2.connect("dbname=orchid_resort user=postgres")
        cur = conn.cursor(cursor_factory=RealDictCursor)
        
        query = """
        SELECT al.name as ledger, ag.name as group_name 
        FROM account_ledgers al 
        JOIN account_groups ag ON al.group_id = ag.id 
        ORDER BY ag.name;
        """
        cur.execute(query)
        rows = cur.fetchall()
        
        print(f"{'Ledger':<40} | {'Group'}")
        print("-" * 60)
        for row in rows:
            print(f"{row['ledger']:<40} | {row['group_name']}")
            
        cur.close()
        conn.close()
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    check_ledgers()
