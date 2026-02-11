FROM python:3.11-slim

# Install GDAL and system dependencies
RUN apt-get update && apt-get install -y \
    gdal-bin \
    libgdal-dev \
    python3-gdal \
    fonts-liberation \
    && rm -rf /var/lib/apt/lists/*

# Set GDAL environment
ENV GDAL_CONFIG=/usr/bin/gdal-config

WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application
COPY . .

# Create uploads directory
RUN mkdir -p uploads

# Railway uses PORT env variable
ENV PORT=5000
EXPOSE 5000

CMD gunicorn -w 4 -b 0.0.0.0:$PORT --timeout 120 app:app
