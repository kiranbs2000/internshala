Web-Scraper-app Project
This project scrapes data from a user-provided website using Puppeteer (Node.js) and hosts the result using Flask (Python). It utilizes a multi-stage Docker build for optimization, ensuring a lightweight production-friendly Docker image.

📌 Features
Scrapes the page title and the first <h1> tag from a user-provided URL.

Serves the scraped data as JSON via HTTP using a Flask API.

Multi-stage Docker build for optimized image size, separating the scraping process and the Flask serving stage.

Lightweight and production-ready Docker container.

🛠️ Build the Docker Image
To build the Docker image for this project, follow these steps:

Clone this repository or download the project files.

Open a terminal/command prompt and navigate to the project directory.

Build the Docker image using the following command:

docker build -t Web-Scraper-app .
This will create a Docker image named Web-Scraper-app.

🚀 Run the Docker Container
To run the Docker container, use the following command:

docker run -p 5000:5000 Web-Scraper-app
This will start the Flask API, and you can access the service at http://localhost:5000.

🔧 How It Works
Puppeteer (Node.js Stage):

The first stage of the Dockerfile uses Puppeteer in Node.js to scrape the content from a user-specified URL.

It extracts the page title and the first <h1> tag from the HTML of the page.

The data is saved as a JSON object.

Flask (Python Stage):

The second stage of the Dockerfile sets up a Python Flask app to serve the scraped data over HTTP.

The Flask API listens for requests on port 5000 and returns the scraped content in JSON format.


