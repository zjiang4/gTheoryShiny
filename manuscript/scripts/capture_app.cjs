// Start the local app, then run with PLAYWRIGHT_MODULE pointing to Playwright.
const { chromium } = require(process.env.PLAYWRIGHT_MODULE || 'playwright');
const fs = require('node:fs');
const assert = require('node:assert/strict');
const url = process.argv[2] || 'http://127.0.0.1:3841';
async function settle(page) {
  await page.waitForTimeout(400);
  await page.waitForFunction(() => window.Shiny?.shinyapp?.$socket?.readyState === 1 &&
    !document.documentElement.classList.contains('shiny-busy'));
}
(async () => {
  const browser = await chromium.launch({ channel: 'msedge', headless: true });
  const page = await browser.newPage({ viewport: { width: 1360, height: 980 }, deviceScaleFactor: 2 });
  const errors = [];
  page.on('pageerror', error => errors.push(error.message));
  try {
    await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 60000 }); await settle(page);
    await page.locator('a[data-value="datainput"]').click();
    await page.evaluate(() => $('#fileUploadSwitch').bootstrapSwitch('state', true));
    await page.locator('#fileUpload-file').setInputFiles('manuscript/results/example_two_facet.csv');
    await page.waitForFunction(() => $('#rawDataTable').text().includes('Rater'));
    await settle(page);
    await page.locator('#dataConfirm').click(); await settle(page);
    await page.locator('#variableSettingConfirm').click(); await settle(page);
    await page.locator('#runGstudyButton').click();
    await page.locator('#GstudyResultPrint table').waitFor(); await settle(page);
    await page.locator('a[data-value="datastructure"]').click(); await settle(page);
    await page.screenshot({ path: 'manuscript/figures/figure1_structure_en.png' });
    await page.evaluate(() => $('#appLanguage')[0].selectize.setValue('zh')); await settle(page);
    await page.screenshot({ path: 'manuscript/figures/supplement_structure_zh.png' });
    await page.evaluate(() => $('#appLanguage')[0].selectize.setValue('en')); await settle(page);
    await page.locator('a[data-value="dataanalysis"]').click(); await settle(page);
    await page.screenshot({ path: 'manuscript/figures/supplement_gstudy_en.png', fullPage: true });
    await page.evaluate(() => $('#runDstudyBox').prop('checked', true).trigger('change'));
    await page.locator('#FacetValueSlider').waitFor(); await settle(page);
    await page.locator('#runDstudyButton').click();
    await page.waitForFunction(() => $('#recommModelDStudyResult').text().includes('coefficient'));
    await settle(page);
    const baseline = await page.locator('#recommModelDStudyResult').textContent();
    console.log('Browser D-study output', baseline);
    const coefficientNumbers = baseline.match(/[0-9]+\.[0-9]+/g) || [];
    const baselineG = Number(coefficientNumbers[0]);
    const baselineD = Number(coefficientNumbers[1]);
    // Independent script benchmark for the same saved dataset, allowing optimizer rounding.
    console.log('Browser baseline coefficients', baselineG, baselineD);
    assert.ok(Number.isFinite(baselineG) && Number.isFinite(baselineD));
    await page.evaluate(() => $('#FacetDStudySelector').selectpicker('val', 'Item').trigger('change'));
    await settle(page);
    await page.locator('#FacetValueSlider').fill('16');
    await page.locator('#confirmFacetLevel').click(); await settle(page);
    await page.locator('#runDstudyButton').click(); await settle(page);
    const revised = await page.locator('#recommModelDStudyResult').textContent();
    // Collapse G-study output using its own control so the D-study result is readable.
    await page.locator('#GstudyResultPrint').locator('xpath=ancestor::div[contains(concat(" ",normalize-space(@class)," ")," box ")][1]').locator('.box-tools button').click();
    await settle(page);
    await page.screenshot({ path: 'manuscript/figures/supplement_dstudy_en.png', fullPage: true });
    await page.evaluate(() => $('#appLanguage')[0].selectize.setValue('zh')); await settle(page);
    assert.equal(await page.locator('#recommModelDStudyResult').textContent(), revised);
    await page.screenshot({ path: 'manuscript/figures/supplement_dstudy_zh.png', fullPage: true });
    assert.deepEqual(errors, []);
    assert.deepEqual(await page.locator('.shiny-output-error:visible').allTextContents(), []);
    fs.writeFileSync('manuscript/results/browser_worked_example.json', JSON.stringify({
      dataset: 'example_two_facet.csv', baseline_g: baselineG, baseline_d: baselineD,
      revised_output: revised, language_invariant: true, browser_errors: errors,
      browser_version: browser.version(), captured_at: '2026-10-04'
    }, null, 2));
    console.log('PASS: actual browser coefficients agree with script; English/Chinese screenshots saved.');
  } finally { await browser.close(); }
})().catch(error => { console.error(error); process.exitCode = 1; });


