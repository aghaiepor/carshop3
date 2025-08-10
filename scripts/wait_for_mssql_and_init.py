import os
import time
import pyodbc

def connect(server, user, password, database=None, timeout=5):
    conn_str = (
        "DRIVER={ODBC Driver 18 for SQL Server};"
        f"SERVER={server};UID={user};PWD={password};"
        "TrustServerCertificate=Yes;"
    )
    if database:
        conn_str += f"DATABASE={database};"
    return pyodbc.connect(conn_str, timeout=timeout)

host = os.environ.get('DB_HOST', 'sqlserver')
port = os.environ.get('DB_PORT', '1433')
server = f"{host},{port}"
user = os.environ.get('DB_USER', 'sa')
password = os.environ.get('DB_PASSWORD', 'YourStrong!Passw0rd')
db_name = os.environ.get('DB_NAME', 'carshop')

# صبر برای آماده شدن سرور
for i in range(60):
    try:
        with connect(server, user, password, database='master'):
            print("SQL Server is up.")
            break
    except Exception as e:
        print(f"Waiting for SQL Server... ({i+1}/60): {e}")
        time.sleep(2)
else:
    raise SystemExit("SQL Server not reachable after waiting.")

# ساخت دیتابیس در صورت نبود
with connect(server, user, password, database='master') as conn:
    conn.autocommit = True
    cur = conn.cursor()
    cur.execute("SELECT DB_ID(?)", db_name)
    row = cur.fetchone()
    if row and row[0]:
        print(f"Database [{db_name}] already exists.")
    else:
        print(f"Creating database [{db_name}]...")
        cur.execute(f"CREATE DATABASE [{db_name}]")
        print("Database created.")

# صبر تا دیتابیس آماده اتصال شود
for i in range(30):
    try:
        with connect(server, user, password, database=db_name):
            print(f"Connected to database [{db_name}].")
            break
    except Exception as e:
        print(f"Waiting for DB [{db_name}] to be accessible... ({i+1}/30): {e}")
        time.sleep(1)
else:
    raise SystemExit(f"Database [{db_name}] not accessible.")
