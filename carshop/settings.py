import os
from pathlib import Path

# Base dir (fallback if not defined earlier)
try:
    BASE_DIR
except NameError:
    BASE_DIR = Path(__file__).resolve().parent.parent

def env(name: str, default: str | None = None) -> str | None:
    return os.environ.get(name, default)

DB_ENGINE = env("DB_ENGINE", "sqlite")

if DB_ENGINE == "mssql":
    # Try to use mssql-django backend if installed; otherwise fall back to SQLite
    try:
        import mssql  # noqa: F401

        DATABASES = {
            "default": {
                "ENGINE": "mssql",
                "NAME": env("DB_NAME", "carshop"),
                "USER": env("DB_USER", "sa"),
                "PASSWORD": env("DB_PASSWORD", ""),
                "HOST": env("DB_HOST", "sqlserver"),
                "PORT": env("DB_PORT", "1433"),
                "OPTIONS": {
                    "driver": env("ODBC_DRIVER", "ODBC Driver 18 for SQL Server"),
                    "TrustServerCertificate": "yes",
                },
            }
        }
    except Exception as e:
        print(f"[settings] MSSQL backend unavailable ({e!r}). Falling back to SQLite.")
        DATABASES = {
            "default": {
                "ENGINE": "django.db.backends.sqlite3",
                "NAME": str(BASE_DIR / "db.sqlite3"),
            }
        }
else:
    # Default SQLite database
    DATABASES = {
        "default": {
            "ENGINE": "django.db.backends.sqlite3",
            "NAME": str(BASE_DIR / "db.sqlite3"),
        }
    }
