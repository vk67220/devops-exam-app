FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy backend code
COPY app.py questions.py certificate.html ./

# Create templates folder
RUN mkdir -p templates

# Copy HTML templates from frontend (relative to root build context)
COPY ../frontend/*.html templates/

CMD ["python", "app.py"]
