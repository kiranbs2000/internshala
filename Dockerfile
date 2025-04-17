# Stage 1: Scraper
FROM node:18-slim as scraper

RUN apt-get update && apt-get install -y \
    chromium \
    libx11-xcb1 libxcomposite1 libxdamage1 libxrandr2 libasound2 \
    libatk1.0-0 libatk-bridge2.0-0 libgtk-3-0 libnss3 libxss1 libxtst6 \
    fonts-liberation xdg-utils \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

WORKDIR /app
COPY scrape.js package.json ./
RUN npm install
ENV SCRAPE_URL=https://example.com
RUN node scrape.js

# Stage 2: Web Server
FROM python:3.10-slim

WORKDIR /app
COPY --from=scraper /app/scraped_data.json ./
COPY server.py requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000
CMD ["python", "server.py"]
