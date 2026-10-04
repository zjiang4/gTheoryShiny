library(testthat)

app_env <- new.env(parent = globalenv())
withr::with_dir(test_path("..", ".."), {
  suppressPackageStartupMessages(suppressWarnings(sys.source("app.R", envir = app_env)))
})

test_that("language changes preserve fitted studies and D-study edits", {
  withr::local_dir(test_path("..", ".."))
  shiny::testServer(app_env$server, {
    session$setInputs(appLanguage = "en", fileUploadSwitch = FALSE,
                      selectedExpDat = "Brennan.3.2", isLongFormat = TRUE,
                      transform = 0, runGstudyButton = 0, runDstudyButton = 0,
                      runDstudyBox = FALSE, confirmFacetLevel = 0,
                      selectedID = "Person", selectedOutcome = "Score",
                      selectedMultipleFacets = c("Task", "Rater"),
                      missingMethod = "omit", mGtheory = FALSE,
                      linkFunc = "identity", selfFormular = "")
    session$setInputs(dataConfirm = 1, variableSettingConfirm = 1)
    session$setInputs(runGstudyButton = 1)
    expect_true(gstudyReady())
    model <- gstudyResult()$VarComp
    session$setInputs(runDstudyBox = TRUE, FacetDStudySelector = "Task",
                      FacetValueSlider = 12)
    session$setInputs(confirmFacetLevel = 1, runDstudyButton = 1)
    expect_true(dstudyReady())
    coefficient <- dstudyResult()$gcoef
    for (lang in c("zh", "en", "zh")) {
      session$setInputs(appLanguage = lang)
      expect_identical(gstudyResult()$VarComp, model)
      expect_identical(dstudyResult()$gcoef, coefficient)
      expect_equal(unname(updatedN()["Task"]), 12)
      expect_true(gstudyReady())
      expect_true(dstudyReady())
    }
    session$setInputs(runDstudyBox = FALSE)
    session$setInputs(runDstudyBox = TRUE)
    expect_equal(unname(updatedN()["Task"]), 12)
    session$setInputs(FacetValueSlider = -1, confirmFacetLevel = 2)
    expect_equal(unname(updatedN()["Task"]), 12)
    session$setInputs(FacetValueSlider = 8, confirmFacetLevel = 3)
    expect_equal(unname(updatedN()["Task"]), 8)
    expect_false(dstudyReady())
    session$setInputs(runDstudyButton = 2)
    expect_true(dstudyReady())
    expect_false(identical(dstudyResult()$gcoef, coefficient))
  })
})

test_that("replacing an upload and changing its header refresh analysis data", {
  withr::local_dir(test_path("..", ".."))
  first <- tempfile(fileext = ".csv")
  second <- tempfile(fileext = ".csv")
  write.csv(data.frame(Person = 1:4, Item = c(1, 2, 1, 2), Score = 1:4), first, row.names = FALSE)
  write.csv(data.frame(Person = 1:6, Item = rep(1:2, 3), Score = 11:16), second, row.names = FALSE)
  withr::defer(unlink(c(first, second)))
  upload <- function(path) data.frame(name = basename(path), size = file.info(path)$size,
                                     type = "text/csv", datapath = path)
  shiny::testServer(app_env$server, {
    session$setInputs(fileUploadSwitch = TRUE, isLongFormat = TRUE, transform = 0,
                      `fileUpload-isHeaderIncluded` = TRUE,
                      `fileUpload-file` = upload(first))
    expect_equal(nrow(dat()), 4)
    session$setInputs(`fileUpload-file` = upload(second))
    expect_equal(nrow(dat()), 6)
    expect_equal(dat()$Score, 11:16)
    session$setInputs(`fileUpload-isHeaderIncluded` = FALSE)
    expect_equal(nrow(dat()), 7)
    expect_equal(names(dat()), c("V1", "V2", "V3"))
  })
})

test_that("both languages have the same translation keys", {
  translations <- get("i18n_translations", envir = app_env)
  expect_setequal(names(translations$en), names(translations$zh))
})

test_that("wide data must be transformed again after replacing the source", {
  withr::local_dir(test_path("..", ".."))
  first <- tempfile(fileext = ".csv")
  second <- tempfile(fileext = ".csv")
  withr::defer(unlink(c(first, second)))
  write.csv(data.frame(Person = 1:4, I1 = 1:4, I2 = 5:8), first, row.names = FALSE)
  write.csv(data.frame(Person = 1:3, I1 = 11:13, I2 = 14:16), second, row.names = FALSE)
  upload <- function(path) data.frame(name = basename(path), size = file.info(path)$size,
                                     type = "text/csv", datapath = path)
  shiny::testServer(app_env$server, {
    session$setInputs(fileUploadSwitch = TRUE, isLongFormat = FALSE, transform = 0,
                      nRows = 0, TagPreFix = "", TagNames = "",
                      `fileUpload-isHeaderIncluded` = TRUE,
                      `fileUpload-file` = upload(first))
    session$setInputs(transform = 1)
    expect_equal(nrow(dat()), 8)
    expect_equal(names(dat()), c("Person", "Facet", "Score"))
    session$setInputs(appLanguage = "zh")
    expect_equal(nrow(dat()), 8)
    session$setInputs(`fileUpload-file` = upload(second))
    expect_error(dat(), "Transform the current dataset again")
    session$setInputs(transform = 2)
    expect_equal(nrow(dat()), 6)
    expect_equal(sort(dat()$Score), 11:16)
  })
})
