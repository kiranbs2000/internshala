# Stage 1: Scraper
FROM ghcr.io/puppeteer/puppeteer:latest as scraper

WORKDIR /app

# Install dependencies first (for cache)
COPY package.json ./
RUN npm install

# Add the scraping script
COPY scrape.js ./

# Set default URL (can be overridden at runtime)
ARG SCRAPE_URL=https://example.com
ENV SCRAPE_URL=$SCRAPE_URL

# Run scraper
RUN node scrape.js

# Stage 2: Flask Web Server
FROM python:3.10-slim

WORKDIR /app

COPY --from=scraper /app/scraped_data.json ./
COPY server.py requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000
CMD ["python", "server.py"]

