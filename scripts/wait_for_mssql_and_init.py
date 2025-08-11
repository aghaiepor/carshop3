import os
import time
import sys
from typing import Optional

import pyodbc

DB_HOST = os.getenv("DB_HOST", "sqlserver")
DB_PORT = os.getenv("DB_PORT", "1433")
DB_USER = os.getenv("DB_USER", "sa")
DB_PASSWORD = os.getenv("DB_PASSWORD", "Your@StrongP4ssw0rd")
DB_NAME = os.getenv("DB_NAME", "carshop")

DRIVER = "ODBC Driver 18 for SQL Server"
TRUST = "Yes"

def conn_str(database: Optional[str] = None) -> str:
    server = f"{DB_HOST},{DB_PORT}"
    parts = [
        f"DRIVER={{{{}}}}".format(DRIVER),
        f"SERVER={server}",
        f"UID={DB_USER}",
        f"PWD={DB_PASSWORD}",
        f"TrustServerCertificate={TRUST}",
        "Encrypt=no",
        "Connection Timeout=5",
    ]
    if database:
        parts.append(f"DATABASE={database}")
    return ";".join(parts)

def wait_for_server(timeout_seconds: int = 120) -> None:
    deadline = time.time() + timeout_seconds
    last_err = None
    while time.time() < deadline:
        try:
            with pyodbc.connect(conn_str("master")) as _:
                print("[wait] SQL Server is accepting connections.")
                return
        except Exception as e:
            last_err = e
            print(f"[wait] SQL not ready yet: {e}")
            time.sleep(2)
    print("[wait] Timeout waiting for SQL Server.", file=sys.stderr)
    if last_err:
        print(f"Last error: {last_err}", file=sys.stderr)
    sys.exit(1)

def ensure_database() -> None:
    with pyodbc.connect(conn_str("master"), autocommit=True) as cxn:
        cur = cxn.cursor()
        cur.execute("SELECT name FROM sys.databases WHERE name = ?", DB_NAME)
        row = cur.fetchone()
        if row:
            print(f"[init] Database '{DB_NAME}' already exists.")
            return
        print(f"[init] Creating database '{DB_NAME}'...")
        cur.execute(f"CREATE DATABASE [{DB_NAME}]")
        print(f"[init] Database '{DB_NAME}' created.")

if __name__ == "__main__":
    print(f"[wait] Target server {DB_HOST}:{DB_PORT}, database '{DB_NAME}'")
    wait_for_server()
    ensure_database()
