import { test, expect } from '@playwright/test';
//import lighthouse from "lighthouse";


test('has title', async ({ page }) => {

  await page.goto('https://playwright.dev/');
  await page.pause();

  // Expect a title "to contain" a substring.
  await expect(page).toHaveTitle(/Playwright/);
});

test('get started link', async ({ page }) => {
  await page.goto('https://playwright.dev/');

  // Click the get started link.
  await page.getByRole('link', { name: 'Get started' }).click();

  // Expects page to have a heading with the name of Installation.
  await expect(page.getByRole('heading', { name: 'Installation' })).toBeVisible();
});

test('lighthouse performance test', async ({ page }) => {

  await lighthouse('https://playwright.dev/', {port: 9222});
});
//import config from './path/to/custom-config.js';

// const { chromium } = require('playwright');
import lighthouse from 'lighthouse';
test('lighthouse performance test2', async () => {
  // Launch the browser
  const browser = await chromium.launch();
  // Create a new page
  const page = await browser.newPage();
  // Navigate to the website you want to test
  await page.goto('https://example.com');
  // Run Lighthouse audit
  const { lhr } = await lighthouse(page.url(), {
    port: new URL(browser.wsEndpoint()).port,
    output: 'json',
  });
  // Access the performance score
  const performanceScore = lhr.categories.performance.score;
  // Output the performance score
  console.log(`Performance Score: ${performanceScore * 100}`);
  // Close the browser
  await browser.close();
});

