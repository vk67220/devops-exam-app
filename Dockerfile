FROM python:3.10-slim

WORKDIR /app

# Copy dependencies and install
COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy backend source code
COPY backend/ .

# Copy frontend HTML files to templates directory
COPY frontend/ ./templates

CMD ["python", "app.py"]
