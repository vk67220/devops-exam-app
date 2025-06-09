#FROM python:3.10-slim

# Set working directory
#WORKDIR /app

# Install Python dependencies
#COPY requirements.txt .
#RUN pip install --no-cache-dir -r requirements.txt

# Copy application files and templates folder
#COPY . .

#CMD ["python", "app.py"]

FROM python:3.10-slim

WORKDIR /app

# Copy and install dependencies
COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy backend app files
COPY backend/ .

# Copy frontend HTML files into templates folder
COPY frontend/ ./templates

CMD ["python", "app.py"]
