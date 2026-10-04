// Start the app first, then run: node tests/browser_smoke.cjs [app URL]
// Requires Playwright and Microsoft Edge, or set BROWSER_CHANNEL to chrome.
const assert = require('node:assert/strict');
const { chromium } = require(process.env.PLAYWRIGHT_MODULE || 'playwright');
const url = process.argv[2] || 'http://127.0.0.1:3838';

async function settle(page) {
  await page.waitForTimeout(250);
  await page.waitForFunction(() => window.Shiny && Shiny.shinyapp &&
    Shiny.shinyapp.$socket?.readyState === 1 &&
    !document.documentElement.classList.contains('shiny-busy'));
}

async function language(page, value) {
  await page.evaluate(value => $('#appLanguage')[0].selectize.setValue(value), value);
  await page.waitForFunction(value => document.documentElement.lang ===
    (value === 'zh' ? 'zh-CN' : 'en'), value);
  await settle(page);
}

async function study(browser, example) {
  const page = await browser.newPage();
  const errors = [];
  page.on('pageerror', error => errors.push(error.message));
  try {
    await page.goto(url);
    await settle(page);
    const labels = await page.evaluate(() => $('#appLanguage')[0].selectize.options);
    assert.equal(labels.zh.label, '中文');
    await language(page, 'zh');
    await page.locator('a[data-value="datainput"]').click();
    await page.locator(`input[name="selectedExpDat"][value="${example}"]`).check({ force: true });
    await settle(page);
    await page.locator('#dataConfirm').click();
    await page.locator('#selectedMultipleFacets').waitFor({ state: 'attached' });
    await settle(page);
    await page.evaluate(() => $('#missingMethod').selectpicker('val', 'mean').trigger('change'));
    await page.locator('#variableSettingConfirm').click();
    await settle(page);
    await page.locator('#runGstudyButton').click();
    await page.locator('#GstudyResultPrint table').waitFor();
    await settle(page);
    await page.evaluate(() => $('#runDstudyBox').prop('checked', true).trigger('change'));
    await page.locator('#FacetValueSlider').fill('12');
    await page.locator('#confirmFacetLevel').click();
    await settle(page);
    await page.locator('#runDstudyButton').click();
    await page.waitForFunction(() => $('#recommModelDStudyResult').text().includes('coefficient'));
    const result = await page.locator('#recommModelDStudyResult').textContent();
    const facets = await page.evaluate(() => $('#selectedMultipleFacets').val());
    // A label update must not submit new input values or discard fitted results.
    await page.evaluate(() => {
      window.translationChanges = [];
      $(document).on('shiny:inputchanged.regression', e => {
        if (['missingMethod', 'linkFunc', 'aiPromptTemplate'].includes(e.name)) {
          window.translationChanges.push(e.name);
        }
      });
    });
    for (const lang of ['en', 'zh', 'en', 'zh']) {
      await language(page, lang);
      assert.equal(await page.locator('#recommModelDStudyResult').textContent(), result);
      assert.deepEqual(await page.evaluate(() => $('#selectedMultipleFacets').val()), facets);
      assert.equal(await page.inputValue('#FacetValueSlider'), '12');
      assert.equal(await page.inputValue('#missingMethod'), 'mean');
      const option = await page.evaluate(() => $('#aiPromptTemplate')[0].selectize.options.explain.label);
      assert.equal(option, lang === 'zh' ? '用通俗语言解释 G 研究结果' : 'Explain my G-study results in plain language');
    }
    assert.deepEqual(await page.evaluate(() => window.translationChanges), []);
    // Closing and reopening the D-study controls must preserve unsaved edits too.
    await page.locator('#FacetValueSlider').fill('17');
    for (const checked of [false, true, false, true]) {
      await page.evaluate(checked => $('#runDstudyBox').prop('checked', checked).trigger('change'), checked);
      await settle(page);
    }
    assert.equal(await page.inputValue('#FacetValueSlider'), '17');
    await page.locator('#confirmFacetLevel').click();
    await settle(page);
    await page.locator('#runDstudyButton').click();
    await settle(page);
    assert.notEqual(await page.locator('#recommModelDStudyResult').textContent(), result);
    assert.deepEqual(await page.locator('.shiny-output-error:visible').allTextContents(), []);
    assert.deepEqual(errors, []);
    console.log(`PASS ${example}: Chinese G/D studies, repeated language changes, preserved values and D-study panel edits`);
  } finally {
    await page.close();
  }
}

async function uploads(browser) {
  const page = await browser.newPage();
  try {
    await page.goto(url);
    await settle(page);
    await language(page, 'zh');
    await page.locator('a[data-value="datainput"]').click();
    await page.evaluate(() => $('#fileUploadSwitch').bootstrapSwitch('state', true));
    const upload = async content => {
      await page.locator('#fileUpload-file').setInputFiles({
        name: 'wide.csv', mimeType: 'text/csv', buffer: Buffer.from(content)
      });
      await settle(page);
    };
    await upload('Person,I1,I2\n1,1,5\n2,2,6\n3,3,7\n4,4,8\n');
    await page.waitForFunction(() => $('#rawDataTable table').length &&
      $('#rawDataTable table tbody tr').length === 4);
    await page.evaluate(() => Shiny.setInputValue('isLongFormat', false, {priority: 'event'}));
    await page.locator('#TagPreFix').waitFor({ state: 'visible' });
    await settle(page);
    assert.equal(await page.inputValue('#TagPreFix'), '');
    assert.equal(await page.inputValue('#TagNames'), '');
    await page.locator('#transform').click();
    await page.waitForFunction(() => $('#transDataTable table tbody tr').length === 8);
    await language(page, 'en');
    await upload('Person,I1,I2\n1,11,14\n2,12,15\n3,13,16\n');
    await page.locator('#transform').click();
    await page.waitForFunction(() => $('#transDataTable table tbody tr').length === 6);
    assert.deepEqual(await page.locator('.shiny-output-error:visible').allTextContents(), []);
    console.log('PASS uploads: Chinese wide-data defaults, transformation, language switch and replacement upload');
  } finally {
    await page.close();
  }
}

(async () => {
  const browser = await chromium.launch({ channel: process.env.BROWSER_CHANNEL || 'msedge', headless: true });
  try {
    await study(browser, 'Rajaratnam.2');
    await study(browser, 'Brennan.3.2');
    await uploads(browser);
  } finally {
    await browser.close();
  }
})().catch(error => {
  console.error(error);
  process.exitCode = 1;
});
