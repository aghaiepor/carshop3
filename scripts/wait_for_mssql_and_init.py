import os
import time
import sys

import pyodbc

HOST = os.environ.get("DB_HOST", "sqlserver")
PORT = os.environ.get("DB_PORT", "1433")
USER = os.environ.get("DB_USER", "sa")
PASSWORD = os.environ.get("DB_PASSWORD", "")
DBNAME = os.environ.get("DB_NAME", "carshop")

SERVER = f"{HOST},{PORT}"
DRIVER = os.environ.get("ODBC_DRIVER", "ODBC Driver 18 for SQL Server")

MASTER_CS = (
    f"DRIVER={{{DRIVER}}};"
    f"SERVER={SERVER};"
    "DATABASE=master;"
    f"UID={USER};PWD={PASSWORD};"
    "TrustServerCertificate=Yes;"
    "Connection Timeout=5;"
)

TARGET_CS = (
    f"DRIVER={{{DRIVER}}};"
    f"SERVER={SERVER};"
    f"DATABASE={DBNAME};"
    f"UID={USER};PWD={PASSWORD};"
    "TrustServerCertificate=Yes;"
    "Connection Timeout=5;"
)

def wait_for_port(max_attempts: int = 60, delay: float = 2.0):
    for attempt in range(1, max_attempts + 1):
        try:
            with pyodbc.connect(MASTER_CS.format(DRIVER=DRIVER), timeout=5):
                print(f"[wait_for_mssql] SQL Server is reachable (attempt {attempt}).")
                return
        except Exception as e:
            print(f"[wait_for_mssql] Not ready yet: {e!r} (attempt {attempt}/{max_attempts})")
            time.sleep(delay)
    print("[wait_for_mssql] ERROR: SQL Server did not become ready in time.", file=sys.stderr)
    sys.exit(1)

def ensure_database():
    print(f"[wait_for_mssql] Ensuring database '{DBNAME}' exists...")
    with pyodbc.connect(MASTER_CS.format(DRIVER=DRIVER), autocommit=True) as conn:
        cur = conn.cursor()
        cur.execute("SELECT COUNT(*) FROM sys.databases WHERE name = ?", DBNAME)
        exists = cur.fetchone()[0] > 0
        if not exists:
            cur.execute(f"CREATE DATABASE [{DBNAME}]")
            print(f"[wait_for_mssql] Created database '{DBNAME}'.")
        else:
            print(f"[wait_for_mssql] Database '{DBNAME}' already exists.")

def test_target_connection():
    with pyodbc.connect(TARGET_CS.format(DRIVER=DRIVER), timeout=5) as conn:
        cur = conn.cursor()
        cur.execute("SELECT DB_NAME()")
        print(f"[wait_for_mssql] Connected to DB: {cur.fetchone()[0]}")

def main():
    wait_for_port()
    ensure_database()
    # Give SQL Server a moment after creation
    time.sleep(2)
    test_target_connection()

if __name__ == "__main__":
    main()
