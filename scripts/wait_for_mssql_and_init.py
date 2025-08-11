import os
import sys
import time

import pyodbc

DB_HOST = os.getenv("DB_HOST", "sqlserver")
DB_PORT = os.getenv("DB_PORT", "1433")
DB_NAME = os.getenv("DB_NAME", "carshop")
DB_USER = os.getenv("DB_USER", "sa")
DB_PASSWORD = os.getenv("DB_PASSWORD", "YourStrong!Passw0rd")
ODBC_DRIVER = os.getenv("ODBC_DRIVER", "ODBC Driver 18 for SQL Server")

SERVER = f"{DB_HOST},{DB_PORT}"
BASE_PARAMS = "TrustServerCertificate=Yes;Encrypt=Yes"

def connect(database=None, timeout=5):
    db_part = f";DATABASE={database}" if database else ""
    conn_str = f"DRIVER={{{{ {ODBC_DRIVER} }}}};SERVER={SERVER};UID={DB_USER};PWD={DB_PASSWORD};{BASE_PARAMS}{db_part}"
    return pyodbc.connect(conn_str, timeout=timeout)

def wait_for_tcp(max_attempts=60, delay=1.0):
    for attempt in range(1, max_attempts + 1):
        try:
            with connect(timeout=3) as _:
                print(f"[wait] SQL Server reachable (attempt {attempt})")
                return
        except Exception as e:
            print(f"[wait] SQL not ready (attempt {attempt}/{max_attempts}): {e}")
            time.sleep(delay)
    print("[wait] SQL Server did not become ready in time.", file=sys.stderr)
    sys.exit(1)

def ensure_database():
    # Connect to master to check/create the DB
    with connect(database="master") as conn:
        conn.autocommit = True
        cur = conn.cursor()
        cur.execute("SELECT DB_ID(?)", DB_NAME)
        row = cur.fetchone()
        if not row or row[0] is None:
            print(f"[wait] Creating database [{DB_NAME}] ...")
            cur.execute(f"CREATE DATABASE [{DB_NAME}]")
            # Wait a moment for the DB to come online
            time.sleep(2.0)
        else:
            print(f"[wait] Database [{DB_NAME}] already exists.")

    # Verify we can connect to the target DB
    for attempt in range(1, 30):
        try:
            with connect(database=DB_NAME, timeout=3) as _:
                print(f"[wait] Verified connection to DB [{DB_NAME}]")
                return
        except Exception as e:
            print(f"[wait] DB connect not ready (attempt {attempt}/30): {e}")
            time.sleep(1.0)
    print(f"[wait] Could not connect to DB [{DB_NAME}] after creation.", file=sys.stderr)
    sys.exit(2)

def main():
    print(f"[wait] Using driver: {ODBC_DRIVER}")
    print(f"[wait] Target server: {SERVER}, DB: {DB_NAME}")
    wait_for_tcp()
    ensure_database()

if __name__ == "__main__":
    main()
