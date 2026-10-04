library(testthat)

source(file.path(test_path("..", "..", "R", "app_helpers.R")))
source(file.path(test_path("..", "..", "advGtheoryFunctions.R")))

test_that("safe_numeric accepts numeric text and rejects invalid values", {
  expect_equal(safe_numeric(c("1", "2.5")), c(1, 2.5))
  expect_error(safe_numeric(c("1", "not-a-number")), "must be numeric")
})

test_that("family validation catches incompatible outcomes", {
  expect_silent(validate_family_outcome(c(0, 1, 1), "logit"))
  expect_error(validate_family_outcome(c(0, 2), "logit"), "0 and 1")
  expect_error(validate_family_outcome(c(1.5, 2), "poisson"), "non-negative integer")
  expect_error(validate_family_outcome(c(0, 2), "inverse gamma"), "strictly positive")
})

test_that("D-study handles one-facet relative error correctly", {
  gstudy_result <- list(
    gstudy.out = data.frame(
      Source = c("Person", "Item", "Person:Item", "Residual"),
      Est.Variance = c(1, 0.5, 0.3, 0.2)
    ),
    nobs = 100
  )
  class(gstudy_result) <- "gStudy"

  result <- dstudy(gstudy_result, n = c(Item = 2), unit = "Person")
  expect_equal(result$relvar, 0.25)
  expect_equal(result$absvar, 0.5)
  expect_equal(result$gcoef, 0.8)
  expect_equal(result$dcoef, 2 / 3)
  expect_equal(result$ds.df$n, c(1, 2, 2, 2))
})

test_that("D-study rejects invalid sample sizes", {
  x <- list(
    gstudy.out = data.frame(Source = c("Person", "Residual"), Est.Variance = c(1, 1)),
    nobs = 10
  )
  class(x) <- "gStudy"
  expect_error(dstudy(x, n = c(Item = 0), unit = "Person"), "at least 1")
  expect_error(dstudy(x, n = c(Item = 2), unit = "Unknown"), "No universe-score")
})

test_that("AI context excludes raw rows", {
  dat <- data.frame(Person = c("P1", "P2"), Item = c("I1", "I1"), Score = c(1, 2))
  context <- build_ai_context(dat, "Person", "Score", "Item", "Score ~ (1 | Person)")
  expect_match(context, "Privacy mode")
  expect_match(context, "Observations: 2")
  expect_false(grepl("P1", context, fixed = TRUE))
  expect_false(grepl("Score = c", context, fixed = TRUE))
})

test_that("D-study range parser validates input", {
  expect_equal(parse_level_range("2:6:2"), c(2, 4, 6))
  expect_error(parse_level_range("2:6"), "start:end:step")
  expect_error(parse_level_range("0:6:2"), "start >= 1")
})

test_that("coefficient guidance is explicit and bounded", {
  expect_match(coefficient_guidance(0.92), "very strong")
  expect_match(coefficient_guidance(0.65, "dependability"), "measurement design")
  expect_match(coefficient_guidance(NA_real_), "could not be estimated")
})

test_that("non-replicated random effects are identified", {
  data <- data.frame(
    Person = rep(rep(1:3, each = 2), each = 2),
    Item = rep(rep(1:2, times = 3), each = 2),
    Unique = 1:12
  )
  expect_true(grouping_term_estimable(data, "Person"))
  expect_true(grouping_term_estimable(data, "Person:Item"))
  expect_false(grouping_term_estimable(data, "Person:Unique"))
  expect_false(grouping_term_estimable(data, "Missing"))
})

test_that("AI response extraction validates service output", {
  body <- list(choices = list(list(message = list(content = "A clear answer"))))
  expect_equal(extract_chat_content(body), "A clear answer")
  expect_error(extract_chat_content(list(choices = list())), "no answer")
  expect_error(
    extract_chat_content(list(choices = list(list(message = list(content = ""))))),
    "empty answer"
  )
})

test_that("column names are normalized and custom formulas cannot execute code", {
  data <- data.frame(
    "Person ID" = rep(1:3, each = 4),
    "Item ID" = rep(rep(1:2, each = 2), times = 3),
    Score = 1:12,
    check.names = FALSE
  ) |>
    normalize_column_names()
  expect_equal(names(data), c("Person.ID", "Item.ID", "Score"))
  formula <- build_safe_random_formula("Score = Person.ID + Person.ID:Item.ID", data)
  expect_equal(deparse(formula), "Score ~ (1 | Person.ID) + (1 | Person.ID:Item.ID)")
  expect_error(build_safe_random_formula("Score = system('whoami')", data), "code are not allowed")
  expect_error(build_safe_random_formula("Score = Missing", data), "Unknown formula")
})

test_that("multivariate coefficient validates weights and matrices", {
  person <- diag(c(1, 2))
  residual <- diag(c(0.5, 1))
  expect_equal(
    as.numeric(gCoef_mGTheory(person_cov = person, residual_cov = residual, weights = "1;1")),
    2 / 3
  )
  expect_error(
    gCoef_mGTheory(person_cov = person, residual_cov = residual, weights = "1"),
    "Enter 2"
  )
  expect_error(
    gCoef_mGTheory(person_cov = person, residual_cov = diag(3), weights = "1;1"),
    "matching dimensions"
  )
})
