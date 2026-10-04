local_library <- file.path(getwd(), ".Rlib")
dir.create(local_library, recursive = TRUE, showWarnings = FALSE)
options(timeout = 300)

packages <- c(
  "shiny", "shinyjs", "shinydashboard", "shinyWidgets",
  "markdown", "DT", "glmmTMB", "lme4", "dplyr",
  "tidyr", "stringr", "ggplot2", "tibble", "glue", "httr2", "testthat"
)

install.packages(
  setdiff(packages, rownames(installed.packages(lib.loc = local_library))),
  repos = "https://cloud.r-project.org",
  lib = local_library,
  dependencies = c("Depends", "Imports", "LinkingTo")
)
