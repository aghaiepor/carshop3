import os

try:
    import importlib
    importlib.import_module("mssql")
    HAVE_MSSQL = True
except Exception:
    HAVE_MSSQL = False

DB_ENGINE = os.getenv("DB_ENGINE", "sqlite").lower()
DB_HOST = os.getenv("DB_HOST", "sqlserver")
DB_PORT = os.getenv("DB_PORT", "1433")
DB_NAME = os.getenv("DB_NAME", "carshop")
DB_USER = os.getenv("DB_USER", "sa")
DB_PASSWORD = os.getenv("DB_PASSWORD", "")

if DB_ENGINE == "mssql" and HAVE_MSSQL:
    DATABASES = {
        "default": {
            "ENGINE": "mssql",
            "NAME": DB_NAME,
            "USER": DB_USER,
            "PASSWORD": DB_PASSWORD,
            "HOST": DB_HOST,
            "PORT": DB_PORT,
            "OPTIONS": {
                "driver": "ODBC Driver 18 for SQL Server",
                "extra_params": "TrustServerCertificate=Yes;Encrypt=Yes",
            },
        }
    }
else:
    # Fallback to SQLite to avoid crashes when mssql backend isn't present
    # Assumes BASE_DIR is already defined in settings (standard Django layout)
    DATABASES = {
        "default": {
            "ENGINE": "django.db.backends.sqlite3",
            "NAME": os.path.join(BASE_DIR, "db.sqlite3"),  # noqa: F821
        }
    }

DEBUG = bool(int(os.getenv("DJANGO_DEBUG", "1")))
SECRET_KEY = os.getenv("DJANGO_SECRET_KEY", "dev-secret-key-change-me")

# ** rest of code here **
