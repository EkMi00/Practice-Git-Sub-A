FROM python:3.8-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY src/ .
COPY data/ ./data/
COPY templates/ ./templates/

# Create a directory for the models
RUN mkdir -p /app/models

CMD ["python", "app.py"]