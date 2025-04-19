const puppeteer = require('puppeteer');
const fs = require('fs');

const url = process.argv[2] || process.env.SCRAPE_URL || 'https://example.com';
const outputFile = 'scraped_data.json';

(async () => {
  const browser = await puppeteer.launch({
    headless: "new",
    executablePath: process.env.PUPPETEER_EXECUTABLE_PATH,
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  });

  try {
    const page = await browser.newPage();
    await page.goto(url, { waitUntil: 'networkidle2' });
    
    const data = {
      title: await page.title(),
      heading: await page.$eval('h1', el => el.textContent.trim()) || 'No H1 found',
      url: url,
      scraped_at: new Date().toISOString()
    };

    fs.writeFileSync(outputFile, JSON.stringify(data, null, 2));
    console.log(`Successfully scraped ${url}`);
  } catch (err) {
    console.error('Scraping failed:', err);
    process.exit(1);
  } finally {
    await browser.close();
  }
})();