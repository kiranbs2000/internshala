const puppeteer = require('puppeteer');
const fs = require('fs');

(async () => {
  const url = process.env.SCRAPE_URL || 'https://example.com';

  const browser = await puppeteer.launch({
    headless: true,
    args: ['--no-sandbox', '--disable-setuid-sandbox'],
    executablePath: '/usr/bin/chromium-browser'
  });

  const page = await browser.newPage();
  await page.goto(url);

  const scrapedData = await page.evaluate(() => {
    return {
      title: document.title,
      heading: document.querySelector('h1')?.innerText || 'No H1 tag found'
    };
  });

  fs.writeFileSync('scraped_data.json', JSON.stringify(scrapedData, null, 2));

  await browser.close();
})();
