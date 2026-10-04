# This is a Shiny web application for g theory visualization. 
#
# Data:
#     1. SyntheticDataSetNo.1.csv: Single facet design (p X i)
#     2. SyntheticDataSetNo.4.csv: two facet design (p X t X r)
# Tutorial: (Mastering Shiny) https://mastering-shiny.org/
# 【X】 1) 在dstudy界面可以選擇多個N，以便畫出曲線

missingMethods = c(
  "na.omit (default)",
  "Zero Imputation",
  "Mean Imputation",
  "Median Imputation"
)
source("library_load.R")
source("advGtheoryFunctions.R")
source("R/app_helpers.R")
source("R/i18n.R", encoding = "UTF-8")

## Include elements of html

## Source all modules
source("modules/inputFile_module.R") # Input CSV file
source("modules/LongToWide_module.R") # Long format to Wide format

## Load example data sets
Rajaratnam.2 <- read.csv("data/Rajaratnam.2.new.csv", check.names = FALSE)
Brennan.3.2 <- read.csv("data/Brennan.3.2Long.csv", check.names = FALSE)
Brennan.9.3 <- read.csv("data/Brennan.9.3.csv")
exampleData <- list(
  "Rajaratnam.2" = Rajaratnam.2,
  "Brennan.3.2" = Brennan.3.2
)

# UI ----------------------------------------------------------------------
ui <- dashboardPage(
  skin = "purple",
  
  ## title
  dashboardHeader(title = "gTheoryShiny App"),
  
  ## Sidebar content -----
  dashboardSidebar(
    div(
      class = "sidebar-language",
      selectInput("appLanguage", label = i18n_tag("language"),
                  choices = setNames(c("en", "zh"), c("English", "\u4e2d\u6587")), selected = "en",
                  width = "100%")
    ),
    sidebarMenu(
      id = "sidebar", 
      menuItem(
        i18n_tag("tutorial"), tabName = "tutorial", icon = icon("dashboard"),
        badgeLabel = "Ver.0.2.Beta", badgeColor = "purple"
      ),
      menuItem(i18n_tag("data_input"), tabName = "datainput", icon = icon("th")),
      menuItem(i18n_tag("data_structure"), tabName = "datastructure", icon = icon("table")),
      menuItem(i18n_tag("data_analysis"), tabName = "dataanalysis", icon = icon("list-alt")),
      menuItem(i18n_tag("ai_assistant"), tabName = "aiassistant", icon = icon("comments"))
    )
  ),
  
  ## Body content -----
  dashboardBody(
    shinyjs::useShinyjs(),
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "default_mode.css"),
      i18n_head()
    ),
    tabItems(
      ### Tab Page 0: Tutorial ----
      tabItem(tabName = "tutorial", 
              fluidPage(
                # title
                titlePanel(""),
                box(width = 12, title = i18n_tag("tutorial_title"),
                    uiOutput("tutorialContent"),
                )
              )
      ),
      
      ### Tag Page 1: Transform data  ----
      tabItem(tabName = "datainput",
        fluidPage(
          box(title = i18n_tag("input_data_file"), 
              status = "info", solidHeader = TRUE, width = 4, 
              switchInput(
                inputId = "fileUploadSwitch",
                value = FALSE,
                onLabel = "Uploaded data",
                offLabel = "Example data",
                onStatus = "success",
                offStatus = "danger",
                width = "80%", 
                size = 'normal'
              ),
              helpText(i18n_tag("data_source_help")),
              conditionalPanel( # if uncheck the switch, let client select the example data
                condition = "input.fileUploadSwitch == 0", 
                radioGroupButtons(
                  inputId = "selectedExpDat",
                  label = i18n_tag("example_data_label"),
                  choices = c("Rajaratnam.2", "Brennan.3.2"),
                  direction = "vertical"
                )
              ),
              conditionalPanel( # if check the switch, let client select self data
                condition = "input.fileUploadSwitch == 1", 
                csvFileUI("fileUpload", ""),
              ),
              prettySwitch("isLongFormat", i18n_tag("long_format"), value = TRUE, status = "info"),
              conditionalPanel(
                condition = "input.isLongFormat == 0",
                hr(),
                h4(i18n_tag("pivot_heading")),
                uiOutput("nRowsSelection"),
                uiOutput("preFixText"),
                uiOutput("TagNamesText"),
                ## 转换
                actionBttn("transform", tagList(icon("rotate"), i18n_tag("transform")), 
                           style = "jelly", color = "primary", size = "sm"),
              ),
              ## 确定
              br(),
              hr(),
              actionBttn("dataConfirm", label = i18n_tag("confirm"), icon = icon("circle"), 
                         style = "jelly", color = "primary", size = "sm")
          ),
          column(width = 8, 
          tabBox(title = tagList(shiny::icon("th"), i18n_tag("data")), width = 12,
            id = "tabsetData", 
            tabPanel(title = i18n_tag("raw"), value = "raw", DTOutput("rawDataTable")),
            tabPanel(title = i18n_tag("transformed"), value = "transformed",
                     DTOutput("transDataTable"),
                     ## 下載轉化過的數據
                     conditionalPanel(
                       condition = "input.transform >= 1",
                       br(),
                       downloadBttn("downloadTransData", 
                                    i18n_tag("download"), 
                                    style = "jelly",
                                    color = "success", size = "sm"),
                     )
            )
          ),
          box(title = i18n_tag("facet_levels"), width = 12, DTOutput("FacetLevelTable")),
            
          ),
        )
      ),
      
      ### Tab Page 2: Data Structure  ----
      tabItem(tabName = "datastructure",
        fluidRow(
          column(width = 4, 
                 box(title = i18n_tag("data_structure"), width = 12,
                     status = "primary", solidHeader = TRUE,
                     # show selection area for ID
                     uiOutput("selectedIDUI"),
                     # show selection area for outcome
                     uiOutput("selectedOutcomeUI"),
                     # show selection area for facets
                     uiOutput("selectedMultipleFacetsUI"),
                     # Missing data
                     pickerInput(
                       "missingMethod",
                       label = i18n_tag("missing_method"),
                       choices = c(
                         "Remove rows with missing values (default)" = "omit",
                         "Replace missing values with zero" = "zero",
                         "Replace missing values with the mean" = "mean",
                         "Replace missing values with the median" = "median"
                       ),
                       selected = "omit"
                     ),
                     # show selection area for covariates
                     hr(),
                     uiOutput("selectedCovariatesUI"),
                     hr(),
                     uiOutput("mGtheoryUI"),
                     conditionalPanel(
                       condition = "input.mGtheory == 1",
                       uiOutput("selectedFixedFacetUI"),
                       uiOutput("selectedFixedFacetWeightsUI"),
                       uiOutput("selectedFacetWithUSComponentUI"), # facet with unstructured components
                       verbatimTextOutput("reportFacets"),
                     ),
                     actionBttn("variableSettingConfirm", i18n_tag("confirm"), 
                                icon = icon("circle"), style = "jelly", color = "primary", size = "sm")
                 )
          ),
          column(width = 8, 
                 box(title = i18n_tag("formula"), width = 12,
                     textOutput("recommFormular"), 
                     tags$head(tags$style("#recommFormular{color:red; font-size:14px; font-style:bold;
          overflow-y:scroll; max-height: 50px; background: ghostwhite;}"))
                 ),
                 box(title = i18n_tag("structure_table"), width = 12, 
                     DTOutput("nestedStrucTable")
                 ),
                 box(title = i18n_tag("summary_table"), width = 12, 
                     DTOutput("factorNestTable"),
                      footer = p(i18n_tag("structure_footer"))
                 )
          )
        )
      ),
      ### Tab Page 3: Data Analysis  ----
      tabItem(tabName = "dataanalysis",
        fluidRow(
          column(width = 4,
            box(title = i18n_tag("control_panel"), status = "danger", 
                solidHeader = TRUE, width = NULL, 
                textInput("selfFormular", i18n_tag("custom_formula"),
                          placeholder = "Default: recommended formula"),
                pickerInput(
                  "linkFunc",
                  label = i18n_tag("link_function"),
                  choices = c("identity", "logit", "poisson", "inverse gamma"),
                  selected = "identity"
                ),
                sliderInput(
                  inputId = "nboot",
                  label = i18n_tag("bootstrap_number"),
                  min = 100,
                  max = 1000,
                  value = 500
                ),
                uiOutput("nCoresUI")
            ),
            ### Input UI for gstudy -----
            box(title = i18n_tag("gstudy_estimation"), status = "info", 
                solidHeader = TRUE, width = NULL,
                actionBttn("runGstudyButton", i18n_tag("run_gstudy"), style = "material-flat",
                           color = "primary", size = "sm", icon = icon('circle-play')),
                actionBttn("runGstudyBootButton", i18n_tag("run_bootstrap"), style = "material-flat", 
                           color = "primary", size = "sm", icon = icon("bootstrap")),
                progressBar(
                  id = "gstudybar",
                  value = 0,
                  total = 100,
                  title = i18n_tag("bootstrap_gstudy"),
                  striped = TRUE,
                  display_pct = TRUE
                ),
            ),
            ### Input UI for dstudy -----
            box(title = i18n_tag("dstudy_estimation"), status = "warning", 
                solidHeader = TRUE, width = NULL,
                prettySwitch("runDstudyBox", label = i18n_tag("run_dstudy"), 
                             value = FALSE,
                             bigger = TRUE),
                conditionalPanel(condition = "input.runDstudyBox == 1",
                  h4(i18n_tag("dstudy_estimation")),
                  
                  ### 选择要修改的facet和number of conditions
                  uiOutput("selectedFacetMenu"),
                  uiOutput("selectedFacetLevels"),
                  uiOutput("selectedMultipleFacetLevels"),
                  
                  #选择factor levels
                  actionBttn(inputId = "confirmFacetLevel",
                             label = i18n_tag("add_facet_levels"), icon = icon("check"),
                             style = "material-flat", color = "primary", size = "sm"),
                  actionBttn("runDstudyButton", i18n_tag("run"), icon = icon('circle-play'),
                             style = "material-flat", color = "primary", size = "sm"),
                  conditionalPanel(condition = "input.mGtheory == 0", 
                    actionBttn("runDstudyBootButton", i18n_tag("run_bootstrap"), icon = icon("bootstrap"),
                               style = "material-flat", color = "primary", size = "sm"),
                    actionBttn("plotDstudyCoef", i18n_tag("visualize"), icon = icon('image'),
                               style = "material-flat", color = "primary", size = "sm"),
                    progressBar(id = "dstudybar", 
                                value = 0,
                                total = 100,
                                title = NULL,
                                striped = TRUE,
                                display_pct = TRUE),
                  ),
                )
            )
          ),
          
          column(width = 8,
            #### Output UI for gstudy  ----
            box(title = i18n_tag("gstudy_result"), width = NULL, 
                collapsible = TRUE, collapsed = FALSE,
                solidHeader = TRUE, status = 'info', 
                conditionalPanel(
                  condition = "output.gstudyReady === true",
                  h4(i18n_tag("fixed_effects_output")),
                  DTOutput("recommModelFixedEffectResult"),
                  h4(i18n_tag("random_effects_output")),
                  DTOutput("GstudyResultPrint"),
                  h4(i18n_tag("other_output")),
                  verbatimTextOutput("GstudyResultExtraPrint"),
                  h4(i18n_tag("what_this_means")),
                  uiOutput("gstudyInterpretation"),
                  downloadBttn("downloadGstudyTheta", i18n_tag("factor_score_table"),
                               style = "jelly", color = "success", size = 'sm')
                ),
                # gstudy with bootstrapping SD
                conditionalPanel(
                  condition = "input.runGstudyBootButton >= 1",
                  h4(i18n_tag("gstudy_bootstrap_result")),
                  DTOutput("recommModelGStudyBootResult"),
                  downloadBttn("downloadGstudyBootResult", 
                               i18n_tag("bootstrap_result"),
                               style = "jelly", color = "success", size = 'sm')
                ),
            ),
            
            #### Output UI for dstudy  ----
            box(title = i18n_tag("dstudy_result"), width = NULL, collapsible = TRUE, collapsed = FALSE,
                solidHeader = TRUE, status = 'info', 
                conditionalPanel(condition = "input.confirmFacetLevel >= 1",
                                 h4(i18n_tag("dstudy_sample_size")),
                                 DTOutput("updatedNDT")),
                
                conditionalPanel(
                  condition = "output.dstudyReady === true",
                  verbatimTextOutput("recommModelDStudyResult"),
                  uiOutput("dstudyInterpretation"),
                  downloadBttn("downloadDstudyResult", 
                                i18n_tag("download_dstudy"),
                               color = "success", style = "jelly", size = 'sm'
                  )
                ),
                # dstudy with bootstrapping SD
                conditionalPanel(
                  condition = "input.runDstudyBootButton >= 1",
                  h4(i18n_tag("dstudy_bootstrap_result")),
                  verbatimTextOutput("recommModelDStudyBootResult"),
                  downloadBttn("downloadDstudyBootResult", 
                                i18n_tag("download_bootstrap"),
                               color = "success", style = "jelly", size = 'sm')
                ),
                # plot dstudy coefficient path plot
                conditionalPanel(
                  condition = "input.plotDstudyCoef >= 1",
                  h4(i18n_tag("coefficient_plot")),
                  plotOutput("DstudyCoefPlot")
                )            
            )
            
          )
          
        )
      ),

      tabItem(
        tabName = "aiassistant",
        fluidRow(
          box(
            title = i18n_tag("ask_about_analysis"),
            status = "primary",
            solidHeader = TRUE,
            width = 5,
            selectInput(
              "aiPromptTemplate",
              i18n_tag("suggested_question"),
              choices = c(
                "Choose a starting point" = "",
                "Explain my G-study results in plain language" = "explain",
                "Help me improve reliability" = "improve",
                "Check the analysis setup" = "check"
              )
            ),
            textAreaInput(
              "aiQuestion",
              i18n_tag("your_question"),
              rows = 7,
              placeholder = "For example: What does a dependability coefficient of 0.72 mean?"
            ),
            actionButton("askAI", i18n_tag("ask_ai"), icon = icon("paper-plane"), class = "btn-primary"),
            hr(),
            helpText(
              i18n_tag("privacy_notice")
            ),
            textOutput("aiStatus")
          ),
          box(
            title = i18n_tag("assistant_response"),
            width = 7,
            solidHeader = TRUE,
            status = "info",
            uiOutput("aiAnswer")
          )
        )
      )
    )
  ), # End of dashboardBody
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "default_mode.css")
  )
) # End of dashboardPage




# Server -----------------------------------------------------------------
server <- function(input, output, session) {
  language <- reactive(if (identical(input$appLanguage, "zh")) "zh" else "en")
  translate <- function(key, ...) tr_text(language(), key, ...)
  updatedN <- reactiveVal(setNames(numeric(), character()))
  allRandomFacets <- reactiveVal(setNames(numeric(), character()))
  omittedGroupingTerms <- reactiveVal(character())
  gstudyReady <- reactiveVal(FALSE)
  dstudyReady <- reactiveVal(FALSE)
  aiAnswer <- reactiveVal("ai_answer_initial")
  lastAIRequest <- reactiveVal(as.POSIXct(NA))
  aiStatus <- reactiveVal(if (nzchar(Sys.getenv("NVIDIA_API_KEY"))) "ai_status_configured" else "ai_status_unconfigured")

  output$tutorialContent <- renderUI({
    includeMarkdown(if (identical(language(), "zh")) "tutorial_content_zh.md" else "tutorial_content_en.md")
  })

  ## Server for Page 1: Data read and transformation  ----------------------------------------
  ### Read in original data ----------------------------------------
  datRaw <- csvFileServer("fileUpload", stringsAsFactors = FALSE)
  
  ### Reactive data: for further analysis -----
  # input$fileUploadSwitch | input$isLongFormat
  sourceData <- reactive({
    req(!is.null(input$fileUploadSwitch))
    if (isTRUE(input$fileUploadSwitch)) {
      datRaw()
    } else {
      validate(need(input$selectedExpDat %in% names(exampleData), "Select a valid example dataset."))
      exampleData[[input$selectedExpDat]]
    }
  })
  transformedSource <- reactiveVal(NULL)
  dat <- reactive({
    if (!isTRUE(input$isLongFormat) && isTRUE(input$transform >= 1)) { # transformed data
      result <- datTrans()
      validate(need(identical(sourceData(), transformedSource()),
                    "The source data changed. Transform the current dataset again."))
      result
    }else{
      sourceData()
    }
  })
  
  ### Output raw data table-----
  output$rawDataTable <- renderDT({
    if (input$fileUploadSwitch == 0) {
      validate(need(input$selectedExpDat %in% names(exampleData), "Select a valid example dataset."))
      exampleData[[input$selectedExpDat]]
    }else{
      datatable(datRaw()) |> 
        formatRound(colnames(datRaw())[sapply(datRaw(), is.numeric)], digits = 3)
    }
  })
  
  ### UI selectors for facets specifications  ----------------------------------------
  #------------#
  # A bunch of reactive values:
  ## NText: 有多少行是tag/ID
  ## preFixText: tag的前綴是什麼比如第四個item—I4，為I
  ## TagNamesText: facet的name比如：Class;Rater;Item
  #------------#
  
  
  ### Reactive facets and prefix -----
  NText = reactive({input$nRows}) # 有多少行是tag/ID
  preFixText = reactive({input$TagPreFix}) # 前缀，比如A;B;C
  TagNamesText = reactive({input$TagNames}) # facet的name比如：Class;Rater;Item

  ### Selected rows for facets
  output$nRowsSelection <- renderUI({ # 选择多少行代表Facet Tags，每一行代表一个facet
    dat <- sourceData()
      pickerInput(
        "nRows",
      i18n_tag("facet_rows"),
      choices = seq.int(0L, max(0L, nrow(dat) - 1L)),
      selected = 0
    )
  })
  
  ### React to update prefix and N
  observeEvent(list(input$nRows, sourceData()), {
    dat <- sourceData()
    req(length(NText()) == 1, is.finite(as.numeric(NText())),
        as.numeric(NText()) >= 0, as.numeric(NText()) < nrow(dat))
    # extract prefix from heading rows
    prefix = if (NText() == 0) character() else apply(dat[seq_len(NText()), -1, drop = FALSE], 1, \(x) str_remove(x, "[0-9]+")[1])
    
    output$preFixText <- renderUI({ # 为facets选择prefix
      textInput("TagPreFix", 
                label = i18n_tag("facet_prefix"),
                value = paste0(prefix, collapse = ","))
    })
    
    output$TagNamesText <- renderUI({
      textInput("TagNames",
                label = i18n_tag("facet_names"),
                value = paste0(paste0(str_to_upper(prefix), head(letters, length(prefix))), collapse = ',')
                )
    })
  })
    
  

  #------------#
  # Transformation logic
  ## 若觀察到用戶點擊"transform"按鈕,判斷是否提供了tag前綴(比如I)和tag名字(比如Item)
  ## 分支（1）：若tag前綴和tag名字都提供，將tag前綴和tag名字分離。判斷用戶提供的tag行數數目
  ### 分支（1.1）: 若tag行數數目為0，默認用戶tag信息放在heading裡面。直接用tag前綴進行transform。
  ### 分支（1.2）: 若tag行數數目大於0，默認用戶tag信息不放在heading裡面，而在數據的前N行。將前N行tag合併成一個特殊tag ID(mergeID)進行transform。mergeID將不同facet的tag用下劃線進行區別。最後再將mergeID分離成好幾個facet列。每一列都冠以tagNames。
  ## 分支（2）：若tag前綴和tag名字都不提供且tag行數（NText）為0。則直接將除一個列（ID）以外的列進行transform。適用於single facet design。
  #------------#
  datTrans <- eventReactive(input$transform, {
    N <- as.numeric(NText()) # number of facets
    dat <- sourceData()
    
    validate(need(is.finite(N) && N >= 0 && N < nrow(dat), "Select a valid number of facet rows."))

    if (nzchar(trimws(preFixText())) && nzchar(trimws(TagNamesText()))) {
      TagPreFix <- trimws(str_split(preFixText(), ",")[[1]])
      TagNames <- trimws(str_split(TagNamesText(), ",")[[1]])
      validate(need(all(nzchar(TagPreFix)) && all(nzchar(TagNames)), "Facet prefixes and names cannot be empty."))
      validate(need(!anyDuplicated(TagNames), "Facet names must be unique."))
      
      if (N == 0) { # 分支1.1：如果没有facet行，默认facet藏在heading里且为single facet,将PreFix开头的转化为long，冠以TagNames
        validate(need(length(TagPreFix) == 1 && length(TagNames) == 1,
                      "When facets are stored in column names, provide one prefix and one facet name."))
        matching_columns <- startsWith(colnames(dat), TagPreFix[[1]])
        validate(need(any(matching_columns), "No columns match the supplied facet prefix."))
        datTrans <- dplyr::tibble(dat) |>
          pivot_longer(cols = which(matching_columns), names_to = TagNames, values_to = "Score")
        
      }else if (N > 0){ # 分支1.2:如果有facet行，将tags of facet转换为合并的ID再进行long-format转化
        validate(need(length(TagNames) == N, "Provide one facet name for each facet row."))
        validate(need(length(TagPreFix) == N, "Provide one prefix for each facet row."))
        tags = dat[1:N, -1] # 取出levels名字
        # 将所有facets合并成特殊ID
        mergedID = apply(tags, 2, \(x) paste0(x, collapse = "_"))
        dat_FacetNameOmitted <- dplyr::tibble(dat[-(1:N), ]) # 去掉了facet信息的纯数据
        colnames(dat_FacetNameOmitted) <- c("Person", mergedID)
        datTrans <- dat_FacetNameOmitted |>
          pivot_longer(cols = any_of(as.character(mergedID)), values_to = "Score") |>
          separate(name, into = TagNames, sep = "_")

        for (index in seq_along(TagNames)) {
          datTrans[[TagNames[[index]]]] <- str_remove(
            datTrans[[TagNames[[index]]]],
            fixed(TagPreFix[[index]])
          )
        }
        
      }
    }else if (!nzchar(trimws(preFixText())) && !nzchar(trimws(TagNamesText())) && N == 0){
      datTrans <- dplyr::tibble(dat) |>
        pivot_longer(any_of(colnames(dat)[-1]), names_to = "Facet", values_to = "Score")
    }else{
      validate(need(FALSE, "Provide both facet prefixes and facet names, or leave both empty."))
    }
    validate(need(nrow(datTrans) > 0, "The transformation produced no observations."))
    transformedSource(dat)
    datTrans
  })

  ### Output transformed data table if any -----
  output$transDataTable <- renderDT({
    datatable(datTrans()) %>% formatRound('Score', 2)})
  
  output$downloadTransData <- downloadHandler(
    filename = "transformed.csv",
    content = \(file) {
      write.csv(datTrans(), file, row.names = FALSE)
    }
  )
  
  ### Output facets' level table if any -----
  output$FacetLevelTable <- renderDT({
    n_levels_facets = unlist(lapply(dat(), \(x) n_distinct(x)))
    result <- data.frame(colnames(dat()), n_levels_facets, check.names = FALSE)
    names(result) <- c(translate("variable"), translate("number_levels"))
    result
  })
  output$gstudyReady <- reactive(gstudyReady())
  output$dstudyReady <- reactive(dstudyReady())
  outputOptions(output, "gstudyReady", suspendWhenHidden = FALSE)
  outputOptions(output, "dstudyReady", suspendWhenHidden = FALSE)

  ### Update UI for data confirm and switch to Tab page 2 -----
  observeEvent(input$dataConfirm, {
    gstudyReady(FALSE)
    dstudyReady(FALSE)
    updateActionButton(
      session,
      inputId = "dataConfirm",
      icon = icon("check")
    )
    shinydashboard::updateTabItems(session, "sidebar", "datastructure")
  })
  observeEvent(dat(), {
    gstudyReady(FALSE)
    dstudyReady(FALSE)
    updateActionButton(
      session,
      inputId = "dataConfirm",
      icon = icon("circle")
    )
  })
  
  
  observeEvent(input$transform, {
    updateTabsetPanel(
      session,
      inputId = "tabsetData",
       selected = "transformed"
    )
  })
  
  ## Server for Page 2: Auto detect design of data ----------------------------------------------------
  ### Selection UI for user-selected facets / outcomes / ID ----------------------------------------
  observeEvent(input$dataConfirm, {
    dat <- dat()
    
    # 选择ID
    output$selectedIDUI <- renderUI({
      id_candidates <- c("Person", "Person_ID", "ID", "id")
      default_id <- intersect(id_candidates, colnames(dat))
      default_id <- if (length(default_id) > 0) default_id[[1]] else colnames(dat)[1]
      pickerInput(
        "selectedID",
        i18n_tag("id_variable"),
        choices = colnames(dat),
        selected = default_id
      )
    })
    
    # 选择outcome
    output$selectedOutcomeUI <- renderUI({
      id_value <- if (!is.null(input$selectedID)) input$selectedID else colnames(dat)[1]
      outcome_candidates <- setdiff(colnames(dat), id_value)
      req(length(outcome_candidates) > 0)
      preferred_outcomes <- intersect(c("Score", "score", "Outcome", "outcome", "Y", "y"), outcome_candidates)
      numeric_outcomes <- outcome_candidates[vapply(dat[outcome_candidates], is.numeric, logical(1))]
      default_outcome <- if (length(preferred_outcomes) > 0) preferred_outcomes[[1]] else if (length(numeric_outcomes) > 0) numeric_outcomes[[1]] else outcome_candidates[[1]]
      pickerInput(
        "selectedOutcome",
        i18n_tag("outcome_variable"),
        choices = outcome_candidates,
        selected = default_outcome
      )
    })
    
    # 选择facet
    output$selectedMultipleFacetsUI <- renderUI({
      id_value <- if (!is.null(input$selectedID)) input$selectedID else colnames(dat)[1]
      outcome_value <- if (!is.null(input$selectedOutcome)) input$selectedOutcome else setdiff(colnames(dat), id_value)[1]
      facet_choices <- setdiff(colnames(dat), c(id_value, outcome_value))
      example_defaults <- list(
        "Rajaratnam.2" = c("Subtest", "Item"),
        "Brennan.3.2" = c("Task", "Rater")
      )
      default_facets <- if (
        isFALSE(input$fileUploadSwitch) && input$selectedExpDat %in% names(example_defaults)
      ) {
        intersect(example_defaults[[input$selectedExpDat]], facet_choices)
      } else {
        facet_choices
      }
      pickerInput(
        "selectedMultipleFacets",
        i18n_tag("facets"),
        choices = facet_choices,
        selected = default_facets,
        multiple = TRUE
      )
    })
    
    # 选择covariates
    output$selectedCovariatesUI <- renderUI({
      id_value <- if (!is.null(input$selectedID)) input$selectedID else colnames(dat)[1]
      outcome_value <- if (!is.null(input$selectedOutcome)) input$selectedOutcome else setdiff(colnames(dat), id_value)[1]
      facet_values <- if (!is.null(input$selectedMultipleFacets)) input$selectedMultipleFacets else character()
      prettyCheckboxGroup(
        inputId = "selectedCovariates",
        label = i18n_tag("covariates"),
        choices = setdiff(colnames(dat), c(id_value, outcome_value, facet_values)),
        selected = NULL,
        icon = icon("check"), 
        shape = "round",
        status = "primary",
        inline = TRUE,
        animation = "jelly"
      )
    })
    
    # 选择是否要进行mGtheory
    output$mGtheoryUI <- renderUI({
      tagList(
        prettySwitch(inputId = "mGtheory",
                     label = strong(i18n_tag("multivariate")),
                     value = FALSE, width = "400px"),
        helpText(i18n_tag("multivariate_help"))
      )
    })
    
    # mgTheory选择fixed facet
    output$selectedFixedFacetUI <- renderUI({
      pickerInput(
        "selectedFixedFacet",
        i18n_tag("fixed_facet"),
        choices = selectedFacet(),
        selected = selectedFacet()[1]
      )
    })
    
    # mgTheory选择fixed facet weights
    output$selectedFixedFacetWeightsUI <- renderUI({
      textInput(
        inputId = "selectedFixedFacetWeights",
        label = i18n_tag("fixed_weights"),
        value = paste0(rep(1, n_distinct(dat[[selectedFixedFacet()]])), collapse = ";")
      )
    })
    
    
    # mgTheory选择 facet with unstructured var-cov matrix
    output$selectedFacetWithUSComponentUI <- renderUI({
      # all random facets except fixed facet
      all_facets = c(selectedID(), selectedFacet())
      random_facets <- setdiff(all_facets, input$selectedFixedFacet)
      choice_facets = random_facets
      
      checkboxGroupButtons(
        "selectedFacetWithUSComponent",
        label = i18n_tag("covariance_facets"),
        choices = c(random_facets, "Residual"),
        selected = choice_facets,
        status = "success",
        checkIcon = list(
          no = icon("circle"),
          yes = icon("check")
        )
      )
    })
    
    output$reportFacets <- renderText({
      facets_cov_text <- paste0(selectedFacetWithUSComponent(), collapse = "; ")
      facets_var_text <- paste0(setdiff(c(selectedID(), selectedFacet()), 
                                        c(selectedFixedFacet(), selectedFacetWithUSComponent())), 
                                collapse = "; ")
        
      paste0(
        translate("report_id"), ": ", selectedID(), ";\n",
        translate("report_outcome"), ": ", selectedOutcome(), ";\n",
        translate("report_fixed"), ": ", selectedFixedFacet(), ";\n",
        translate("report_covariance"), ": ", facets_cov_text, ";\n",
        translate("report_variance"), ": ", facets_var_text, ";"
      )
    })
  })
  
  ### Reactive facets / outcomes / ID ----------------------------------------
  selectedID = reactive({input$selectedID}) ## ID
  selectedOutcome = reactive({input$selectedOutcome}) ## Outcome (i.e., Score)
  selectedFacet = reactive({input$selectedMultipleFacets}) ## Facets used for gstudy/dstudy
  selectedCovariates = reactive({input$selectedCovariates}) ## covariates for fixed effects
  selectedMissingMethod = reactive({input$missingMethod}) ## selected missing data handling method
  ## mGtheory
  selectedFixedFacet = reactive({input$selectedFixedFacet}) ## mgtheory: fixed facet
  selectedFacetWithUSComponent = reactive({input$selectedFacetWithUSComponent})
  

  ## missing data inputation
  datNARemoved <- eventReactive(input$variableSettingConfirm, {
    dat <- dat()
    selectedOutcome <- selectedOutcome()
    tryCatch(
      validate_analysis_data(dat, selectedID(), selectedOutcome, selectedFacet()),
      error = function(error) validate(need(FALSE, conditionMessage(error)))
    )
    dat[[selectedOutcome]] <- tryCatch(
      safe_numeric(dat[[selectedOutcome]], selectedOutcome),
      error = function(error) validate(need(FALSE, conditionMessage(error)))
    )
    ## Deal with missing method for outcome variables
    if(selectedMissingMethod() == "zero"){
      dat[[selectedOutcome]] <- replace(dat[[selectedOutcome]], 
                                        is.na(dat[[selectedOutcome]]), 
                                        0)
    }else if(selectedMissingMethod() == "mean"){
      dat[[selectedOutcome]] <- replace(dat[[selectedOutcome]], 
                                        is.na(dat[[selectedOutcome]]), 
                                        mean(dat[[selectedOutcome]], na.rm = TRUE))
    }else if(selectedMissingMethod() == "median"){
      dat[[selectedOutcome]] <- replace(dat[[selectedOutcome]], 
                                        is.na(dat[[selectedOutcome]]), 
                                        median(dat[[selectedOutcome]], na.rm = TRUE))
    }else{ ## listwise deletion
      dat <- dat[!is.na(dat[[selectedOutcome]]),]
    }
    validate(need(nrow(dat) > 0, "No observations remain after missing-data handling."))
    validate(need(any(is.finite(dat[[selectedOutcome]])), "The selected outcome has no usable values."))
    dat
  })
  
  ### nestedStrc: automatically detect design of data and return structure table-----
  nestedStrc <- eventReactive(input$variableSettingConfirm, {
    dat <- datNARemoved()
    selectedFacet <- c(selectedFacet(), selectedID()) # facets and ID
    
    if (length(selectedFacet) == 1) { # if single facet
      nestedStrc = data.frame(NA)
      colnames(nestedStrc) = selectedFacet
      nestedStrc
    }else{ # if multiple facets
      # Each row represents a pair of facets
      TagPairs <- as.data.frame(t(combn(selectedFacet, 2))) 
      relationship <- rep(NA_character_, nrow(TagPairs))
      # Set two facets into "f1" and "f2"
      colnames(TagPairs) <- c("f1", "f2")
      # Compare facet with the other pair by pair
      for (pair in 1:nrow(TagPairs)) {
        whichpair = TagPairs[pair,]
        left_to_right <- all(vapply(
          split(dat[[whichpair[[2]]]], dat[[whichpair[[1]]]]),
          function(values) dplyr::n_distinct(values) <= 1,
          logical(1)
        ))
        right_to_left <- all(vapply(
          split(dat[[whichpair[[1]]]], dat[[whichpair[[2]]]]),
          function(values) dplyr::n_distinct(values) <= 1,
          logical(1)
        ))
        relationship[pair] <- if (left_to_right && right_to_left) {
          "Confounded (one-to-one)"
        } else if (left_to_right) {
          paste(whichpair[[1]], "nested in", whichpair[[2]])
        } else if (right_to_left) {
          paste(whichpair[[2]], "nested in", whichpair[[1]])
        } else {
          "Crossed"
        }
      }
      nestedStrc = TagPairs
      nestedStrc$Relationship = relationship
      nestedStrc
    }
  })
  
  ## Update UI for facet settings and switch to Tab page 3 -----
  observeEvent(input$variableSettingConfirm, {
    gstudyReady(FALSE)
    dstudyReady(FALSE)
    updateActionButton(inputId = "variableSettingConfirm", icon = icon("check"))
    shinydashboard::updateTabItems(session, "sidebar", "dataanalysis")
  })
  
  


  ### Generate gtheory formula ----------------------------------------
  #------------#
  # 若點擊確認(confirm)按鈕，根據design structure進行逐行掃描:
  ## 分支1: 若design structure為單列，則為single facet。進行下列操作:
  ##        1, 生成selectedOutcome() ~ (1 | selectedID()) + (1 | selectedFacet())
  ## 分支2: 若design structure為多列，則為multiple facets。
  ### 分支2.1: 若是univariate gtheory （input$mGtheory == FALSE）
  ### 分支2.2: 若是multivariate gtheory （input$mGtheory == TRUE）
  #------------#
  
  gtheoryFormula <- eventReactive(input$variableSettingConfirm, {
    formularFacets <- NULL # placeholder for formula
    nestedStrcTable <- nestedStrc() # load nested structure
    selectedOutcome <- selectedOutcome() # user-defined DV
    selectedFacet <- selectedFacet() # user-defined facet(s)
    selectedCovariates <- selectedCovariates() # user-defined covariates
    selectedID <- selectedID()
    
    if (input$mGtheory == FALSE) { # univariate g-theory
        validate(need(
          !any(grepl("Confounded", nestedStrcTable$Relationship, fixed = TRUE)),
          "Two selected facets have a one-to-one relationship and cannot be separated. Remove or combine one of them."
        ))
        for (r in 1:nrow(nestedStrcTable)) { # loop over each row
          left <- as.character(nestedStrcTable[r, 1])
          right <- as.character(nestedStrcTable[r, 2])
          relation <- nestedStrcTable$Relationship[[r]]
          if (identical(relation, "Crossed")) {
            formularFacets <- c(
              formularFacets,
              glue::glue("(1 | {left})"),
              glue::glue("(1 | {right})"),
              glue::glue("(1 | {left}:{right})")
            )
          } else if (identical(relation, paste(left, "nested in", right))) {
            formularFacets <- c(
              formularFacets,
              glue::glue("(1 | {right})"),
              glue::glue("(1 | {right}:{left})")
            )
          } else {
            formularFacets <- c(
              formularFacets,
              glue::glue("(1 | {left})"),
              glue::glue("(1 | {left}:{right})")
            )
          }
        }
        formularFacets <- unique(formularFacets)
        grouping_names <- stringr::str_match(formularFacets, "\\|\\s*([^\\)]+)\\)")[, 2]
        estimable <- vapply(
          grouping_names,
          function(term) grouping_term_estimable(datNARemoved(), term),
          logical(1)
        )
        omittedGroupingTerms(grouping_names[!estimable])
        formularFacets <- formularFacets[estimable]
        validate(need(length(formularFacets) > 0, "No random effects have enough replication to estimate."))
        rhs <- c(selectedCovariates, formularFacets)
        formularText <- paste0(rhs[nzchar(rhs)], collapse = " + ")
        formularText <- glue::glue("{selectedOutcome} ~ {formularText}")
        formularText
    }else{ # multivariate g-theory
        omittedGroupingTerms(character())
        fixedfacet <- selectedFixedFacet()
        facetWithUSComponent <- setdiff(selectedFacetWithUSComponent(), "Residual")
        facetWithDiagComponent <- setdiff(c(selectedID(), selectedFacet()), 
                                          c(selectedFixedFacet(), selectedFacetWithUSComponent()))
        
        if (any(is.na(facetWithUSComponent))) { # if only facets with diag 
          formularRHS <- paste0(glue::glue("diag({fixedfacet} + 0 | {facetWithDiagComponent})"), 
                                collapse = " + ")
        }else if(any(is.na(facetWithDiagComponent))){ # if only facet with cov-covariance
          formularRHS <- paste0(glue::glue("us({fixedfacet} + 0 | {facetWithUSComponent})"), 
                                collapse = " + ")
        }else{
          formularRHS <- paste0(c(
            glue::glue("0 + {fixedfacet}"), 
            glue::glue("us({fixedfacet} + 0 | {facetWithUSComponent})"), 
            glue::glue("diag({fixedfacet} + 0 | {facetWithDiagComponent})")), 
            collapse = " + ")
        }
        
        formularText <- paste0(selectedOutcome, " ~ ", formularRHS)
        formularText
        
    }
  })

   ### Output simplified fomular text ----------------------------------------
   output$recommFormular <- renderText({
     #akeeasyformular(gtheoryFormula())
     gtheoryFormula()
   })

   ### Output data design table ----------------------------------------
   observeEvent(input$variableSettingConfirm, {
     dat <- datNARemoved()
     # 表格打印： facet嵌套
     output$nestedStrucTable <- renderDT({
       result <- nestedStrc()
       if ("Relationship" %in% names(result)) {
         result$Relationship <- vapply(seq_len(nrow(result)), function(index) {
           relation <- result$Relationship[[index]]
           if (!identical(language(), "zh")) return(relation)
           if (identical(relation, "Crossed")) return(translate("crossed"))
           if (identical(relation, "Confounded (one-to-one)")) return(translate("confounded"))
           left <- as.character(result[index, 1])
           right <- as.character(result[index, 2])
           if (identical(relation, paste(left, "nested in", right))) {
             translate("nested_in", left, right)
           } else {
             translate("nested_in", right, left)
           }
         }, character(1))
         names(result)[names(result) == "Relationship"] <- translate("relationship")
       }
       result
     })

     # 表格打印： 总结样本量
     output$factorNestTable <- renderDT({
       facets  <- selectedFacet()
       outcome  <- selectedOutcome()
       validate(need(
         length(facets) > 0 && all(c(facets, outcome) %in% names(dat)),
         "Confirm the variable selections for the current dataset."
       ))
       result <- dat |>
         group_by(across(all_of(facets))) |>
         summarise(`Sample Size (Outcome)` = n(), .groups = "drop")
       names(result)[names(result) == "Sample Size (Outcome)"] <- translate("sample_size_outcome")
       result
     })
   })

  ## Run recommended model ------------------------------------------------------------------
  #------------#
  # 分支1: 若為univariate gstudy，運行glmer
  # 分支2: 若為multivariate gstudy，運行lmmTMB::glmmTMB
  #------------#

  ### Run gstudy  ----------------------------------------
  #### Link Functions  ----------------------------------------
  linkFuncText <- reactive({input$linkFunc})
  
  ###### --- 
  # Return a list with three elements:
  # lmmFit: lme4 object
  # fixedEffect: vector; fixed effect
  # VarComp: matrix; variance-covariance matrix
  # gstudy: gstudy Class
  ###### ---
  gstudyResult <- eventReactive(input$runGstudyButton, {
    nFacet <- NULL
    linkFuncText <- linkFuncText()
    datG <- datNARemoved() # data used for gstudy
    tryCatch(
      validate_analysis_data(datG, selectedID(), selectedOutcome(), selectedFacet()),
      error = function(error) validate(need(FALSE, conditionMessage(error)))
    )
    ## make sure outcome as numeric and facet as factors
    datG[[selectedOutcome()]] <- tryCatch(
      safe_numeric(datG[[selectedOutcome()]], selectedOutcome()),
      error = function(error) validate(need(FALSE, conditionMessage(error)))
    )
    tryCatch(
      validate_family_outcome(datG[[selectedOutcome()]], linkFuncText),
      error = function(error) validate(need(FALSE, conditionMessage(error)))
    )
    datG[c(input$selectedID, selectedFacet())] <- lapply(datG[c(input$selectedID, selectedFacet())], as.factor)
    
    ###### --- 
    # Family selection
    # c("identity", "logit", "poisson", "inverse gamma")
    ###### ---
    if (linkFuncText == "identity") {
      linkFunc <- gaussian(link = "identity")
      # glmer = lme4::lmer
    }else if(linkFuncText == "logit"){
      linkFunc <- binomial(link = "logit")
    }else if(linkFuncText == "poisson"){
      linkFunc <- poisson(link = "log")
    }else if(linkFuncText == "inverse gamma"){
      linkFunc <- Gamma(link = "inverse")
    }else{
      linkFunc <- gaussian(link = "identity")
    }
    
    if (input$mGtheory == FALSE) { # 分支1: 若為univariate gstudy
      
      ####  glmer function ----------------------------------------
      self_formula <- if (is.null(input$selfFormular)) "" else trimws(input$selfFormular)
      if (!nzchar(self_formula)) { # 分支1.1.若用戶沒有自定義公式
        formulaRecomm <- as.formula(gtheoryFormula())
        if (linkFuncText == "identity") {
          lmmFit <- lme4::lmer(data = datG, formula = formulaRecomm, REML = TRUE)
        } else {
          lmmFit <- lme4::glmer(data = datG, formula = formulaRecomm, family = linkFunc)
        }
      } else{ # 分支1.1.若用戶自定義公式，則轉化爲lme4直接使用用戶的公式
        user_formula <- tryCatch(
          build_safe_random_formula(self_formula, datG),
          error = function(error) validate(need(FALSE, paste("Invalid formula:", conditionMessage(error))))
        )
        if (linkFuncText == "identity") {
          lmmFit <- lme4::lmer(data = datG, formula = user_formula, REML = TRUE)
        } else {
          lmmFit <- lme4::glmer(data = datG, family = linkFunc, formula = user_formula)
        }
      }
      ## Random effects
      randomEffectEstimate <- ranef(lmmFit)
      randomEffectLevel <- sapply(lapply(datG[selectedFacet()], unique), length)
      allRandomFacets(unlist(randomEffectLevel[selectedFacet()]))
      fixedEffectEstimate <- as.data.frame(summary(lmmFit)$coefficients)
      
      # return
      list(
        lmmFit = lmmFit,
        fixedEffect = fixedEffectEstimate,
        VarComp = gstudy(lmmFit)$gstudy.out,
        gstudy = gstudy(lmmFit)
      )
      
    }else{# 分支2: 若為multivariate gstudy
      ### mGtheory estimtion ----------------------------------------
      facets_US <- selectedFacetWithUSComponent()
      self_formula <- if (is.null(input$selfFormular)) "" else trimws(input$selfFormular)
      if (!nzchar(self_formula)) { # 分支2.1.若用戶沒有自定義公式
        formulaTxt <- gtheoryFormula()
        formulaRecomm <- as.formula(formulaTxt)
        lmmFit0 <- glmmTMB::glmmTMB(
          data = datG,
          formula = formulaRecomm,
          family = linkFunc,
          dispformula = ~0,
          REML = TRUE
        )
        ## extract residual var-cov matrix
        residuals_Person <- cbind(residuals = residuals(lmmFit0, "response"),
                                  datG[c(selectedID(), selectedFacet())]) %>%
          pivot_wider(names_from = selectedFixedFacet(), 
                      values_from = residuals, 
                      names_prefix = "facet") %>%
          ungroup()
        residual_cor = cor(residuals_Person |> dplyr::select(starts_with("facet")),
                           use = "pairwise.complete.obs")
        residual_cov = cov(residuals_Person |> dplyr::select(starts_with("facet")),
                           use = "pairwise.complete.obs")
        ###### --- 
        # run second time
        ###### ---
        dat2 = datG
        dat2$Residual = residuals(lmmFit0, "response")
        if ("Residual" %in% facets_US) {
          formulaWtResidTxt <- paste0(formulaTxt, 
                                      " + us(", selectedFixedFacet(), 
                                      " + 0 | Residual)")
        }else{
          formulaWtResidTxt <- paste0(formulaTxt, 
                                      " + diag(", selectedFixedFacet(), 
                                      " + 0 | Residual)")
        }
        
        formulaRecommWtResid <- as.formula(formulaWtResidTxt)
        lmmFit <- glmmTMB::glmmTMB(
          formula = formulaRecommWtResid,
          data = dat2,
          family = linkFunc,
          dispformula =~0,
          REML = TRUE
        )
        # Extract variance component matrix
        res <- lme4::VarCorr(lmmFit)
        resVarCorMat <- extract.VarCorr.glmmTMB(x = res$cond,
                                                residCor = residual_cor,
                                                facetName = selectedFixedFacet())
        resVarCor <- resVarCorMat$resTable_cor
        resVarCov <- resVarCorMat$resTable_cov
        
        # Extract fit estiates
        fixedEffectEstimate <- extractFixedCoefsmG(lmmFit)
        
        ## generalizability coefficient
        g_coef <- gCoef_mGTheory(
          glmmTMBObj = lmmFit,
          residual_cov = residual_cov,
          person_ID = selectedID(),
          weights = input$selectedFixedFacetWeights
        )
        
        ###### --- 
        # Return values
        ###### ---
        list(
          lmmFit0 = lmmFit0,
          lmmFit = lmmFit,
          data = dat2,
          fixedEffect = fixedEffectEstimate,
          VarComp = resVarCov,
          mGtheoryFormula = formulaWtResidTxt,
          g_coef = g_coef # return a mGStudy class
        )
        
      } else{ # 分支2.1.若用戶自定義公式，則轉化爲lme4直接使用用戶的公式
        shinyjs::alert("This function is currently not available!")
      }
    }
  })     

  observeEvent(input$runGstudyButton, {
    gstudyReady(FALSE)
    dstudyReady(FALSE)
    tryCatch(
      {
        gstudyResult()
        gstudyReady(TRUE)
      },
      error = function(error) {
        showNotification(conditionMessage(error), type = "error", duration = 10)
      }
    )
  }, ignoreInit = TRUE)
  
  ### Run gstudy bootstrapping ----------------------------------------
  output$nCoresUI <- renderUI({
    detected_cores <- parallel::detectCores(logical = FALSE)
    if (is.na(detected_cores)) detected_cores <- 1L
    max_cores <- max(1L, min(4L, detected_cores - 1L))
    pickerInput(inputId = "nCores",
                label = i18n_tag("cores"),
                selected = min(2L, max_cores),
                choices = seq_len(max_cores))
  })
  nCores <- reactive(input$nCores)
  
  ###### --- 
  # return bootMer object
  ###### ---
  gstudyResultBoot <- eventReactive(input$runGstudyBootButton, {
    datGBoot <- datNARemoved()
    datGBoot[[selectedOutcome()]] <- safe_numeric(datGBoot[[selectedOutcome()]], selectedOutcome())
    datGBoot[c(input$selectedID, selectedFacet())] <- lapply(datGBoot[c(input$selectedID, selectedFacet())], as.factor)
    
    # ProgressBar: start of bootstrapping
    updateProgressBar(session = session, id = "gstudybar", 
                      value = 30, total = 100,
                      title = translate("in_progress"))
    if (input$mGtheory == FALSE) {
      requested_cores <- max(1L, as.integer(nCores()))
      if (requested_cores > 1L) {
        cluster <- parallel::makePSOCKcluster(requested_cores)
        on.exit(parallel::stopCluster(cluster), add = TRUE)
        local_library <- normalizePath(file.path(getwd(), ".Rlib"), winslash = "/", mustWork = FALSE)
        parallel::clusterCall(cluster, function(path) {
          if (dir.exists(path)) .libPaths(c(path, .libPaths()))
          suppressPackageStartupMessages(library(lme4))
          invisible(TRUE)
        }, local_library)
        boot.gstudy <- lme4::bootMer(
          gstudyResult()$lmmFit,
          gstudy.forboot,
          nsim = input$nboot,
          use.u = FALSE,
          type = "parametric",
          parallel = "snow",
          ncpus = requested_cores,
          cl = cluster
        )
      } else {
        boot.gstudy <- lme4::bootMer(
          gstudyResult()$lmmFit,
          gstudy.forboot,
          nsim = input$nboot,
          use.u = FALSE,
          type = "parametric",
          parallel = "no"
        )
      }
      failed_runs <- sum(!stats::complete.cases(boot.gstudy$t))
      if (failed_runs >= input$nboot) {
        stop("All bootstrap runs failed. Review model diagnostics and simplify the model.", call. = FALSE)
      }
      if (failed_runs > 0) {
        showNotification(
          sprintf("%d of %d bootstrap runs failed and were excluded.", failed_runs, input$nboot),
          type = "warning",
          duration = 10
        )
      }
    }else if(input$mGtheory == TRUE){
      model.fit = gstudyResult()$lmmFit
      boot.gstudy <- confint(model.fit)
      
    }
    # ProgressBar: end of bootstrapping
    updateProgressBar(session = session, id = "gstudybar", 
                      value = 100, total = 100,
                      title = translate("finished"), status = "success")
    boot.gstudy
  })
  
  ### Run gstudy bootstrapping CI ----------------------------------------
  ###### --- 
  # Return data frame of gstudy variance components with bootstrapping CI
  ###### ---
  gstudyResultBootCI <- eventReactive(input$runGstudyBootButton, {
    gstudy_res <- gstudyResult()$VarComp # Variance-covariance
    boot_gstudy_res <- gstudyResultBoot() # bootMer object
    
    # calculate bootstrap CI and bind with estimated variances (and covarinces, if mgstudy)
    if (input$mGtheory == FALSE) {
      bootCI_gstudy_res <-
        t(apply(boot_gstudy_res$t, 2, function(x) {
          quantile(x, probs = c(.025, .975), na.rm = TRUE)
        }))
      as.data.frame(cbind(gstudy_res, bootCI_gstudy_res))
    }else{
      # ongoing: placeholder for mgstudy boostrap
      bootCI_gstudy_res <- boot_gstudy_res
      bootCI_gstudy_res = bootCI_gstudy_res |> 
        as.data.frame() |> 
        rownames_to_column("Components") |> 
        filter(str_detect(Components, "Std.Dev|Cor")) |> 
        separate(Components, into = c("VarCov", "Facet"), sep = "\\|") |> 
        group_by(Facet) |> 
        mutate(across(`2.5 %`:Estimate,  \(x) case_when(
          str_detect(VarCov, "Cor.") ~ prod(x),
          TRUE ~ x^2
        ))) |> 
        mutate(
          VarCov = str_replace(VarCov, "Std.Dev", "Var"),
          VarCov = str_replace(VarCov, "Cor", "Cov"),
        )
      
    }
  })
  
  ### Output gstudy results and bootstrapping  ----------------------------------------
  output$recommModelFixedEffectResult <- renderDT(round(gstudyResult()$fixedEffect, 3))
  output$GstudyResultPrint <- renderDT({
    res <- gstudyResult()$VarComp
    datatable(res) |> 
      formatRound(colnames(res)[sapply(res, is.numeric)], digits = 3)
  })
  output$GstudyResultExtraPrint <- renderText({
    if (input$mGtheory == TRUE) {
      glue::glue("g-coefficient: {gstudyResult()$g_coef}\n
                 glmmTMB formula: {gstudyResult()$mGtheoryFormula}\n
                 Note: the bootstrapping method of mGtheory uses non-bootstrapping confidence intervals")
    }
  })
  output$gstudyInterpretation <- renderUI({
    result <- gstudyResult()
    if (isTRUE(input$mGtheory)) {
      return(tags$p(coefficient_guidance(as.numeric(result$g_coef), "generalizability", language())))
    }
    components <- result$VarComp
    non_person <- components[components$Source != selectedID(), , drop = FALSE]
    largest <- non_person$Source[which.max(non_person$Est.Variance)]
    singular <- lme4::isSingular(result$lmmFit, tol = 1e-4)
    convergence_messages <- unlist(result$lmmFit@optinfo$conv$lme4$messages, use.names = FALSE)
    tagList(
      tags$p(translate("largest_variance", largest)),
      if (length(omittedGroupingTerms()) > 0) tags$div(
        class = "alert alert-info",
        translate("omitted_terms", paste(omittedGroupingTerms(), collapse = ", "))
      ),
      if (singular) tags$div(
        class = "alert alert-warning",
        translate("singular_warning")
      ) else tags$div(class = "alert alert-success", translate("no_singular")),
      if (length(convergence_messages) > 0) tags$div(
        class = "alert alert-warning",
        translate("convergence_warning", paste(convergence_messages, collapse = " "))
      ),
      tags$p(translate("use_dstudy"))
    )
  })
  output$recommModelGStudyBootResult <- renderDT({
    res <- gstudyResultBootCI()
    datatable(res) |> 
      formatRound(colnames(res)[sapply(res, is.numeric)], digits = 3)
  })
  
  ### buttons: gstudy results download  ----------------------------------------
  ###### --- 
  # downloadGstudyTheta: button for download theta scores
  # downloadGstudyBootResult: button for download bootstrapping results
  ###### ---
  output$downloadGstudyTheta <- downloadHandler(
    filename = "thetaEstimates.csv",
    content = \(file) {write.csv(extractTheta(gstudyResult()$lmmFit), file, row.names = FALSE)}
  )
  
  output$downloadGstudyBootResult <- downloadHandler(
    filename = paste0("gstudyBootstrapN", input$nboot, ".csv"),
    content = \(file) {write.csv(gstudyResultBootCI(), file, row.names = FALSE)}
  )
  
  ###  Pre-specifications for dstudy ----------------------------------------
  #### UI for facet and condition selection  ----------------------------------------
  # Register each output/observer once. Opening the panel must not reset edits
  # or retain callbacks with sample sizes from a previous dataset.
  output$selectedFacetMenu <- renderUI({
    choices <- names(defaultN())
    if (isTRUE(input$mGtheory)) choices <- setdiff(choices, selectedFixedFacet())
    req(length(choices) > 0)
    selected <- isolate(input$FacetDStudySelector)
    if (!length(selected) || !selected %in% choices) selected <- choices[[1]]
    pickerInput("FacetDStudySelector", i18n_tag("select_facet"),
                choices = choices, selected = selected)
  })

  output$selectedFacetLevels <- renderUI({
    facet <- selectedFacetForDstudy()
    observed <- defaultN()
    req(length(facet) == 1, facet %in% names(observed))
    value <- isolate(updatedN()[facet])
    if (!length(value) || !is.finite(value)) value <- observed[[facet]]
    numericInput("FacetValueSlider", i18n_tag("number_conditions"),
                 value = unname(value), min = 1, step = 1)
  })

  output$selectedMultipleFacetLevels <- renderUI({
    facet <- selectedFacetForDstudy()
    observed <- defaultN()
    req(length(facet) == 1, facet %in% names(observed))
    start <- observed[[facet]]
    textInput("FacetValueRange", i18n_tag("condition_range"),
              value = paste(start, start * 10, max(1, start), sep = ":"),
              placeholder = tr_text("en", "condition_range_placeholder"))
  })

  observeEvent(input$confirmFacetLevel, {
    facet <- selectedFacetForDstudy()
    value <- selectedFacetValue()
    updated <- updatedN()
    if (length(facet) != 1 || !facet %in% names(updated) ||
        length(value) != 1 || !is.finite(value) || value < 1 || value != floor(value)) {
      showNotification(translate("invalid_facet_levels"), type = "error")
      return()
    }
    updated[facet] <- value
    updatedN(updated)
    dstudyReady(FALSE)
  })

  output$updatedNDT <- renderDT({
    updated <- updatedN()
    req(length(updated) > 0)
    result <- data.frame(names(updated), unname(updated),
                         unname(defaultN()[names(updated)]), check.names = FALSE)
    names(result) <- c(translate("facet"), translate("new_conditions"), translate("observed_conditions"))
    result
  })

  #### Selectors for Facet levels  ----------------------------------------
  ###### --- 
  # selectedFacetValue: number of conditions for certain facet
  # selectedFacetForDstudy: Facet drop-down selector for certain facet
  ###### ---
  selectedFacetValue <- reactive({input$FacetValueSlider})
  selectedFacetForDstudy <- reactive({input$FacetDStudySelector})
  
  #### button: confirm the facet levels  ----------------------------------------
  defaultN <- reactive({
    dat <- datNARemoved()
    sapply(dat[selectedFacet()], n_distinct)
  })
  
  observeEvent(input$variableSettingConfirm, {
    updatedN(defaultN())
  })
  
  
  
  ### Run dstudy ----------------------------------------
  ###### --- 
  # Return a dStudy-class object, which is a list containing 5 elements:
  # 1. ds.df: a dataframe with varaince components
  # 2. relvar: relative error variance
  # 3. absvar: absolute error variance
  # 4. gcoef: generalizability coefficient
  # 5. dcoef: generalizability coefficient
  ###### ---
  dstudyResult <- eventReactive(input$runDstudyButton, {
    datD <- datNARemoved()
    
      datD[[selectedOutcome()]] <- safe_numeric(datD[[selectedOutcome()]], selectedOutcome())
    datD[c(input$selectedID, selectedFacet())] <- lapply(datD[c(input$selectedID, selectedFacet())], as.factor)
    
    
    if (input$mGtheory == FALSE) { # 分支1: 若為univariate gstudy
      ## gstudy results
      gstudy_res <- gstudyResult()$gstudy
      dstudy_res = dstudy(x = gstudy_res, n = updatedN(), unit = selectedID())
      
    }else{# 分支2: 若為multivariate gstudy,运行mdstudy
      gstudyVarCovMat <- gstudyResult()$VarComp
      facetName <- selectedFixedFacet()
      n <- updatedN()[setdiff(names(updatedN()), facetName)]
      
      dstudy_res = dstudy.VarCov(gstudyVarCovMat = gstudyVarCovMat,
                                 n = n,
                                 facetName = facetName)
      
      ## g-coefficient estimation: Extract variance and covariance 
      person_cov = dstudy_res |> 
        filter(Source == selectedID()) |> 
        select(-Source, -Fixed.Facet) |> 
        as.matrix()
      
      residual_cov = dstudy_res |> 
        filter(Source == "Residual") |> 
        select(-Source, -Fixed.Facet) |> 
        as.matrix()
      
      dstudy_res = list(
        VarCov = dstudy_res,
        gCoef = gCoef_mGTheory(
          residual_cov = residual_cov,
          person_cov = person_cov,
          weights = input$selectedFixedFacetWeights
        )
      )
    }
    
    dstudy_res
  })

  observeEvent(input$runDstudyButton, {
    dstudyReady(FALSE)
    tryCatch(
      {
        if (!gstudyReady()) stop(translate("run_gstudy_first"), call. = FALSE)
        dstudyResult()
        dstudyReady(TRUE)
      },
      error = function(error) {
        showNotification(conditionMessage(error), type = "error", duration = 10)
      }
    )
  }, ignoreInit = TRUE)
  
  ### Run dstudy bootstrapping  ----------------------------------------
  ###### --- 
  # return bootstrapping iterations
  ###### ---
  dstudyResultBoot <- eventReactive(input$runDstudyBootButton, {
    datDBoot <- datNARemoved()
    datDBoot[[selectedOutcome()]] <- safe_numeric(datDBoot[[selectedOutcome()]], selectedOutcome())
    datDBoot[c(input$selectedID, selectedFacet())] <- lapply(datDBoot[c(input$selectedID, selectedFacet())], as.factor)
    
    boot_dstudy <- NULL # for bootstrapping iterations
    gstudy_res <- gstudyResult()$gstudy
    boot_gstudy_res <- gstudyResultBoot()
    bootCI_gstudy_res <- gstudyResultBootCI()
    
    updateProgressBar(session = session, id = "dstudybar", 
                      value = 30, total = 100,
                      title = paste0(translate("in_progress"), ": 30%"))
    for (i in 1:input$nboot) {
      gstudy_res$gstudy.out[, 2] <- t(boot_gstudy_res$t)[, i]
      temp.dstudy <- dstudy.forboot(x = gstudy_res, n = updatedN(), unit = selectedID())
      
      boot_dstudy <- rbind(
        boot_dstudy,
        c(temp.dstudy$ds.df[, 4],
          temp.dstudy$relvar,
          temp.dstudy$absvar,
          temp.dstudy$gcoef,
          temp.dstudy$dcoef
        )
      )
      updateProgressBar(session = session, id = "dstudybar", 
                        value = 30+(70 / input$nboot * i), total = 100,
                        title = paste0(translate("in_progress"), ": ", round(30+(70 / input$nboot * i), 2), "%"))
    }
    updateProgressBar(session = session, id = "dstudybar", 
                      value = 100, total = 100,
                      title = translate("finished"),
                      status = "success")
    boot_dstudy # nboot X (vcov.n + var + coef)
  })
  
  ### Run dstudy bootstrapping CI ----------------------------------------
  dstudyResultBootCI <- eventReactive(input$runDstudyBootButton, {
    
    dstudy_res_boot <- dstudyResult()
    boot_iteration_raw <- dstudyResultBoot()
    
    dstudy.res.CI <- t(apply(boot_iteration_raw, 2, 
                             \(x) {quantile(x, probs = c(.025, .975))} ))
    names(dstudy.res.CI) <- c("2.5%", "97.5%")
    
    # beautify output
    dstudy_res_boot$dcoef[2] <- dstudy.res.CI[nrow(dstudy.res.CI), 1]
    dstudy_res_boot$dcoef[3] <- dstudy.res.CI[nrow(dstudy.res.CI), 2]
    names(dstudy_res_boot$dcoef) <- c("Est", "2.5%", "97.5%")
    
    dstudy_res_boot$gcoef[2] <- dstudy.res.CI[nrow(dstudy.res.CI) - 1, 1]
    dstudy_res_boot$gcoef[3] <- dstudy.res.CI[nrow(dstudy.res.CI) - 1, 2]
    names(dstudy_res_boot$gcoef) <- c("Est", "2.5%", "97.5%")
    
    dstudy_res_boot$absvar[2] <- dstudy.res.CI[nrow(dstudy.res.CI) - 2, 1]
    dstudy_res_boot$absvar[3] <- dstudy.res.CI[nrow(dstudy.res.CI) - 2, 2]
    names(dstudy_res_boot$absvar) <- c("Est", "2.5%", "97.5%")
    
    dstudy_res_boot$relvar[2] <- dstudy.res.CI[nrow(dstudy.res.CI) - 3, 1]
    dstudy_res_boot$relvar[3] <- dstudy.res.CI[nrow(dstudy.res.CI) - 3, 2]
    names(dstudy_res_boot$relvar) <- c("Est", "2.5%", "97.5%")
    
    dstudy_res_boot$ds.df <-
      cbind(dstudy_res_boot$ds.df, dstudy.res.CI[1:(-4 + nrow(dstudy.res.CI)), ])
    
    # output
    dstudy_res_boot
  })

  
  ### Output dstudy results and bootstrapping  ----------------------------------------
  output$recommModelDStudyResult <- renderPrint({
    if(input$mGtheory == FALSE){
      print.dStudy(dstudyResult())
    }else{
      print(dstudyResult()$VarCov)
      print(paste0("g-coefficients: ", dstudyResult()$gCoef))
    }
  })
  output$dstudyInterpretation <- renderUI({
    result <- dstudyResult()
    if (isTRUE(input$mGtheory)) {
      return(tags$div(
        class = "alert alert-info",
        coefficient_guidance(as.numeric(result$gCoef), "generalizability", language())
      ))
    }
    tagList(
      tags$div(class = "alert alert-info", coefficient_guidance(result$gcoef, "generalizability", language())),
      tags$div(class = "alert alert-info", coefficient_guidance(result$dcoef, "dependability", language())),
      tags$p(translate("relative_absolute"))
    )
  })
  output$recommModelDStudyBootResult <- renderPrint({dstudyResultBootCI()})
  
  ### Output path plot of dstudy ----------------------------------------
  facetLevelsRange <- reactive({input$FacetValueRange})
  
  observeEvent(input$plotDstudyCoef, {
    gstudy_res <- gstudyResult()$gstudy
    
    ###### --- 
    # g coefficient path plot across sample size
    ###### ---
    if (facetLevelsRange() != "") {
      updatedNrange = updatedN() ## assign N for dstudy to updatedNrange
      facetLevels <- tryCatch(
        parse_level_range(facetLevelsRange()),
        error = function(error) validate(need(FALSE, conditionMessage(error)))
      )
      Levels_min = min(facetLevels)
      Levels_max = max(facetLevels)
      Levels_step = if (length(facetLevels) > 1) diff(facetLevels)[1] else NA_real_
      gcoefs = rep(NA, length(facetLevels))
      dcoefs = rep(NA, length(facetLevels))
      
      # loop over each level
      for (i in 1:length(facetLevels)) {
        updatedNrange[selectedFacetForDstudy()] = facetLevels[i]
        dstudy.res <- dstudy(x = gstudy_res, n = updatedNrange, unit = selectedID())
        gcoefs[i] <- dstudy.res[["gcoef"]]
        dcoefs[i] <- dstudy.res[["dcoef"]]
      }
      ###### ---
      # rho: generalizability coefficient
      # Phi: phi coefficient or an index of dependability.
      ###### ---
      DstudyCoefData = data.frame(N = facetLevels, rho = gcoefs, Phi = dcoefs)
      
      output$DstudyCoefPlot <- renderPlot({
        ticks = seq(0, 1, 0.02)
        labels_point = seq(0, 1, 0.1)
        ylabels = rep("", length(ticks))
        for (i in seq(ticks)) {
          if (as.character(ticks[i]) %in% as.character(labels_point)) {
            ylabels[i] = ticks[i]
          }
        }
        ggplot(DstudyCoefData) +
          geom_line(aes(x = N, y = rho), alpha = 0.4) +
          geom_text(aes(x = N, y = rho), label = "rho", parse = TRUE, size = 5) +
          geom_line(aes(x = N, y = Phi), alpha = 0.4) +
          geom_text(aes(x = N, y = Phi), label = "Phi", parse = TRUE, size = 5) +
          labs(x = translate("sample_size"), y = translate("coefficient"),
               title = translate("plot_title", selectedFacetForDstudy(), Levels_min, Levels_max, Levels_step)) +
          scale_y_continuous(breaks = ticks,
                             limits = c(0, 1),
                             expand = c(0, 0),
                             labels = ylabels) +
          theme_classic() +
          theme(
            text = element_text(size = 12),
            axis.text.x = element_text(size = 12),
            axis.text.y = element_text(size = 12)
          )
      })
      
    }
    
  })   
  
  ### button: dstudy results downloads  ----------------------------------------
  ## dstudy results
  output$downloadDstudyResult <- downloadHandler(
    filename = "dstudyResult.csv",
    content = \(file) {
      result <- dstudyResult()
      table <- if (isTRUE(input$mGtheory)) result$VarCov else result$ds.df
      write.csv(table, file, row.names = FALSE)
    }
  )
  ## dstudy results bootstrapping
  output$downloadDstudyBootResult <- downloadHandler(
    filename = paste0("dstudyBootstrapN", input$nboot, "Result.csv"),
    content = \(file) {write.csv(dstudyResultBootCI()$ds.df, file, row.names = FALSE)}
  )

  observeEvent(input$aiPromptTemplate, {
    if (!is.null(input$aiPromptTemplate) && nzchar(input$aiPromptTemplate)) {
      updateTextAreaInput(session, "aiQuestion", value = translate(paste0("ai_prompt_", input$aiPromptTemplate)))
    }
  }, ignoreInit = TRUE)

  output$aiStatus <- renderText(translate(aiStatus()))
  output$aiAnswer <- renderUI({
    tags$pre(
      style = "white-space: pre-wrap; min-height: 360px; background: #fafafa; border: 1px solid #ddd; padding: 14px;",
      if (identical(aiAnswer(), "ai_answer_initial")) translate("ai_answer_initial") else aiAnswer()
    )
  })

  observeEvent(input$askAI, {
    previous_request <- lastAIRequest()
    if (!is.na(previous_request) && difftime(Sys.time(), previous_request, units = "secs") < 3) {
      aiStatus("ai_status_wait")
      return()
    }
    lastAIRequest(Sys.time())
    shinyjs::disable("askAI")
    on.exit(shinyjs::enable("askAI"), add = TRUE)
    aiStatus("ai_status_contacting")
    request_failed <- FALSE
    answer <- tryCatch({
      question <- if (is.null(input$aiQuestion)) "" else trimws(input$aiQuestion)
      has_analysis <- !is.null(input$selectedID) && !is.null(input$selectedOutcome) &&
        !is.null(input$selectedMultipleFacets)
      if (has_analysis) {
        current_data <- datNARemoved()
        current_formula <- tryCatch(gtheoryFormula(), error = function(error) "")
        current_gstudy <- if (isTRUE(input$runGstudyButton >= 1)) {
          tryCatch(gstudyResult(), error = function(error) NULL)
        } else NULL
        current_dstudy <- if (isTRUE(input$runDstudyButton >= 1)) {
          tryCatch(dstudyResult(), error = function(error) NULL)
        } else NULL
        current_context <- build_ai_context(
          data = current_data,
          id = selectedID(),
          outcome = selectedOutcome(),
          facets = selectedFacet(),
          formula_text = current_formula,
          gstudy_result = current_gstudy,
          dstudy_result = current_dstudy
        )
      } else {
        current_context <- paste(
          "Privacy mode: raw response rows are not included.",
          "No analysis has been confirmed yet. Explain concepts generally and tell the user what to configure first.",
          sep = "\n"
        )
      }
      call_nvidia_assistant(question = question, context = current_context)
    }, error = function(error) {
      request_failed <<- TRUE
      translate("ai_error", conditionMessage(error))
    })
    aiAnswer(answer)
    if (request_failed) {
      aiStatus("ai_status_failed")
    } else {
      aiStatus("ai_status_received")
    }
  })


}

# Run the application
shinyApp(ui = ui, server = server)
