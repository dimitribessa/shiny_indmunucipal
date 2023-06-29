 #funções layout
 
 mdb_cdn <- "https://cdnjs.cloudflare.com/ajax/libs/"
 mdb_card_dep <- function() {
  htmlDependency(
    name = "mdb-card",
    version = "1.0",
    src = c(href = mdb_cdn),
    stylesheet = "mdb-ui-kit/6.3.1/mdb.min.css"
    )}
    
    
 # Bootstrap 5 dependencies
 bs5_deps <- function(){htmlDependency(
  name = "Bootstrap",
  version = "5.2",
  src = c(href = "https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/"),
  script = list("js/bootstrap.bundle.min.js"),
  stylesheet = "css/bootstrap.min.css"
)   
 }
 
 my_card <- function(..., size = NULL) {
  
  tagList(
    tags$div(
      class = "card", style = paste('height: ',size),
      ...), mdb_card_dep())
  
}

#' acordion

 accordion_menu <- function(..., inputId = NULL) {
  tags$div(id = inputId, class = "accordion", 
    ...
    )
 }
 
 accordion_item <- function(id, botao, texto) {
   tag <- withTags(
   div(class = 'accordion-item',
    tags$h2(class = 'accordion-header', 
      button(
        class="accordion-button collapsed",
        type="button",
        `data-bs-toggle` ="collapse",
        `data-bs-target` = paste0('#',id),
        `aria-expanded` = "false",
        `aria-controls` = id,
       botao)
       ),
    div(id = id,  class="accordion-collapse collapse",  
        div(class = 'accordion-body',
            texto
            )
        )
    ))
    tagList(tag, bs5_deps())
   
    }
    
 #box cards (07-jun-2023, 13:21h)
 
 box_card <- function(titulo,  i, numero, texto = NULL, texto_num = NULL){
                 tagList(
                    div(class = 'card', style = 'border: none;
    margin-bottom: 30px; border-radius: 5px; color:#fff; background: linear-gradient(45deg,#4099ff,#73b4ff); transition: all 0.3s ease-in-out;',
                        div(style = 'padding: 25px;',
                             h6(class = 'm-b-20', titulo),
                             h2(style = 'text-align: right;', 
                                tags$i(class = i, style = 'float: left; fontsize: 26px;'),
                                span(numero)),
                             if(!is.null(texto)){
                                p(class = 'm-b-0', texto, 
                                      span(style = 'float: right;', texto_num)
                                )}
                             ))      
                          
                          )     
                      }
 

    
 