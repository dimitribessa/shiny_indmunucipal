 #cards
 
 mod_summary_card_ui <- function(id, div_class = "col-md-3", card_style = "min-height: 8rem"){
  ns <- NS(id)

  tags$div(
    class = div_class,
    tags$div(
      class = "card",
      style = card_style,
      uiOutput(ns("o"))
    )
  )
}

 
 mod_summary_card_server <- function(id,arg_ui){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

   output$o <- renderUI({
    arg_ui
    })
 
 })
  } #end mod_summary_card_server
 summary_card_content <- function(id = "",
                         heading = "Card heading",
                         subheader = "Card subheader",
                         annotation = NULL,
                         top_right_element = NULL,
                         in_body = NULL,
                         off_body = NULL,
                         card_class = ""){
    tagList(
      tags$div(
        class = "card-body pb-0",
        tags$div(
          class = "d-flex align-items-center",
          tags$div(
            class = "font-weight-medium",
            subheader
          ),
          tags$div(
            class = "ms-auto lh-1 text-muted small",
            top_right_element
          )
        ),
        tags$div(
          class = "d-flex align-items-center",
          tags$div(
            class = "h1 mb-0",
            heading
          ),
          tags$div(
            class = "me-auto",
            annotation
          )
        ),
        tags$div(
          class = "in-body",
          in_body
        )
      ),
      tags$div(
        class = 'off-body',
        off_body
      )
    )
}

 #Card maior (add em 05-out-22, 10?22h)
  card_large <- function(heading = "Título", ...){
    tagList(
      tags$div(
        class = "card-body",
        tags$h1(
          class = "card-title", heading),
          ...
    ) #end div
    )#end tablist
}
 
 #----------------------------------------------------------------------------
 
 #input reduzido nos cards  (add em 16-nov-2022)
 funcao_input <- function(idInput, choices, selected){
                        tagList(
                         singleton(
                         tags$head(
                         tags$script(
                         src = "JS/binding.js"
                         )
                         )),
                         tags$select(id = idInput,  class = 'customizado', style = 'border:0px;
   outline:0px;scroll-behavior: smooth;',
                          tagList(
                          lapply(choices, function(x){
                               if(x == selected){HTML(paste0('<option selected>',x,'</option>'))}
                               tags$option(x)  
                                 })   
                                 )
                                )
                          ) #end tagList
                          }   

unit_annotation <- function(unit = NULL){
  div(
    class = "text-muted mb-1",
    unit
  )
}

trend_annotation_summary_card <- function(magnitude = "0%", direction = c("none", "up","down")){

  icon <- trend_icon(direction, style = "trend")
  colour_class <- trend_color(direction)$text

  tags$span(
    class = paste(colour_class,"ms-2 d-inline-flex align-items-center font-weight-medium lh-1"),
    magnitude,
    icon
  )
}

trend_icon <- function(direction = c("none", "up","down"), style = c("trend", "arrow")){
  if (style == "trend") {
    switch(
      direction[1],
      "none" = icon_trend_none(),
      "up" = icon_trend_up(),
      "down" = icon_trend_down(),
      NULL
    )
  } else {
    switch(
      direction[1],
      "none" = icon_trend_none(),
      "up" = icon_arrow_up(),
      "down" = icon_arrow_down(),
      NULL
    )
  }

}

trend_color <- function(direction = c("none", "up","down")){
  list(
    text = switch(
      direction[1],
      "none" = "text-yellow",
      "up" = "text-green",
      "down" = "text-red",
      "text-muted"
    ),
    background = switch(
      direction[1],
      "none" = "bg-yellow-lt",
      "up" = "bg-green-lt",
      "down" = "bg-red-lt",
      "bg-secondary-lt"
    )
  )

}
