### Quick Start

gTheoryShiny divides a generalizability-theory analysis into three steps. New users can begin with the default example data.

1. **Data Input**: choose an example dataset or upload a CSV file. Long-format data should contain one rating per row; wide data can be transformed first.
2. **Data Structure**: select the person or object ID, numeric outcome, and facets such as items, raters, tasks, or occasions.
3. **Data Analysis**: run the G-study first, then use the D-study to compare reliability under alternative measurement designs.

Select **Confirm** after each setup step to move to the next page.

### Core Concepts

- **ID / measurement object**: the unit you ultimately want to distinguish or evaluate, such as a student, patient, or product.
- **Outcome**: the numeric score being analyzed.
- **Facet**: a measurement condition that may introduce error, such as an item, rater, task, or occasion.
- **G-study**: decomposes variation into the measurement object, facets, interactions, and residual error to identify important error sources.
- **D-study**: uses G-study variance components to estimate how reliability changes when the number of items, raters, or other conditions changes.

### Interpreting Coefficients

- The **generalizability coefficient (G coefficient)** supports relative decisions, such as ranking students.
- The **dependability coefficient (Phi)** supports absolute decisions, such as deciding whether a fixed cut score is met.
- Values closer to 1 indicate more stable measurement. Values such as 0.70, 0.80, and 0.90 are guidelines only; the required level depends on decision risk, purpose, and field standards.
- Investigate singular-fit, convergence, or non-estimable-term warnings before interpreting results.

### Data Checklist

- ID, outcome, and facet variables must be different.
- The outcome must be numeric or convertible to numeric.
- Every facet needs at least two levels.
- Random effects need replicated observations. The app omits non-estimable terms and reports them.
- Logit requires a 0/1 outcome; Poisson requires non-negative integers; inverse gamma requires strictly positive values.
- CSV uploads are limited to 50 MB. Column names are converted to unique, valid R names.

### Built-in Examples

1. **Rajaratnam.2**: `Person` is the ID, `Score` is the outcome, and the default facets are `Subtest` and `Item`.
2. **Brennan.3.2**: `Person` is the ID, `Score` is the outcome, and the default facets are `Task` and `Rater`.

### AI Assistant

The assistant can explain G-study and D-study results in plain language, identify major error sources, and suggest design changes. For privacy, only variable names, sample sizes, the model formula, and aggregate results are sent. **Raw response rows and person-level records are never sent.** AI output supports interpretation and planning; it does not replace expert review of the design, assumptions, and field standards.

### Advanced Features

- **Bootstrap confidence intervals** quantify uncertainty in variance components and D-study results.
- **Covariates** enter the model as fixed effects.
- **Multivariate G-theory** is experimental; review weights, covariance structure, and diagnostics carefully.
- **Downloads** include transformed data, person random-effect scores, G-study bootstrap results, and D-study variance tables.

### Updated October 3, 2026

This version includes validation, estimability checks, model diagnostics, beginner-friendly interpretation, session isolation, safe custom formulas, Windows parallel bootstrap support, a privacy-preserving NVIDIA AI assistant, and English/Chinese interface switching.
