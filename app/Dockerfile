FROM python:3.11.8-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

CMD ["streamlit", "run", "--server.address", "0.0.0.0", "--server.port", "80", "app.py"]
EXPOSE 80