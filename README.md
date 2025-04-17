# DevOps Web Scraper Project

This project scrapes data from a user-provided website using Puppeteer (Node.js) and hosts the result using Flask (Python). It uses a multi-stage Docker build for optimization.

## 📌 Features

- Scrapes the page title and first `<h1>` tag from a URL
- Serves the scraped data as JSON via HTTP
- Lightweight and production-friendly Docker image

---

## 🛠️ Build the Docker Image

```bash
docker build -t devops-scraper .

## Run the Container with a Custom URL
docker run -e SCRAPE_URL=https://example.com -p 5000:5000 devops-scraper
## Open your browser and go to:
http://localhost:5000
