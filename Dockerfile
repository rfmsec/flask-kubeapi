# syntax=docker/dockerfile:1
FROM python:3.8-slim-buster
RUN pip install --no-cache-dir flask kubernetes

RUN mkdir /app
WORKDIR /app
COPY server.py /app/
EXPOSE 8080

CMD ["python", "/app/server.py"]