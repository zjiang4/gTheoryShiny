i18n_translations <- list(
  en = list(
    language = "Language",
    tutorial = "Tutorial",
    data_input = "Data Input",
    data_structure = "Data Structure",
    data_analysis = "Data Analysis",
    ai_assistant = "AI Assistant",
    tutorial_title = "gTheoryShiny Tutorial",
    input_data_file = "Input data file",
    uploaded_data = "Uploaded data",
    example_data = "Example data",
    data_source_help = "Start with an example dataset, or switch on Uploaded data to choose a CSV file.",
    example_data_label = "Example data:",
    upload = "Upload...",
    heading = "Heading",
    long_format = "Long format",
    pivot_heading = "Pivot data from wide to long:",
    transform = "Transform",
    confirm = "Confirm",
    data = "Data",
    raw = "Raw",
    transformed = "Transformed",
    download = "Download",
    facet_levels = "Levels of Facets",
    missing_method = "4. Missing method:",
    formula = "Formula",
    structure_table = "Structure table",
    summary_table = "Summary table",
    structure_footer = "Formula = recommended mixed-effects model; Structure table = auto-detected nesting; Summary table = sample size at each facet level.",
    control_panel = "Control Panel",
    custom_formula = "1. User-specified formula:",
    custom_formula_placeholder = "Default: recommended formula",
    link_function = "2. Link function:",
    bootstrap_number = "3. Number of bootstrap samples for G-study and D-study",
    gstudy_estimation = "G-study Estimation",
    run_gstudy = "Run G-study",
    run_bootstrap = "Run Bootstrap",
    bootstrap_gstudy = "Bootstrapping G-study",
    dstudy_estimation = "D-study Estimation",
    run_dstudy = "Run D-study",
    add_facet_levels = "Apply facet levels",
    run = "Run",
    visualize = "Visualize",
    gstudy_result = "G-study Result",
    fixed_effects_output = "Fixed Effects Output",
    random_effects_output = "Random Effects Output",
    other_output = "Other Output",
    what_this_means = "What this means",
    factor_score_table = "Factor Score Table",
    gstudy_bootstrap_result = "G-study Bootstrap Confidence Intervals",
    bootstrap_result = "Bootstrap Result",
    dstudy_result = "D-study Result",
    dstudy_sample_size = "D-study sample sizes",
    download_dstudy = "Download D-study result",
    dstudy_bootstrap_result = "D-study Bootstrap Confidence Intervals",
    download_bootstrap = "Download bootstrap result",
    coefficient_plot = "D-study coefficient path",
    ask_about_analysis = "Ask about your analysis",
    suggested_question = "Suggested question",
    prompt_start = "Choose a starting point",
    prompt_explain = "Explain my G-study results in plain language",
    prompt_improve = "Help me improve reliability",
    prompt_check = "Check the analysis setup",
    your_question = "Your question",
    question_placeholder = "For example: What does a dependability coefficient of 0.72 mean?",
    ask_ai = "Ask AI",
    privacy_notice = "Privacy protection: only variable names, sample sizes, the model formula, and aggregate results are sent. Raw response rows are never sent.",
    assistant_response = "Assistant response",
    facet_rows = "Select the number of rows containing facets (not including headings)",
    facet_prefix = "Enter facet-level prefixes separated by commas (for example, O,I)",
    facet_names = "Enter facet names separated by commas (for example, Occasion,Item)",
    id_variable = "1. ID variable:",
    outcome_variable = "2. Outcome variable:",
    facets = "3. Facet(s):",
    covariates = "(Optional) Select covariate(s):",
    multivariate = "Experimental: multivariate G-theory",
    multivariate_help = "Use only when one selected facet defines multiple fixed outcomes. Review the covariance model and diagnostics carefully.",
    fixed_facet = "5. Select fixed facet:",
    fixed_weights = "6. Fixed-facet weights (semicolon separated):",
    covariance_facets = "6. Select facet(s) with covariances to estimate:",
    cores = "4. Number of bootstrap processor cores:",
    select_facet = "Select facet:",
    number_conditions = "Enter number of conditions:",
    condition_range = "(Optional) Enter a condition range:",
    condition_range_placeholder = "100:200:10 means from 100 to 200 in steps of 10",
    missing_omit = "Remove rows with missing values (default)",
    missing_zero = "Replace missing values with zero",
    missing_mean = "Replace missing values with the mean",
    missing_median = "Replace missing values with the median",
    link_identity = "Identity (continuous outcome)",
    link_logit = "Logit (binary 0/1 outcome)",
    link_poisson = "Poisson (count outcome)",
    link_inverse_gamma = "Inverse gamma (positive outcome)",
    ai_prompt_explain = "Explain my G-study results in plain language and identify the largest sources of error.",
    ai_prompt_improve = "How should I change the D-study design to improve reliability efficiently?",
    ai_prompt_check = "Check whether the selected ID, facets, model, and interpretation look appropriate.",
    ai_answer_initial = "Run or configure an analysis, then ask a question here.",
    ai_status_configured = "AI service is configured.",
    ai_status_unconfigured = "AI service is not configured. Set NVIDIA_API_KEY on the server.",
    ai_status_wait = "Please wait a few seconds before sending another request.",
    ai_status_contacting = "Contacting the AI service...",
    ai_status_failed = "The request failed. Check the message below and server configuration.",
    ai_status_received = "Answer received. Raw response rows were not sent.",
    ai_error = "AI assistant error: %s",
    report_id = "ID",
    report_outcome = "Outcome",
    report_fixed = "Fixed facet",
    report_covariance = "Random facets with estimated covariances",
    report_variance = "Random facets with variances only",
    largest_variance = "The largest estimated non-person variance source is %s.",
    omitted_terms = "Non-estimable random terms were omitted because they had no replication: %s.",
    singular_warning = "The model has a singular fit. One or more variance components are near zero or cannot be separated well with this dataset; simplify the design or collect more replication before making strong decisions.",
    no_singular = "No singular-fit warning was detected.",
    convergence_warning = "Model convergence warning: %s Review the design, coding, and replication before interpreting small components.",
    use_dstudy = "Use the D-study to evaluate how changing the number of facet conditions affects reliability.",
    relative_absolute = "Relative decisions compare people with one another; absolute decisions compare scores with a fixed standard or cut score.",
    coefficient_unavailable = "The %s could not be estimated reliably.",
    coefficient_sentence = "The %s is %.3f, which is %s. Thresholds are guidelines, not universal rules.",
    generalizability_coefficient = "generalizability coefficient",
    dependability_coefficient = "dependability coefficient",
    coeff_very_strong = "very strong for high-stakes individual decisions",
    coeff_strong = "generally strong for many individual-level decisions",
    coeff_adequate = "potentially adequate for lower-stakes or group-level use",
    coeff_low = "low; the measurement design should usually be improved before individual decisions",
    sample_size = "Sample Size",
    coefficient = "Coefficient",
    plot_title = "%s: from %s to %s with step %s",
    variable = "Variable",
    number_levels = "Number of levels",
    facet = "Facet",
    new_conditions = "New conditions",
    observed_conditions = "Observed conditions",
    in_progress = "In progress",
    finished = "Finished",
    run_gstudy_first = "Run a successful G-study first.",
    invalid_facet_levels = "Select a valid facet and enter a positive whole number of conditions.",
    relationship = "Relationship",
    crossed = "Crossed",
    confounded = "Confounded (one-to-one)",
    nested_in = "%s nested in %s",
    sample_size_outcome = "Sample Size (Outcome)"
  ),
  zh = list(
    invalid_facet_levels = "\u8bf7\u9009\u62e9\u6709\u6548\u4fa7\u9762\uff0c\u5e76\u8f93\u5165\u6b63\u6574\u6570\u6761\u4ef6\u6570\u91cf\u3002",
    language = "\u8bed\u8a00",
    tutorial = "\u4f7f\u7528\u6559\u7a0b",
    data_input = "\u6570\u636e\u5bfc\u5165",
    data_structure = "\u6570\u636e\u7ed3\u6784",
    data_analysis = "\u6570\u636e\u5206\u6790",
    ai_assistant = "AI \u52a9\u624b",
    tutorial_title = "gTheoryShiny \u4f7f\u7528\u6559\u7a0b",
    input_data_file = "\u5bfc\u5165\u6570\u636e\u6587\u4ef6",
    uploaded_data = "\u4e0a\u4f20\u6570\u636e",
    example_data = "\u793a\u4f8b\u6570\u636e",
    data_source_help = "\u53ef\u5148\u4f7f\u7528\u793a\u4f8b\u6570\u636e\uff0c\u4e5f\u53ef\u5207\u6362\u5230\u201c\u4e0a\u4f20\u6570\u636e\u201d\u5e76\u9009\u62e9 CSV \u6587\u4ef6\u3002",
    example_data_label = "\u793a\u4f8b\u6570\u636e\uff1a",
    upload = "\u4e0a\u4f20...",
    heading = "\u9996\u884c\u4e3a\u5217\u540d",
    long_format = "\u957f\u683c\u5f0f\u6570\u636e",
    pivot_heading = "\u5c06\u5bbd\u683c\u5f0f\u8f6c\u6362\u4e3a\u957f\u683c\u5f0f\uff1a",
    transform = "\u8f6c\u6362",
    confirm = "\u786e\u8ba4",
    data = "\u6570\u636e",
    raw = "\u539f\u59cb\u6570\u636e",
    transformed = "\u8f6c\u6362\u540e\u6570\u636e",
    download = "\u4e0b\u8f7d",
    facet_levels = "\u6d4b\u91cf\u4fa7\u9762\u6c34\u5e73\u6570",
    missing_method = "4. \u7f3a\u5931\u503c\u5904\u7406\uff1a",
    formula = "\u6a21\u578b\u516c\u5f0f",
    structure_table = "\u7ed3\u6784\u8868",
    summary_table = "\u6c47\u603b\u8868",
    structure_footer = "\u6a21\u578b\u516c\u5f0f = \u63a8\u8350\u7684\u6df7\u5408\u6548\u5e94\u6a21\u578b\uff1b\u7ed3\u6784\u8868 = \u81ea\u52a8\u8bc6\u522b\u7684\u5d4c\u5957\u5173\u7cfb\uff1b\u6c47\u603b\u8868 = \u5404\u6d4b\u91cf\u4fa7\u9762\u6c34\u5e73\u7684\u6837\u672c\u91cf\u3002",
    control_panel = "\u63a7\u5236\u9762\u677f",
    custom_formula = "1. \u81ea\u5b9a\u4e49\u516c\u5f0f\uff1a",
    custom_formula_placeholder = "\u9ed8\u8ba4\u4f7f\u7528\u63a8\u8350\u516c\u5f0f",
    link_function = "2. \u94fe\u63a5\u51fd\u6570\uff1a",
    bootstrap_number = "3. G \u7814\u7a76\u4e0e D \u7814\u7a76\u7684 Bootstrap \u6b21\u6570",
    gstudy_estimation = "G \u7814\u7a76\u4f30\u8ba1",
    run_gstudy = "\u8fd0\u884c G \u7814\u7a76",
    run_bootstrap = "\u8fd0\u884c Bootstrap",
    bootstrap_gstudy = "\u6b63\u5728\u5bf9 G \u7814\u7a76\u8fdb\u884c Bootstrap",
    dstudy_estimation = "D \u7814\u7a76\u4f30\u8ba1",
    run_dstudy = "\u8fd0\u884c D \u7814\u7a76",
    add_facet_levels = "\u5e94\u7528\u4fa7\u9762\u6c34\u5e73\u6570",
    run = "\u8fd0\u884c",
    visualize = "\u53ef\u89c6\u5316",
    gstudy_result = "G \u7814\u7a76\u7ed3\u679c",
    fixed_effects_output = "\u56fa\u5b9a\u6548\u5e94\u7ed3\u679c",
    random_effects_output = "\u968f\u673a\u6548\u5e94\u7ed3\u679c",
    other_output = "\u5176\u4ed6\u7ed3\u679c",
    what_this_means = "\u7ed3\u679c\u89e3\u8bfb",
    factor_score_table = "\u5bf9\u8c61\u6548\u5e94\u5f97\u5206\u8868",
    gstudy_bootstrap_result = "G \u7814\u7a76 Bootstrap \u7f6e\u4fe1\u533a\u95f4",
    bootstrap_result = "Bootstrap \u7ed3\u679c",
    dstudy_result = "D \u7814\u7a76\u7ed3\u679c",
    dstudy_sample_size = "D \u7814\u7a76\u6761\u4ef6\u6570",
    download_dstudy = "\u4e0b\u8f7d D \u7814\u7a76\u7ed3\u679c",
    dstudy_bootstrap_result = "D \u7814\u7a76 Bootstrap \u7f6e\u4fe1\u533a\u95f4",
    download_bootstrap = "\u4e0b\u8f7d Bootstrap \u7ed3\u679c",
    coefficient_plot = "D \u7814\u7a76\u7cfb\u6570\u53d8\u5316\u56fe",
    ask_about_analysis = "\u8be2\u95ee\u672c\u6b21\u5206\u6790",
    suggested_question = "\u63a8\u8350\u95ee\u9898",
    prompt_start = "\u9009\u62e9\u4e00\u4e2a\u95ee\u9898",
    prompt_explain = "\u7528\u901a\u4fd7\u8bed\u8a00\u89e3\u91ca G \u7814\u7a76\u7ed3\u679c",
    prompt_improve = "\u5e2e\u52a9\u6211\u63d0\u9ad8\u4fe1\u5ea6",
    prompt_check = "\u68c0\u67e5\u5206\u6790\u8bbe\u7f6e",
    your_question = "\u4f60\u7684\u95ee\u9898",
    question_placeholder = "\u4f8b\u5982\uff1a\u53ef\u4f9d\u8d56\u7cfb\u6570\u4e3a 0.72 \u4ee3\u8868\u4ec0\u4e48\uff1f",
    ask_ai = "\u8be2\u95ee AI",
    privacy_notice = "\u9690\u79c1\u4fdd\u62a4\uff1a\u4ec5\u53d1\u9001\u53d8\u91cf\u540d\u3001\u6837\u672c\u91cf\u3001\u6a21\u578b\u516c\u5f0f\u548c\u6c47\u603b\u7ed3\u679c\uff0c\u7edd\u4e0d\u4f1a\u53d1\u9001\u539f\u59cb\u4f5c\u7b54\u8bb0\u5f55\u3002",
    assistant_response = "AI \u56de\u7b54",
    facet_rows = "\u9009\u62e9\u5305\u542b\u6d4b\u91cf\u4fa7\u9762\u6807\u7b7e\u7684\u884c\u6570\uff08\u4e0d\u5305\u62ec\u5217\u540d\uff09",
    facet_prefix = "\u8f93\u5165\u4fa7\u9762\u6c34\u5e73\u524d\u7f00\uff0c\u7528\u9017\u53f7\u5206\u9694\uff08\u4f8b\u5982 O,I\uff09",
    facet_names = "\u8f93\u5165\u4fa7\u9762\u540d\u79f0\uff0c\u7528\u9017\u53f7\u5206\u9694\uff08\u4f8b\u5982 Occasion,Item\uff09",
    id_variable = "1. \u5bf9\u8c61 ID \u53d8\u91cf\uff1a",
    outcome_variable = "2. \u7ed3\u679c\u53d8\u91cf\uff1a",
    facets = "3. \u6d4b\u91cf\u4fa7\u9762\uff1a",
    covariates = "\uff08\u53ef\u9009\uff09\u9009\u62e9\u534f\u53d8\u91cf\uff1a",
    multivariate = "\u5b9e\u9a8c\u529f\u80fd\uff1a\u591a\u5143\u6982\u5316\u7406\u8bba",
    multivariate_help = "\u4ec5\u5f53\u67d0\u4e2a\u4fa7\u9762\u5b9a\u4e49\u591a\u4e2a\u56fa\u5b9a\u7ed3\u679c\u65f6\u4f7f\u7528\u3002\u8bf7\u4ed4\u7ec6\u68c0\u67e5\u534f\u65b9\u5dee\u6a21\u578b\u548c\u8bca\u65ad\u7ed3\u679c\u3002",
    fixed_facet = "5. \u9009\u62e9\u56fa\u5b9a\u4fa7\u9762\uff1a",
    fixed_weights = "6. \u56fa\u5b9a\u4fa7\u9762\u6743\u91cd\uff08\u7528\u5206\u53f7\u5206\u9694\uff09\uff1a",
    covariance_facets = "6. \u9009\u62e9\u9700\u8981\u4f30\u8ba1\u534f\u65b9\u5dee\u7684\u4fa7\u9762\uff1a",
    cores = "4. Bootstrap \u4f7f\u7528\u7684\u5904\u7406\u5668\u6838\u5fc3\u6570\uff1a",
    select_facet = "\u9009\u62e9\u6d4b\u91cf\u4fa7\u9762\uff1a",
    number_conditions = "\u8f93\u5165\u6761\u4ef6\u6570\u91cf\uff1a",
    condition_range = "\uff08\u53ef\u9009\uff09\u8f93\u5165\u6761\u4ef6\u6570\u91cf\u8303\u56f4\uff1a",
    condition_range_placeholder = "100:200:10 \u8868\u793a\u4ece 100 \u5230 200\uff0c\u6b65\u957f\u4e3a 10",
    missing_omit = "\u5220\u9664\u542b\u7f3a\u5931\u503c\u7684\u8bb0\u5f55\uff08\u9ed8\u8ba4\uff09",
    missing_zero = "\u7528 0 \u586b\u8865\u7f3a\u5931\u503c",
    missing_mean = "\u7528\u5747\u503c\u586b\u8865\u7f3a\u5931\u503c",
    missing_median = "\u7528\u4e2d\u4f4d\u6570\u586b\u8865\u7f3a\u5931\u503c",
    link_identity = "\u6052\u7b49\u94fe\u63a5\uff08\u8fde\u7eed\u7ed3\u679c\uff09",
    link_logit = "Logit\uff080/1 \u4e8c\u5206\u7c7b\u7ed3\u679c\uff09",
    link_poisson = "Poisson\uff08\u8ba1\u6570\u7ed3\u679c\uff09",
    link_inverse_gamma = "\u9006 Gamma\uff08\u6b63\u503c\u7ed3\u679c\uff09",
    ai_prompt_explain = "\u8bf7\u7528\u901a\u4fd7\u8bed\u8a00\u89e3\u91ca\u6211\u7684 G \u7814\u7a76\u7ed3\u679c\uff0c\u5e76\u6307\u51fa\u6700\u5927\u7684\u8bef\u5dee\u6765\u6e90\u3002",
    ai_prompt_improve = "\u5e94\u5982\u4f55\u9ad8\u6548\u8c03\u6574 D \u7814\u7a76\u8bbe\u8ba1\u4ee5\u63d0\u9ad8\u4fe1\u5ea6\uff1f",
    ai_prompt_check = "\u8bf7\u68c0\u67e5\u6240\u9009 ID\u3001\u6d4b\u91cf\u4fa7\u9762\u3001\u6a21\u578b\u548c\u7ed3\u679c\u89e3\u91ca\u662f\u5426\u5408\u9002\u3002",
    ai_answer_initial = "\u8bf7\u5148\u8fd0\u884c\u6216\u914d\u7f6e\u5206\u6790\uff0c\u7136\u540e\u5728\u6b64\u63d0\u95ee\u3002",
    ai_status_configured = "AI \u670d\u52a1\u5df2\u914d\u7f6e\u3002",
    ai_status_unconfigured = "AI \u670d\u52a1\u5c1a\u672a\u914d\u7f6e\uff0c\u8bf7\u5728\u670d\u52a1\u5668\u8bbe\u7f6e NVIDIA_API_KEY\u3002",
    ai_status_wait = "\u8bf7\u7b49\u5f85\u51e0\u79d2\u540e\u518d\u53d1\u9001\u8bf7\u6c42\u3002",
    ai_status_contacting = "\u6b63\u5728\u8fde\u63a5 AI \u670d\u52a1...",
    ai_status_failed = "\u8bf7\u6c42\u5931\u8d25\uff0c\u8bf7\u67e5\u770b\u4e0b\u65b9\u9519\u8bef\u4fe1\u606f\u548c\u670d\u52a1\u5668\u914d\u7f6e\u3002",
    ai_status_received = "\u5df2\u6536\u5230\u56de\u7b54\uff0c\u672a\u53d1\u9001\u4efb\u4f55\u539f\u59cb\u4f5c\u7b54\u8bb0\u5f55\u3002",
    ai_error = "AI \u52a9\u624b\u9519\u8bef\uff1a%s",
    report_id = "\u5bf9\u8c61 ID",
    report_outcome = "\u7ed3\u679c\u53d8\u91cf",
    report_fixed = "\u56fa\u5b9a\u4fa7\u9762",
    report_covariance = "\u4f30\u8ba1\u534f\u65b9\u5dee\u7684\u968f\u673a\u4fa7\u9762",
    report_variance = "\u4ec5\u4f30\u8ba1\u65b9\u5dee\u7684\u968f\u673a\u4fa7\u9762",
    largest_variance = "\u4f30\u8ba1\u503c\u6700\u5927\u7684\u975e\u5bf9\u8c61\u65b9\u5dee\u6765\u6e90\u662f %s\u3002",
    omitted_terms = "\u4ee5\u4e0b\u968f\u673a\u9879\u56e0\u6ca1\u6709\u91cd\u590d\u89c2\u6d4b\u800c\u4e0d\u53ef\u4f30\u8ba1\uff0c\u5df2\u81ea\u52a8\u7701\u7565\uff1a%s\u3002",
    singular_warning = "\u6a21\u578b\u51fa\u73b0\u5947\u5f02\u62df\u5408\uff0c\u4e00\u4e2a\u6216\u591a\u4e2a\u65b9\u5dee\u5206\u91cf\u63a5\u8fd1 0\uff0c\u6216\u73b0\u6709\u6570\u636e\u65e0\u6cd5\u5c06\u5176\u533a\u5206\u3002\u4f5c\u51fa\u91cd\u8981\u51b3\u7b56\u524d\uff0c\u8bf7\u7b80\u5316\u8bbe\u8ba1\u6216\u589e\u52a0\u91cd\u590d\u6d4b\u91cf\u3002",
    no_singular = "\u672a\u68c0\u6d4b\u5230\u5947\u5f02\u62df\u5408\u8b66\u544a\u3002",
    convergence_warning = "\u6a21\u578b\u6536\u655b\u8b66\u544a\uff1a%s \u5728\u89e3\u91ca\u8f83\u5c0f\u7684\u65b9\u5dee\u5206\u91cf\u524d\uff0c\u8bf7\u68c0\u67e5\u8bbe\u8ba1\u3001\u53d8\u91cf\u7f16\u7801\u548c\u91cd\u590d\u6d4b\u91cf\u3002",
    use_dstudy = "\u4f7f\u7528 D \u7814\u7a76\u53ef\u8bc4\u4f30\u6539\u53d8\u5404\u4fa7\u9762\u6761\u4ef6\u6570\u91cf\u540e\u4fe1\u5ea6\u5982\u4f55\u53d8\u5316\u3002",
    relative_absolute = "\u76f8\u5bf9\u51b3\u7b56\u7528\u4e8e\u6bd4\u8f83\u5bf9\u8c61\u4e4b\u95f4\u7684\u5dee\u5f02\uff1b\u7edd\u5bf9\u51b3\u7b56\u7528\u4e8e\u5c06\u5206\u6570\u4e0e\u56fa\u5b9a\u6807\u51c6\u6216\u4e34\u754c\u503c\u6bd4\u8f83\u3002",
    coefficient_unavailable = "%s \u65e0\u6cd5\u53ef\u9760\u4f30\u8ba1\u3002",
    coefficient_sentence = "%s\u4e3a %.3f\uff0c%s\u3002\u9608\u503c\u4ec5\u4f9b\u53c2\u8003\uff0c\u5e76\u975e\u9002\u7528\u4e8e\u6240\u6709\u60c5\u5883\u3002",
    generalizability_coefficient = "\u6982\u5316\u7cfb\u6570",
    dependability_coefficient = "\u53ef\u4f9d\u8d56\u7cfb\u6570",
    coeff_very_strong = "\u901a\u5e38\u8db3\u4ee5\u652f\u6301\u9ad8\u98ce\u9669\u7684\u4e2a\u4f53\u51b3\u7b56",
    coeff_strong = "\u901a\u5e38\u53ef\u652f\u6301\u8bb8\u591a\u4e2a\u4f53\u5c42\u9762\u7684\u51b3\u7b56",
    coeff_adequate = "\u53ef\u80fd\u9002\u7528\u4e8e\u8f83\u4f4e\u98ce\u9669\u6216\u7fa4\u4f53\u5c42\u9762\u7684\u7528\u9014",
    coeff_low = "\u504f\u4f4e\uff0c\u901a\u5e38\u5e94\u5148\u6539\u8fdb\u6d4b\u91cf\u8bbe\u8ba1\u518d\u7528\u4e8e\u4e2a\u4f53\u51b3\u7b56",
    sample_size = "\u6761\u4ef6\u6570\u91cf",
    coefficient = "\u7cfb\u6570",
    plot_title = "%s\uff1a\u4ece %s \u5230 %s\uff0c\u6b65\u957f %s",
    variable = "\u53d8\u91cf",
    number_levels = "\u6c34\u5e73\u6570",
    facet = "\u6d4b\u91cf\u4fa7\u9762",
    new_conditions = "\u65b0\u6761\u4ef6\u6570",
    observed_conditions = "\u539f\u6761\u4ef6\u6570",
    in_progress = "\u8fdb\u884c\u4e2d",
    finished = "\u5df2\u5b8c\u6210",
    run_gstudy_first = "\u8bf7\u5148\u6210\u529f\u8fd0\u884c G \u7814\u7a76\u3002",
    relationship = "\u5173\u7cfb",
    crossed = "\u4ea4\u53c9",
    confounded = "\u6df7\u6dc6\uff08\u4e00\u4e00\u5bf9\u5e94\uff09",
    nested_in = "%s \u5d4c\u5957\u4e8e %s",
    sample_size_outcome = "\u7ed3\u679c\u53d8\u91cf\u6837\u672c\u91cf"
  )
)

tr_text <- function(language = "en", key, ...) {
  language <- if (identical(language, "zh")) "zh" else "en"
  value <- i18n_translations[[language]][[key]]
  if (is.null(value)) value <- i18n_translations$en[[key]]
  if (is.null(value)) value <- key
  args <- list(...)
  if (length(args) > 0) do.call(sprintf, c(list(value), args)) else value
}

i18n_tag <- function(key, english = tr_text("en", key), tag = shiny::tags$span) {
  tag(class = "i18n", `data-i18n` = key, english)
}

i18n_placeholder <- function(key, english = tr_text("en", key)) {
  structure(english, i18n_key = key)
}

i18n_head <- function() {
  dictionaries <- jsonlite::toJSON(i18n_translations, auto_unbox = TRUE)
  shiny::tags$script(shiny::HTML(sprintf(
    "(function(){\n\
      const dictionaries = %s;\n\
      const optionKeys = {\n\
        missingMethod: {omit:'missing_omit',zero:'missing_zero',mean:'missing_mean',median:'missing_median'},\n\
        linkFunc: {identity:'link_identity',logit:'link_logit',poisson:'link_poisson','inverse gamma':'link_inverse_gamma'},\n\
        aiPromptTemplate: {'':'prompt_start',explain:'prompt_explain',improve:'prompt_improve',check:'prompt_check'}\n\
      };\n\
      const placeholderKeys = {selfFormular:'custom_formula_placeholder',aiQuestion:'question_placeholder',FacetValueRange:'condition_range_placeholder'};\n\
      let language = 'en';\n\
      let scheduled = false;\n\
      function text(key){ return (dictionaries[language]||dictionaries.en)[key] || dictionaries.en[key] || key; }\n\
      function setOwnText(element, value){\n\
        if(!element) return;\n\
        const node = Array.from(element.childNodes).find(function(n){ return n.nodeType === Node.TEXT_NODE; });\n\
        if(node && node.nodeValue !== value) node.nodeValue = value; else if(!node) element.insertBefore(document.createTextNode(value), element.firstChild);\n\
      }\n\
      function translateOptions(){\n\
        Object.keys(optionKeys).forEach(function(id){\n\
          const select = document.getElementById(id);\n\
          if(!select) return;\n\
          if(select.selectize){\n\
            const widget = select.selectize;\n\
            Object.keys(optionKeys[id]).forEach(function(value){\n\
              const option = widget.options[value];\n\
              const label = text(optionKeys[id][value]);\n\
              if(option && option[widget.settings.labelField] !== label){\n\
                const updated = Object.assign({}, option); updated[widget.settings.labelField] = label;\n\
                widget.updateOption(value, updated);\n\
              }\n\
            });\n\
            if(optionKeys[id]['']){\n\
              const placeholder = text(optionKeys[id]['']);\n\
              if(widget.settings.placeholder !== placeholder){ widget.settings.placeholder = placeholder; widget.updatePlaceholder(); }\n\
            }\n\
            return;\n\
          }\n\
          let changed = false;\n\
          Array.from(select.options).forEach(function(option){\n\
            const key = optionKeys[id][option.value];\n\
            if(key && option.text !== text(key)){ option.text = text(key); changed = true; }\n\
          });\n\
          if(changed && window.jQuery && jQuery(select).data('selectpicker')) jQuery(select).selectpicker('refresh');\n\
        });\n\
      }\n\
      function translateWidgets(){\n\
        const upload = document.getElementById('fileUpload-file');\n\
        if(upload){ setOwnText(upload.closest('.form-group').querySelector('.btn-file'), text('upload')); }\n\
        const sourceSwitch = document.getElementById('fileUploadSwitch');\n\
        if(sourceSwitch){\n\
          const root = sourceSwitch.closest('.bootstrap-switch');\n\
          if(root){ setOwnText(root.querySelector('.bootstrap-switch-handle-on'), text('uploaded_data')); setOwnText(root.querySelector('.bootstrap-switch-handle-off'), text('example_data')); }\n\
        }\n\
      }\n\
      function apply(){\n\
        scheduled = false;\n\
        document.documentElement.lang = language === 'zh' ? 'zh-CN' : 'en';\n\
        document.querySelectorAll('[data-i18n]').forEach(function(el){ const value=text(el.dataset.i18n); if(el.textContent !== value) el.textContent = value; });\n\
        document.querySelectorAll('[data-i18n-placeholder]').forEach(function(el){ const value=text(el.dataset.i18nPlaceholder); if(el.getAttribute('placeholder') !== value) el.setAttribute('placeholder', value); });\n\
        Object.keys(placeholderKeys).forEach(function(id){ const el=document.getElementById(id); const value=text(placeholderKeys[id]); if(el && el.getAttribute('placeholder') !== value) el.setAttribute('placeholder', value); });\n\
        translateOptions(); translateWidgets();\n\
      }\n\
      function schedule(){ if(!scheduled){ scheduled=true; window.requestAnimationFrame(apply); } }\n\
      document.addEventListener('change', function(event){\n\
        if(event.target && event.target.id === 'appLanguage'){ language = event.target.value === 'zh' ? 'zh' : 'en'; schedule(); }\n\
      });\n\
      if(window.jQuery){\n\
        jQuery(document).on('change', '#appLanguage', function(){ language = this.value === 'zh' ? 'zh' : 'en'; schedule(); });\n\
        jQuery(document).on('shiny:inputchanged', function(event){ if(event.name === 'appLanguage'){ language = event.value === 'zh' ? 'zh' : 'en'; schedule(); } });\n\
      }\n\
      function syncLanguage(){\n\
        const select=document.getElementById('appLanguage'); language=select && select.value === 'zh' ? 'zh' : 'en'; schedule();\n\
      }\n\
      if(window.jQuery) jQuery(document).on('shiny:connected shiny:bound', syncLanguage);\n\
      new MutationObserver(schedule).observe(document.documentElement, {childList:true,subtree:true});\n\
      if(document.readyState === 'loading') document.addEventListener('DOMContentLoaded', schedule); else schedule();\n\
    })();", dictionaries
  )))
}
