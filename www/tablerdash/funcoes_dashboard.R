 #lista de função do Admlite (31-jul-2019, 14:43h)
 #atualizado em 29-set-2022 (15:38h) - Tablerdash!
 
  #adicionando as dependências
  tablers_deps <- htmlDependency(
  name = "tabler",
  version = "1.0.7", # we take that of tabler,
  src = c(href = "https://cdn.jsdelivr.net/npm/@tabler/core@latest/dist/"),
  script =  list("js/tabler.min.js", "js/tabler.esm.min.js","js/demo.min.js", 'js/demo-theme.min.js'),
  stylesheet = "css/tabler.min.css"
)

# Bootstrap 4 dependencies
bs4_deps <- htmlDependency(
  name = "Bootstrap",
  version = "4.3.1",
  src = c(href = "https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/"),
  script = "bootstrap.bundle.min.js"
)

jquery_dep <- 
  htmltools::htmlDependency(
    name = "jquery",
    version = "3.6.0",
    src = c(href = "https://code.jquery.com/"),
    script = "jquery-3.6.0.min.js"
  )

 #add em 15-nov-2022
 #necessário para o dropdownmenu funcionar de acordo com o index.html

 

#' Create Tabler dependencies

add_tabler_deps <- function(tag) {
  # below, the order is of critical importance!
  deps <- list(bs4_deps, tablers_deps, jquery_dep)
  attachDependencies(tag, deps,  append = TRUE)
}
 
 #página e corpo tabler
 tabler_page <- function(..., dark = TRUE, title = NULL, favicon = NULL){

  # head
  head_tag <- tags$head(
    tags$meta(charset = "utf-8"),
    tags$meta(
      name = "viewport",
      content = "
        width=device-width,
        initial-scale=1,
        viewport-fit=cover"
    ),
    tags$meta(`http-equiv` = "X-UA-Compatible", content = "ie=edge"),
    tags$title(title),
    tags$link(
      rel = "preconnect",
      href = "https://fonts.gstatic.com/",
      crossorigin = NA
    ),
    tags$meta(name = "msapplication-TileColor", content = "#206bc4"),
    tags$meta(name = "theme-color", content = "#206bc4"),
    tags$meta(name = "apple-mobile-web-app-status-bar-style", content = "black-translucent"),
    tags$meta(name = "apple-mobile-web-app-capable", content = "yes"),
    tags$meta(name = "mobile-web-app-capable", content = "yes"),
    tags$meta(name = "HandheldFriendly", content = "True"),
    tags$meta(name = "MobileOptimized", content = "320"),
    tags$meta(name = "robots", content = "noindex,nofollow,noarchive"),
    tags$link(rel = "icon", href = favicon, type = "image/x-icon"),
    tags$link(rel = "shortcut icon", href = favicon, type="image/x-icon"),
    tags$script(HTML("$(function() {
  // this makes sure to trigger the show event on 
  // the active tab at start
  let activeTab = $('#navbar-menu .nav-link.active');
  // if multiple items are found
  if (activeTab.length > 0) {
    let tabId = $(activeTab).attr('data-value');
    $(activeTab).tab('show');
    $(`#${tabId}`).addClass('show active');
  } else {
    $('#navbar-menu .nav-link')
      .first()
      .tab('show');
  }
});"))
  )
  
  # body
  body_tag <- tags$body(
    tags$div(
      class = paste0("antialiased ", if(dark) "theme-dark"),
      #style = "display: block;",
      tags$div(class = "page", ...)
    )
  ) %>% add_tabler_deps()

  tagList(head_tag, body_tag)
}

 #body
tabler_body <- function(...,classe = 'content', footer = NULL) {
  div(
    class = classe,
    div(class = "container-xl", ...),
    tags$footer(class = "footer footer-transparent", footer)
  )
}

tabler_footer <- function(left = NULL, right = NULL) {
  div(
    class = "container",
    div(
      class = "row text-center align-items-center flex-row-reverse",
      div(class = "col-lg-auto ml-lg-auto", right),
      div(class = "col-12 col-lg-auto mt-3 mt-lg-0", left)
    )
  )
}

 #header
 header_tabler <- function(...,link = '.', logo = NULL){
                     tags$header(class="navbar navbar-expand-md navbar-light d-print-none",
                       tags$div( class = 'container-xl',
                        htmltools::tags$button(
                        class = "navbar-toggler",
                        type = "button",
                        `data-bs-toggle` = "collapse",
                        `data-bs-target` = "#navbar-header",
                        htmltools::tags$span(class = "navbar-toggler-icon")
                        ),
                        htmltools::tags$h1(
                        class = "navbar-brand navbar-brand-autodark d-none-navbar-horizontal pe-0 pe-md-3",
                        htmltools::tags$a(
                        href = link,
                        logo
                        )
      ), ... ))      
                           }
                           
                           

 #navbar (exditado em 05-out-22)
 tabler_navbar <- function(..., brand_url = NULL, brand_image = NULL, nav_menu, nav_right = NULL) {

  header_tag <- tags$div(class = "navbar-expand-md")#tags$header(class = "navbar navbar-expand-md")
  container_tag <- tags$div(class = "container-xl")

  # toggler for small devices (must not be removed)
  toggler_tag <- tags$button(
    class = "navbar-toggler",
    type = "button",
    `data-toggle` = "collapse",
    `data-target` = "#navbar-menu",
    span(class = "navbar-toggler-icon")
  )

  # brand elements
  brand_tag <- if (!is.null(brand_url) || !is.null(brand_image)) {
    a(
      href = if (!is.null(brand_url)) {
        brand_url
      } else {
        "#"
      },
      class = 'navbar navbar-light',#"navbar-brand navbar-brand-autodark d-none-navbar-horizontal pr-0 pr-md-3",
      if(!is.null(brand_image)) {
        img(
          src = brand_image,
          alt = "brand Image",
          class = "navbar-brand-image"
        )
      }
    )
  }

  dropdown_tag <- if (!is.null(nav_right)) {
    div(class = "navbar-nav flex-row order-md-last", nav_right)
  }

  navmenu_tag <- div(
    class = "collapse navbar-collapse",
    id = "navbar-menu",
   # div(
    #  class = "d-flex flex-column flex-md-row flex-fill align-items-stretch align-items-md-center",
      nav_menu,
    #),
    if (length(list(...)) > 0) {
      div(
        class = "ml-md-auto pl-md-4 py-2 py-md-0 mr-md-4 order-first order-md-last flex-grow-1 flex-md-grow-0",
        ...
      )
    }
  )

  container_tag <- container_tag %>% tagAppendChildren(
    toggler_tag,
    brand_tag,
    dropdown_tag,
    navmenu_tag
  )

  subheader_tag <- tags$div(class = 'navbar navbar-light')

  container_tag <- subheader_tag   %>% tagAppendChild(container_tag)

  header_tag %>% tagAppendChild(container_tag)

}

 

#' Create the Tabler navbar menu

 tabler_navbar_menu <- function(..., inputId = NULL) {
  #tags$ul(id = inputId, class = "nav nav-pills navbar-nav", ...)
  tags$ul(id = inputId, class = "nav navbar-nav shiny-tab-input", ...,
    tags$script(
      HTML(
        "$( document ).ready(function() { $('.navbar-nav>li>a').on('click', function(){$('.navbar-collapse').collapse('hide');});});"
      )
    )
  )
 }
 
 tabler_navbar_menu_item <- function(text, tabName, icon = NULL, selected = FALSE) {

  item_cl <- paste0("nav-link", if(selected) " active")

  tags$li(
    class = "nav-item",
    a(
      class = item_cl,
      `data-toggle` = "pill", # see https://getbootstrap.com/docs/4.0/components/navs/
      `data-target` = paste0("#", tabName),
      `data-value` = tabName,
      href = paste0("#", tabName),
      role = "tab",
      `aria-controls` = tabName,
      span(class = "nav-link-icon d-md-none d-lg-inline-block", icon),
      span(class = "nav-link-title", text)
    )
  )
} 

 tabler_tab_items <- function(...) {
  div(class = "tab-content", ...)
}

 tabler_tab_item <- function(tabName = NULL, ...) {
  div(
    role = "tabpanel",
    class = "tab-pane fade container-fluid",
    id = tabName,
    ...
  )
}


 #page heading
 page_heading <- function(pretitle = "Page pretitle", title = "Page title", ...) {
  tags$div(
    class = "container-xl",
    tags$div(
      class = "page-header d-print-none",
      tags$div(
        class = "row align-items-center",
        tags$div(
          class = "col",
          tags$div(
            class = "page-pretitle",
            pretitle
          ),
          tags$h2(
            class = "page-title",
            title
          )
        ),
        ...
      )
    )
  )
}

 #customizando itens

 #progress bar (12-dez-2022, 15:44)
 func_progress_bar <- function(x, hidden = T){
                          val_perc <- paste0(x,"%")
                          val_string <- as.character(x)
                         tagList(
                          div(class = 'progress progress-sm',
                           div(class = "progress-bar bg-primary", 
                                       style = paste('width:',val_perc),
                                       role = 'progressbar',
                                       `aria-valuenow` = val_string,
                                       `aria-valuemin` = '0',
                                       `aria-valuemax` = '100',
                                       `aria-label` = val_perc,
                                     if(hidden == T){span(class="visually-hidden", val_perc)}else{
                                     span(val_perc)} 
                               )
                             )
                           )
                           } #end function
 