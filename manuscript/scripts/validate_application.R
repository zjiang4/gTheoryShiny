# Run from the repository root: Rscript manuscript/scripts/validate_application.R
# All datasets in this study are newly generated synthetic data.
.libPaths(c(file.path(getwd(), ".Rlib"), .libPaths()))
suppressPackageStartupMessages(library(lme4))
source("advGtheoryFunctions.R")
source("R/app_helpers.R")
dir.create("manuscript/results", recursive = TRUE, showWarnings = FALSE)
out <- "manuscript/results"
set.seed(20261004)

generate_data <- function(P, I, R = 1L) {
  d <- expand.grid(Person = seq_len(P), Item = seq_len(I), Rater = seq_len(R))
  if (R == 1L) {
    d$Score <- 50 + rnorm(P, sd = sqrt(1))[d$Person] +
      rnorm(I, sd = sqrt(.30))[d$Item] + rnorm(nrow(d), sd = sqrt(.70))
    d$Rater <- NULL
  } else {
    d$Score <- 50 + rnorm(P, sd = 1)[d$Person] +
      rnorm(I, sd = sqrt(.30))[d$Item] + rnorm(R, sd = sqrt(.15))[d$Rater] +
      rnorm(P * I, sd = sqrt(.25))[d$Person + P * (d$Item - 1)] +
      rnorm(P * R, sd = sqrt(.10))[d$Person + P * (d$Rater - 1)] +
      rnorm(I * R, sd = sqrt(.05))[d$Item + I * (d$Rater - 1)] +
      rnorm(nrow(d), sd = sqrt(.50))
  }
  d
}
fit_data <- function(d) {
  d$Person <- factor(d$Person); d$Item <- factor(d$Item)
  if ("Rater" %in% names(d)) {
    d$Rater <- factor(d$Rater)
    lmer(Score ~ (1 | Person) + (1 | Item) + (1 | Rater) +
           (1 | Person:Item) + (1 | Person:Rater) + (1 | Item:Rater), d, REML = TRUE)
  } else lmer(Score ~ (1 | Person) + (1 | Item), d, REML = TRUE)
}
one <- generate_data(80L, 12L)
two <- generate_data(80L, 8L, 4L)
write.csv(one, file.path(out, "example_one_facet.csv"), row.names = FALSE)
write.csv(two, file.path(out, "example_two_facet.csv"), row.names = FALSE)
one_fit <- fit_data(one); two_fit <- fit_data(two)
saveRDS(list(one = one_fit, two = two_fit), file.path(out, "example_models.rds"))
write.csv(gstudy(one_fit)$gstudy.out, file.path(out, "one_facet_components.csv"), row.names = FALSE)
write.csv(gstudy(two_fit)$gstudy.out, file.path(out, "two_facet_components.csv"), row.names = FALSE)

# Independent expected-mean-square benchmark for the balanced one-facet design.
P <- length(unique(one$Person)); I <- length(unique(one$Item))
grand <- mean(one$Score)
pm <- tapply(one$Score, one$Person, mean)
im <- tapply(one$Score, one$Item, mean)
resid <- one$Score - pm[one$Person] - im[one$Item] + grand
ms_p <- I * sum((pm - grand)^2) / (P - 1)
ms_i <- P * sum((im - grand)^2) / (I - 1)
ms_e <- sum(resid^2) / ((P - 1) * (I - 1))
anova_v <- c(Person = (ms_p - ms_e) / I, Item = (ms_i - ms_e) / P, Residual = ms_e)
v <- gstudy(one_fit)$gstudy.out
comparison <- data.frame(Source = names(anova_v), ANOVA = anova_v,
                        REML = v$Est.Variance[match(names(anova_v), v$Source)])
comparison$absolute_difference <- abs(comparison$ANOVA - comparison$REML)
write.csv(comparison, file.path(out, "anova_benchmark.csv"), row.names = FALSE)
stopifnot(max(comparison$absolute_difference) < 1e-3)

# Coefficient checks are independent formulas, not another call to dstudy().
coefficient_check <- function(fit, n) {
  v <- setNames(gstudy(fit)$gstudy.out$Est.Variance, gstudy(fit)$gstudy.out$Source)
  component <- function(terms) {
    index <- vapply(strsplit(names(v), ":", fixed = TRUE),
                    function(x) setequal(x, terms), logical(1))
    stopifnot(sum(index) == 1L)
    unname(v[index])
  }
  if (length(n) == 1L) {
    relative <- component("Residual") / n[[1]]
    absolute <- relative + component("Item") / n[[1]]
  } else {
    relative <- component(c("Person", "Item")) / n[["Item"]] +
      component(c("Person", "Rater")) / n[["Rater"]] + component("Residual") / prod(n)
    absolute <- relative + component("Item") / n[["Item"]] +
      component("Rater") / n[["Rater"]] + component(c("Item", "Rater")) / prod(n)
  }
  expected <- c(gcoef = component("Person") / (component("Person") + relative),
                dcoef = component("Person") / (component("Person") + absolute))
  actual <- unlist(dstudy(gstudy(fit), n, "Person")[c("gcoef", "dcoef")])
  max(abs(expected - actual))
}
plans <- expand.grid(Item = c(4, 8, 12, 16), Rater = c(2, 4, 6))
plan_results <- do.call(rbind, lapply(seq_len(nrow(plans)), function(j) {
  n <- c(Item = plans$Item[j], Rater = plans$Rater[j])
  x <- dstudy(gstudy(two_fit), n, "Person")
  data.frame(Item = n[[1]], Rater = n[[2]], ratings_per_person = prod(n),
             gcoef = x$gcoef, dcoef = x$dcoef, relative_error = x$relvar,
             absolute_error = x$absvar, formula_difference = coefficient_check(two_fit, n))
}))
write.csv(plan_results, file.path(out, "dstudy_plans.csv"), row.names = FALSE)
stopifnot(max(plan_results$formula_difference) < 1e-12,
          coefficient_check(one_fit, c(Item = 12)) < 1e-12)

# Parametric percentile bootstrap for the one-facet worked example.
set.seed(20261005)
boot_fun <- function(fit) {
  g <- gstudy(fit)
  v <- setNames(g$gstudy.out$Est.Variance, g$gstudy.out$Source)
  d <- dstudy(g, c(Item = 12), "Person")
  c(v[c("Person", "Item", "Residual")], gcoef = d$gcoef, dcoef = d$dcoef)
}
boot_time <- system.time(boot <- bootMer(one_fit, boot_fun, nsim = 1000,
                                       use.u = FALSE, type = "parametric"))
complete <- complete.cases(boot$t)
ci <- t(apply(boot$t[complete, , drop = FALSE], 2, quantile, c(.025, .975)))
write.csv(data.frame(quantity = names(boot$t0), estimate = unname(boot$t0),
                     lower = ci[, 1], upper = ci[, 2]), file.path(out, "bootstrap_intervals.csv"), row.names = FALSE)
write.csv(boot$t, file.path(out, "bootstrap_draws.csv"), row.names = FALSE)
cat("Bootstrap complete:", sum(complete), "/1000; seconds:", boot_time[["elapsed"]], "\n")

# A scoped Monte Carlo implementation check. No interval-coverage study is claimed.
conditions <- data.frame(condition = c("one_small", "one_large", "two_small", "two_large"),
                         P = c(30L, 80L, 30L, 80L), I = c(6L, 12L, 6L, 8L),
                         R = c(1L, 1L, 3L, 4L))
replications <- 100L
records <- list()
set.seed(20261006)
start <- proc.time()[["elapsed"]]
for (j in seq_len(nrow(conditions))) {
  co <- conditions[j, ]
  if (co$R == 1L) {
    tr <- .70 / co$I; ta <- tr + .30 / co$I
  } else {
    tr <- .25 / co$I + .10 / co$R + .50 / (co$I * co$R)
    ta <- tr + .30 / co$I + .15 / co$R + .05 / (co$I * co$R)
  }
  for (r in seq_len(replications)) {
    warnings <- character()
    fit <- tryCatch(withCallingHandlers(suppressMessages(fit_data(generate_data(co$P, co$I, co$R))),
      warning = function(w) { warnings <<- c(warnings, conditionMessage(w)); invokeRestart("muffleWarning") }),
      error = function(e) e)
    if (inherits(fit, "error")) {
      record <- data.frame(condition = co$condition, replication = r, failed = TRUE,
        singular = NA, warning = conditionMessage(fit), gcoef = NA, dcoef = NA,
        true_g = 1/(1+tr), true_d = 1/(1+ta), formula_difference = NA)
    } else {
      n <- if (co$R == 1L) c(Item = co$I) else c(Item = co$I, Rater = co$R)
      ds <- dstudy(gstudy(fit), n, "Person")
      record <- data.frame(condition = co$condition, replication = r, failed = FALSE,
        singular = isSingular(fit), warning = paste(warnings, collapse = " | "),
        gcoef = ds$gcoef, dcoef = ds$dcoef, true_g = 1/(1+tr), true_d = 1/(1+ta),
        formula_difference = coefficient_check(fit, n))
    }
    records[[length(records) + 1L]] <- record
  }
  cat("Finished", co$condition, "with", replications, "replications\n")
}
raw <- do.call(rbind, records)
write.csv(raw, file.path(out, "simulation_replications.csv"), row.names = FALSE)
summary <- do.call(rbind, lapply(split(raw, raw$condition), function(z) {
  do.call(rbind, lapply(c("g", "d"), function(type) {
    error <- z[[paste0(type, "coef")]] - z[[paste0("true_", type)]]
    data.frame(condition = z$condition[[1]], coefficient = type,
      attempted = nrow(z), successful = sum(!z$failed), truth = z[[paste0("true_",type)]][[1]],
      mean_estimate = mean(z[[paste0(type,"coef")]], na.rm = TRUE),
      bias = mean(error, na.rm = TRUE), rmse = sqrt(mean(error^2, na.rm = TRUE)),
      mcse_bias = sd(error, na.rm = TRUE)/sqrt(sum(is.finite(error))),
      singular_count = sum(z$singular, na.rm = TRUE), warning_count = sum(nzchar(z$warning)),
      max_formula_difference = max(z$formula_difference, na.rm = TRUE))
  }))
}))
write.csv(summary, file.path(out, "simulation_summary.csv"), row.names = FALSE)
jsonlite::write_json(list(seeds = c(examples = 20261004, bootstrap = 20261005, simulation = 20261006),
  bootstrap_attempted = 1000, bootstrap_complete = sum(complete),
  bootstrap_seconds = unname(boot_time[["elapsed"]]),
  simulation_seconds = proc.time()[["elapsed"]] - start,
  one_singular = isSingular(one_fit), two_singular = isSingular(two_fit),
  one_formula = deparse(formula(one_fit)), two_formula = deparse(formula(two_fit)),
  conditions = conditions, replications_per_condition = replications),
  file.path(out, "validation_metadata.json"), auto_unbox = TRUE, pretty = TRUE)
writeLines(capture.output(sessionInfo()), file.path(out, "sessionInfo.txt"))
print(summary)
