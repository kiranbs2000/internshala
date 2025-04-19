# Stage 1: Node.js Scraper
FROM node:18-slim as scraper

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

RUN apt-get update && apt-get install -y chromium && rm -rf /var/lib/apt/lists/*
WORKDIR /app

COPY package.json .
RUN npm install
COPY scrape.js .

ARG SCRAPE_URL=https://example.com
ENV SCRAPE_URL=$SCRAPE_URL

RUN node scrape.js

# Stage 2: Python Flask Server
FROM python:3.10-slim

WORKDIR /app
COPY --from=scraper /app/scraped_data.json .
COPY server.py .
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000
CMD ["python", "server.py"]
