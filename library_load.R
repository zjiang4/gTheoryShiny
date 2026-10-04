library_load <- function() {
  local_library <- file.path(getwd(), ".Rlib")
  if (dir.exists(local_library)) {
    .libPaths(c(local_library, .libPaths()))
  }

  required_packages <- c(
    "shiny", "shinyjs", "shinydashboard", "shinyWidgets",
    "markdown", "DT", "glmmTMB", "lme4", "dplyr",
    "tidyr", "stringr", "ggplot2", "tibble", "glue", "httr2"
  )
  namespace_packages <- "jsonlite"
  missing_packages <- required_packages[
    !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
  ]
  missing_packages <- c(
    missing_packages,
    namespace_packages[!vapply(namespace_packages, requireNamespace, logical(1), quietly = TRUE)]
  )

  if (length(missing_packages) > 0) {
    stop(
      paste0(
        "Missing required R packages: ",
        paste(missing_packages, collapse = ", "),
        ". Run `Rscript scripts/install_dependencies.R` from the project root."
      ),
      call. = FALSE
    )
  }

  invisible(lapply(required_packages, library, character.only = TRUE))
}

library_load()
