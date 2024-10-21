FROM --platform=arm64 python:3.12.7-slim AS python
LABEL version="0.0.1"
LABEL release="k8s-python-fail"
LABEL maintainer="marcinbojko"
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txtś
COPY . .
CMD ["python", "app.py"]
