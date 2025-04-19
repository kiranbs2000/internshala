# Stage 1: Scraper (Node.js + Puppeteer)
FROM ghcr.io/puppeteer/puppeteer:latest AS scraper

WORKDIR /app

# First copy only package.json for dependency installation
COPY package.json ./

# Install production dependencies only
RUN npm install --omit=dev --prefer-offline --no-audit --progress=false

# Then copy the rest of application files
COPY scrape.js ./

# Configuration
ENV SCRAPE_URL=https://example.com \
    NODE_ENV=production \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

# Runtime command
CMD ["node", "scrape.js"]

# Stage 2: Web Server (Python + Flask)
FROM python:3.10-slim AS server

WORKDIR /app

# Install curl for healthchecks
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*

# Copy artifacts from scraper stage
COPY --from=scraper /app/scraped_data.json ./
COPY server.py requirements.txt ./

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Healthcheck and port configuration
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:5000/health || exit 1
EXPOSE 5000

# Runtime command
CMD ["python", "server.py"]