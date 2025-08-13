FROM python:3.11-slim

# Install minimal OS deps (add bash only if you need it; we use /bin/sh)
# RUN apt-get update && apt-get install -y --no-install-recommends bash && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install entrypoint into image and ensure it's executable
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh \
  && sed -i -e 's/\r$//' /usr/local/bin/entrypoint.sh

# Copy project files
COPY . .

# Create dirs
RUN mkdir -p /app/staticfiles /app/media

EXPOSE 8000

# Default command (entrypoint will exec the server)
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
