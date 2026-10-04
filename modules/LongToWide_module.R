# UI function for long to wide panel
pivotwiderUI <- function(id){
  ns <- NS(id)
  
  tagList(
    h4("Long to Wide Transformation:"),
    ## \u8bbe\u5b9atag/ID\u524d\u7f00\u548c\u6807\u7b7e
    checkboxInput(ns("isLongFormat"), "Long Format?", TRUE),
    conditionalPanel(
      condition = "input.isLongFormat == 0",
      ns = ns,
      uiOutput(ns("nRowsSelection")),
      uiOutput(ns("preFixText")),
      uiOutput(ns("TagNamesText")),
      ## \u8f6c\u6362
      actionButton(ns("transform"), "Transform")
    )
  )
}


pivotwiderServer <- function(id, data){
    moduleServer(
      id,
      function(input, output, session){
        
        # \u6309\u4e0b"transform"\u6309\u94ae\u540e\uff0c\u5c06\u539f\u59cb\u6570\u636e\u8f6c\u6362\u4e3a\u957f\u6570\u636e\u683c\u5f0f
        output$nRowsSelection <- renderUI({
          selectInput(
            session$ns("nRows"),
            "How many rows for TAG/ID",
            choices = 1:nrow(data),
            selected = 2
          )
        })
        
        output$preFixText <- renderUI({
          textInput(session$ns("preFix"), "Set TAG/ID Prefix\uff08for example, A;B;C\uff09", value = "T;R")
        })
        
        output$TagNamesText <- renderUI({
          textInput(session$ns("transform"),
                    "tag/ID\u7684column\u540d\u5b57(\u6bd4\u5982Class;Rater;Item)",
                    "Task;Rater")
        })
        
      }
    )
}