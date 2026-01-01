FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Run unit tests
RUN python manage.py test

EXPOSE 8001

CMD ["python", "manage.py", "runserver", "0.0.0.0:8001"]
