# Module UI function
csvFileUI <- function(id, label = "CSV file") {
  # `NS(id)` returns a namespace function, which was save as `ns` and will
  # invoke later.
  ns <- NS(id)
  
  tagList(
    fileInput(
      ns("file"),
      label = label,
      accept = ".csv",
      buttonLabel = "Upload..."
    ),
    prettySwitch(ns("isHeaderIncluded"), i18n_tag("heading"), value = TRUE, status = "info")
  )
}

# Module server function
csvFileServer <- function(id, stringsAsFactors) {
  moduleServer(
    id,
    ## Below is the module function
    function(input, output, session) {
      # The selected file, if any
      userFile <- reactive({
        # If no file is selected, don't do anything
        validate(need(input$file, message = FALSE))
        validate(need(input$file$size <= 50 * 1024^2, "CSV files must be 50 MB or smaller."))
        input$file
      })
      
      # The user's data, parsed into a data frame
      dataframe <- reactive({
        tryCatch({
          data <- read.csv(
            userFile()$datapath,
            header = input$isHeaderIncluded,
            stringsAsFactors = stringsAsFactors,
            check.names = FALSE,
            na.strings = c("", "NA", "N/A", ".")
          )
          normalize_column_names(data)
        },
          error = function(error) {
            validate(need(FALSE, paste("Could not read the CSV file:", conditionMessage(error))))
          }
        )
      })
      
      # We can run observers in here if we want to
      observe({
        msg <- sprintf("File %s was uploaded", userFile()$name)
        cat(msg, "\n")
      })
      
      # Return the reactive that yields the data frame
      return(dataframe)
    }
  )    
}
