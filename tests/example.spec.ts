import { test, expect } from '@playwright/test';
import lighthouse from 'lighthouse';
//const lighthouse = require('lighthouse/core/index.cjs')
import * as chromeLauncher from 'chrome-launcher';
import { writeFile } from 'fs/promises';


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

const myCustomLHConfig: LH.Config.Json = {
  extends: 'lighthouse:default',
  settings: {
    onlyCategories: ['pwa']
  }
};

// test('lighthouse performance test', async ({ page }) => {
//   await page.goto('https://playwright.dev/');
//
//   await page.getByRole('link', { name: 'Get started' }).click();
//   await expect(page.getByRole('heading', { name: 'Installation' })).toBeVisible();
//
//   await lighthouse('https://rise8.us');
// });

const sitePages = ['https://www.rise8.us',
  'https://www.rise8.us/about',
    'https://www.rise8.us/careers']

    // https://www.rise8.us/cato-report
    //
    // https://www.rise8.us/contact
    //
    // https://www.rise8.us/privacy-policy
    //
    // https://www.rise8.us/prodacity
    //
    // https://www.rise8.us/resource/blog
    //
    // https://www.rise8.us/solutions/solutions
    //
    // https://www.rise8.us/solutions/tracer
    //
    // https://www.rise8.us/event-rsvp
    //
    // https://www.rise8.us/resources/a-defense-modernization-story]


test('another test', async ({ page }) => {
  const chrome = await chromeLauncher.launch();

  const { myCustomLHConfig } = await import('./lh-config-ts');

  // for (const pageName of sitePages) {
  //   const results = await lighthouse(
  //       pageName,
  //       {
  //         port: chrome.port,
  //         output: 'html'
  //       },
  //       myCustomLHConfig
  //   );
  //   //var urlRegex = /(https?:\/\/[^\s]+)/;
  //   const simplifiedUrl = pageName.replace('https://www.', '');
  //   console.log(simplifiedUrl);
  // //const fileName = simplifiedUrl.concat('lh-report.html');
  //   //await writeFile(fileName, results.report);
  //   chrome.kill();
  // }

  const results = await lighthouse(
      'https://www.rise8.us',
      {
        port: chrome.port,
        output: 'html'
      },
      myCustomLHConfig
  );

  await writeFile('./lh-local_preset-report1.html', results.report);
  await chrome.kill();
});

