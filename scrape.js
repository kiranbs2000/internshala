const puppeteer = require('puppeteer');
const fs = require('fs');

const url = process.env.SCRAPE_URL || 'https://example.com';

(async () => {
  const browser = await puppeteer.launch({
    headless: "new",
    args: [
      '--no-sandbox',
      '--disable-setuid-sandbox',
      '--disable-dev-shm-usage'
    ]
  });

  try {
    const page = await browser.newPage();
    await page.setViewport({ width: 1280, height: 800 });
    
    console.log(`Scraping URL: ${url}`);
    await page.goto(url, { 
      waitUntil: 'networkidle2',
      timeout: 15000 
    });

    // Wait for critical elements
    await page.waitForSelector('h1', { timeout: 5000 });

    const data = await page.evaluate(() => ({
      title: document.title,
      heading: document.querySelector('h1')?.innerText.trim() || 'No H1 found',
      url: window.location.href,
      timestamp: new Date().toISOString()
    }));

    fs.writeFileSync('scraped_data.json', JSON.stringify(data, null, 2));
    console.log('Successfully saved scraped data');
  } catch (err) {
    console.error('Scraping failed:', err);
    process.exit(1);
  } finally {
    await browser.close();
  }
})();