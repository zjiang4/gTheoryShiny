options(shiny.autoreload = TRUE)
options(encoding = "UTF-8")

local_library <- file.path(getwd(), ".Rlib")
if (dir.exists(local_library)) {
  .libPaths(c(local_library, .libPaths()))
}

args <- commandArgs(trailingOnly = TRUE)
port <- if (length(args) > 0) suppressWarnings(as.integer(args[[1]])) else 3838L
if (!is.finite(port) || port < 1L || port > 65535L) {
  stop("Port must be an integer between 1 and 65535.", call. = FALSE)
}

shiny::runApp(host = "127.0.0.1", port = port)
