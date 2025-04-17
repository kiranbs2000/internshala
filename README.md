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
