#FROM python:3.10-slim

# Set working directory
#WORKDIR /app

# Install Python dependencies
#COPY requirements.txt .
#RUN pip install --no-cache-dir -r requirements.txt

# Copy application files and templates folder
#COPY . .

#CMD ["python", "app.py"]

# Use slim Python 3.10 base image
FROM python:3.10-slim

# Set working directory inside container
WORKDIR /app

# Copy only backend requirements first for better caching
COPY backend/requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy backend source code
COPY backend /app/backend

# Copy frontend source code (HTML templates)
COPY frontend /app/frontend

# Set environment variables if needed
ENV FLASK_APP=/app/backend/app.py
ENV FLASK_ENV=production

# Expose port 5000 for Flask app
EXPOSE 5000

# Start the Flask application (adjust path if needed)
CMD ["python", "/app/backend/app.py"]

