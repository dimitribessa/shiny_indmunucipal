 #usando apexchart (26-set-22, 01-24h)
 #deixando aberta alternativas de uso entre diversos tipos (30-maio-2021)
# To be called from ui.R
 apexchartOutput <- function(inputId, width="100%", height="100%") { #
  style <- sprintf("width: %s; height: %s;",
    validateCssUnit(width), validateCssUnit(height))
  
  tagList(
    # Include CSS/JS dependencies. Use "singleton" to make sure that even
    # if multiple lineChartOutputs are used in the same page, we'll still
    # only include these chunks once.
    singleton(tags$head(
    
      tags$script(src="https://cdn.jsdelivr.net/npm/apexcharts"),
      tags$script(src = './JS/apex_general.js')
    )),
    div(id=inputId, class="apexchart", style = style,
    #tag("svg", list())
    )
  )
 }
 
 # To be called from server.R
 renderApex <- function(expr, env=parent.frame(), quoted=FALSE) {
  # This piece of boilerplate converts the expression `expr` into a
  # function called `func`. It's needed for the RStudio IDE's built-in
  # debugger to work properly on the expression.
  installExprFunction(expr, "func", env, quoted)
  
  function() {
    dataframe <- func()
     dataframe
  }
   
 }
 

 #add em 03-fev-2023 (16:03h)
 apexchartbarOutput <- function(inputId, width="100%", height="100%") { #
  style <- sprintf("width: %s; height: %s;",
    validateCssUnit(width), validateCssUnit(height))
  
  tagList(
    # Include CSS/JS dependencies. Use "singleton" to make sure that even
    # if multiple lineChartOutputs are used in the same page, we'll still
    # only include these chunks once.
    singleton(tags$head(
    
      tags$script(src="https://cdn.jsdelivr.net/npm/apexcharts"),
      tags$script(src = './JS/apex_bar.js')
    )),
    div(id=inputId, class="apexbar", style = style,
    #tag("svg", list())
    )
  )
 }