import { playAudit } from 'playwright-lighthouse';
import * as playwright from 'playwright';
import { test } from '@playwright/test';
import { describe } from 'node:test';


describe('Lighthouse Automation Test', () => {

    test('Performance Test ', async ({ browserName }) => {
        test.skip(browserName !== 'chromium', 'Still working on it');
        const browser = await playwright['chromium'].launch({
            args: ['--remote-debugging-port=9222'],
        });
        const context = await browser.newContext();
        const page = await context.newPage();
        await page.goto('https://www.rise8.us/');

        await playAudit({
            page: page,
            thresholds: {
                performance: 0,
                // accessibility: 100,
                // 'best-practices': 100,
                // seo: 100,
                // pwa: 100,
            },
            ignoreError:true,
            port: 9222,
            reports: {
                formats: {json: true},
                name: 'reports-test',
                directory: `${process.cwd()}/test-results`,
            },
        });

        await browser.close();
    });

});