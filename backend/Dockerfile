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

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .                # This copies all from backend/
COPY ../frontend ./templates  # This pulls in frontend HTML files into the templates folder

CMD ["python", "app.py"]
