import { playAudit } from 'playwright-lighthouse';
import * as playwright from 'playwright';
import { test } from '@playwright/test';
import { describe } from 'node:test';
import axios from 'axios';
import xmljs from 'xml-js';

describe('Lighthouse Automation Test', () => {

    test('Performance Test ', async ({ browserName }) => {
        let  data: { urlset: { url: { loc: { _text: any; }; }[]; }; };
        try {
            const response = await axios.get("https://www.rise8.us/sitemap.xml").then((response) => {
                data = JSON.parse(
                    xmljs.xml2json(response.data, { compact: true, spaces: 2 })
                );
            });
        } catch (error) {
            throw new Error("Failed to fetch website urls. Exiting.");
        }

        test.setTimeout(3000000);
        test.skip(browserName !== 'chromium', 'Still working on it');

        for (let i = 0; i < data.urlset.url.length; i++) {
            const browser = await playwright['chromium'].launch({
                args: ['--remote-debugging-port=9222'],
            });
            const context = await browser.newContext();
            const page = await context.newPage();
            const url = data.urlset.url[i].loc._text
            await page.goto(url);
            let fileName=url.replace('https:\/\/www\.', '').replace('\.', '-').replace('/\s/g', "").trim().split('/').join('-');
            console.log(fileName);

            await playAudit({
                page: page,
                thresholds: {
                    performance: 90,
                    accessibility: 90,
                    'best-practices': 90,
                    seo: 90,
                    pwa: 90,
                },
                ignoreError: true,
                port: 9222,
                reports: {
                    formats: {json: true},
                    name: fileName,
                    directory: `${process.cwd()}/lighthouse-reports`,
                },
            });
            await browser.close();
        }
    });

});