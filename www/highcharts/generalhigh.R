 #usando highchart (16-dez-2019, 15:28h)
 #deixando aberta alternativas de uso entre diversos tipos (30-maio-2021)
# To be called from ui.R
 generalhighOutput <- function(inputId, width="100%", height="100%") {
  style <- sprintf("width: %s; height: %s;",
    validateCssUnit(width), validateCssUnit(height))
  
  tagList(
    # Include CSS/JS dependencies. Use "singleton" to make sure that even
    # if multiple lineChartOutputs are used in the same page, we'll still
    # only include these chunks once.
    singleton(tags$head(
     tags$script( src="https://code.highcharts.com/highcharts.js"),
     tags$script( src="https://code.highcharts.com/highcharts-more.js"),
     tags$script( src="https://code.highcharts.com/modules/exporting.js"),
     tags$script( src="https://code.highcharts.com/modules/export-data.js"),
     tags$script( src="https://code.highcharts.com/modules/accessibility.js"),
     HTML('<script src="https://code.highcharts.com/modules/boost.js"></script>'),
      tags$script(src="./JS/generalhigh.js")
    )),
    div(id=inputId, class="generalhigh", style=style,
      tag("svg", list())
    )
  )
 }
 
 # To be called from server.R
 renderHigh <- function(expr, env=parent.frame(), quoted=FALSE) {
  # This piece of boilerplate converts the expression `expr` into a
  # function called `func`. It's needed for the RStudio IDE's built-in
  # debugger to work properly on the expression.
  installExprFunction(expr, "func", env, quoted)
  
  function() {
    dataframe <- func()
     dataframe
  }
   
 }
 
