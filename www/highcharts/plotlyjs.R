 #plotly geral
 plotlyOutput <- function(inputId, width="100%", height="400px") {
  style <- sprintf("width: %s; height: %s;",
    validateCssUnit(width), validateCssUnit(height)) #display: block;
  
 tagList(                                              #
    # Include CSS/JS dependencies. Use "singleton" to make sure that even
    # if multiple lineChartOutputs are used in the same page, we'll still
    # only include these chunks once.
    singleton(tags$head(
         #tags$script(src = 'https://unpkg.com/sunburst-chart@1.11.2/dist/sunburst-chart.min.js'),
         tags$script(src = 'https://cdn.plot.ly/plotly-latest.min.js'),
         #tags$link(rel="stylesheet", type="text/css", href="estilo_dendograma.css"),
         #tags$script(src = "https://d3js.org/d3.v3.min.js"),
         tags$script(src= "./JS/plotlyjs.js")
    )),
    div(id=inputId, class="plotlyjs", style=style  )
    )
 }
 