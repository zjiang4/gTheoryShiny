# gTheoryShiny

A Shiny app for generalizability-theory (G-theory) analysis.

## Run locally

1. Install R 4.5 or newer.
2. From this directory, run `Rscript scripts/install_dependencies.R` once.
3. Start the app with `Rscript shiny-run.R` or open `app.R` in RStudio.

The application starts with an example dataset so that the workflow can be explored before uploading data.

## AI assistant (optional)

The AI assistant is disabled unless the server has an `NVIDIA_API_KEY` environment variable. Configure it outside the repository, for example with a local `.Renviron` based on `.Renviron.example`:

```text
NVIDIA_API_KEY=your-key-here
NVIDIA_MODEL=z-ai/glm-5.3-flash
NVIDIA_API_URL=https://integrate.api.nvidia.com/v1/chat/completions
```

Raw response rows are not sent to the model. Only aggregate metadata, the selected formula, and displayed G-/D-study summaries are included in an AI request. Never commit an API key or paste it into the UI.

## Tests

Run the R tests with `Rscript tests/run_tests.R`. They cover input validation, family constraints, D-study coefficients, privacy filtering, range parsing, and Shiny session regressions for language switching, uploaded data replacement, wide-data transformation, and D-study controls.

For the browser regression test, start the app, install the optional Node.js package `playwright`, and run `node tests/browser_smoke.cjs http://127.0.0.1:3838`. It uses installed Microsoft Edge by default (`BROWSER_CHANNEL=chrome` selects Chrome). Both example datasets are tested through G-study and D-study in Chinese, with repeated English/Chinese switches and checks that input values, results, and panel edits are preserved. `PLAYWRIGHT_MODULE` can point to a Playwright installation outside the project. The old `shinytest` recording is retained for reference.

On Windows, use R packages built for the same R major/minor version as your runtime. If an R upgrade causes a package DLL to fail loading, rebuild or reinstall the project-local `.Rlib` dependencies for that runtime.
