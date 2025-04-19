# Stage 1: Scraper
FROM node:18-slim AS scraper

# Install Chrome dependencies
RUN apt-get update && \
    apt-get install -y wget gnupg && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 \
      --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Configure Puppeteer
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome

WORKDIR /app
COPY package.json .
RUN npm install
COPY scrape.js .

# Run scraper during build to generate data
ARG SCRAPE_URL=https://example.com
RUN node scrape.js ${SCRAPE_URL}

# Stage 2: Server
FROM python:3.10-slim

WORKDIR /app

# Install curl for healthcheck
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*

# Copy ONLY the generated data and server files
COPY --from=scraper /app/scraped_data.json ./
COPY server.py requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Healthcheck and expose
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:5000/health || exit 1
EXPOSE 5000

CMD ["python", "server.py"]