# Stage 1: Scraper (Node.js + Puppeteer)
FROM ghcr.io/puppeteer/puppeteer:latest AS scraper

WORKDIR /app

# Install dependencies (optimized caching layer)
COPY package.json ./
RUN npm ci --omit=dev

# Add scraping script
COPY scrape.js ./

# Allow runtime URL override
ENV SCRAPE_URL=https://example.com

# Run scraper (as CMD for runtime flexibility)
CMD ["node", "scrape.js"]

# Stage 2: Web Server (Python + Flask)
FROM python:3.10-slim AS server

WORKDIR /app

# Copy only the necessary artifacts
COPY --from=scraper /app/scraped_data.json ./
COPY server.py requirements.txt ./

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Health check and port exposure
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:5000/health || exit 1
EXPOSE 5000

# Run Flask server
CMD ["python", "server.py"]