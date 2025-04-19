const puppeteer = require('puppeteer');
const fs = require('fs');

const url = process.env.SCRAPE_URL || 'https://example.com';

(async () => {
  try {
    const browser = await puppeteer.launch({
      headless: "new",
      args: ['--no-sandbox', '--disable-setuid-sandbox']
    });

    const page = await browser.newPage();
    await page.goto(url);

    const data = await page.evaluate(() => {
      return {
        title: document.title,
        heading: document.querySelector('h1')?.innerText || 'No H1 found'
      };
    });

    fs.writeFileSync('scraped_data.json', JSON.stringify(data, null, 2));
    console.log('Scraped data saved!');
    await browser.close();
  } catch (err) {
    console.error('Scraping failed:', err);
    process.exit(1);
  }
})();
