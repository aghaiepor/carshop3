import os
import time
import sys
from typing import Optional

import pyodbc

HOST = os.environ.get("DB_HOST", "sqlserver")
PORT = os.environ.get("DB_PORT", "1433")
USER = os.environ.get("DB_USER", "sa")
PASSWORD = os.environ.get("DB_PASSWORD", "YourStrong!Passw0rd#2024")
DB_NAME = os.environ.get("DB_NAME", "carshop")

MASTER_CS = (
    "DRIVER={ODBC Driver 18 for SQL Server};"
    f"SERVER={HOST},{PORT};"
    f"UID={USER};PWD={PASSWORD};"
    "Encrypt=yes;TrustServerCertificate=yes;"
    "DATABASE=master"
)

TARGET_CS = (
    "DRIVER={ODBC Driver 18 for SQL Server};"
    f"SERVER={HOST},{PORT};"
    f"UID={USER};PWD={PASSWORD};"
    "Encrypt=yes;TrustServerCertificate=yes;"
    f"DATABASE={DB_NAME}"
)

def wait_for_port():
    while True:
        try:
            with pyodbc.connect(MASTER_CS, timeout=5) as conn:
                return
        except Exception as e:
            print(f"[wait_for_mssql] SQL not ready yet: {e}")
            time.sleep(2)

def ensure_database():
    with pyodbc.connect(MASTER_CS, timeout=10, autocommit=True) as conn:
        cur = conn.cursor()
        cur.execute("SELECT name FROM sys.databases WHERE name = ?", DB_NAME)
        row = cur.fetchone()
        if row:
            print(f"[wait_for_mssql] Database '{DB_NAME}' already exists.")
            return
        print(f"[wait_for_mssql] Creating database '{DB_NAME}' ...")
        cur.execute(f"CREATE DATABASE [{DB_NAME}]")
        print(f"[wait_for_mssql] Created database '{DB_NAME}'.")

def check_target_db():
    for _ in range(10):
        try:
            with pyodbc.connect(TARGET_CS, timeout=5) as conn:
                cur = conn.cursor()
                cur.execute("SELECT 1")
                cur.fetchone()
                print(f"[wait_for_mssql] Connected to '{DB_NAME}'.")
                return True
        except Exception as e:
            print(f"[wait_for_mssql] Waiting for '{DB_NAME}' to be ready: {e}")
            time.sleep(2)
    return False

def get_env(name: str, default: Optional[str] = None) -> str:
    v = os.environ.get(name, default)
    if v is None:
        print(f"Missing required env var: {name}", file=sys.stderr)
        sys.exit(1)
    return v

def connect(server: str, database: Optional[str], user: str, password: str, timeout: int = 3):
    db_part = f";DATABASE={database}" if database else ""
    conn_str = (
        f"DRIVER={{ODBC Driver 18 for SQL Server}};"
        f"SERVER={server};"
        f"UID={user};PWD={password};"
        f"TrustServerCertificate=Yes;"
        f"Connection Timeout={timeout}"
        f"{db_part};"
    )
    return pyodbc.connect(conn_str)

def main():
    host = get_env("DB_HOST", "sqlserver")
    port = int(get_env("DB_PORT", "1433"))
    user = get_env("DB_USER", "sa")
    password = get_env("DB_PASSWORD", "YourStrong!Passw0rd")
    target_db = get_env("DB_NAME", "carshop")

    server = f"{host},{port}"

    # Wait for TCP/SQL to be ready
    max_attempts = 60
    for attempt in range(1, max_attempts + 1):
        try:
            with connect(server, None, user, password, timeout=3) as conn:
                print("Connected to SQL Server (master)")
                break
        except Exception as e:
            print(f"Attempt {attempt}/{max_attempts} - SQL not ready yet: {e}")
            time.sleep(2)
    else:
        print("SQL Server did not become ready in time", file=sys.stderr)
        sys.exit(1)

    # Ensure database exists
    try:
        with connect(server, "master", user, password, timeout=5) as conn:
            conn.autocommit = True
            cur = conn.cursor()
            # Use brackets to avoid injection and handle special names
            cur.execute(f"IF DB_ID(?) IS NULL EXEC('CREATE DATABASE [{target_db}]');", (target_db,))
            print(f"Ensured database exists: {target_db}")
    except Exception as e:
        print(f"Failed to ensure database: {e}", file=sys.stderr)
        sys.exit(1)

    # Quick smoke query against target DB
    try:
        with connect(server, target_db, user, password, timeout=5) as conn:
            cur = conn.cursor()
            cur.execute("SELECT DB_NAME();")
            row = cur.fetchone()
            print(f"Connected to DB: {row[0]}")
    except Exception as e:
        print(f"Smoke test failed: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    print(f"[wait_for_mssql] Waiting for TCP and login to {HOST}:{PORT} ...")
    wait_for_port()
    ensure_database()
    ok = check_target_db()
    if not ok:
        raise SystemExit("[wait_for_mssql] Could not connect to target DB after creation.")
