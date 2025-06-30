#app indicadores municipais (30-maio-2023, 22:42h)
#TODO modularizar as os cards (03-jun-2023, 1057h)

ui <-
  #abas para as diversas páginas
  tags$html(
  #fluidPage(
   #theme = bslib::bs_theme(version = 5), #incorporando o Bootstrap5
         tags$head(
         tags$title("Using MDB Template"),
         HTML('<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">'),
         tags$meta(charset="utf-8")
      ),  #head
   
  tags$body(
  tags$header(    
   tags$nav( class = "navbar navbar-expand-lg navbar-light bg-light fixed-top",
        HTML('<div class="container-fluid">
    <a class="navbar-brand" href="#">
      <img
          src="https://mdbcdn.b-cdn.net/img/logo/mdb-transaprent-noshadows.webp"
          height="auto"
          alt="MDB Logo"
          loading="lazy"
        />
    </a>
  </div>')    
            )),
   tags$div(style = 'padding: 30px 40px',
   h3('Indicadores municipais'),
   br(),
   fluidRow(
    column(7,        
         my_card(
          tags$div(style = 'display:flex;   justify-content:space-between; padding: 15px;',
          tags$h4('Mapa'), 
          selectInput('indicador_mapa', label = NULL, choices = c('IVS' = 1,'IVS-Infra' = 2,'IVS-CapitalHumano' = 3,'IVS-Renda' = 4, 'IDHM' = 5, 'IDHM-E' = 6, 'IDHM-L' = 7, 'IDHM-R' = 8), selected = 'IVS', multiple = F)), #end div
          tags$div(style = 'padding: 15px;',
            leafletOutput('mapa_municipio') )
          )
           ), #endcolumn
    column(5,
           my_card(
          tags$div(style = 'padding: 15px;',
          DT::DTOutput('tabindicador')
          )        
         
          )) #endcolumn      
        ), #endrow
  
  br(),
   column(12,
          my_card(
          tags$div(style = 'padding: 15px;',
          tags$h5(class = 'card-title','Média do indicador selecionado por faixa de população dos municípios*'), 
           apexchartOutput('outronome', height = '280px', width = '100%'),
          p('*população mensurada pelo Censo 2022 (IBGE).')  
          )
           )), #endcolumn
    
   
   br(),
   fluidRow(
    column(4,        
         my_card(
          withTags(
         div(style = 'float: left; padding: 15px;',
          selectInput('indmunicipio', label = 'Selecionar município', choices = municipiosf$Municipio, selected = 'Florianópolis', multiple = F))), #end div
          tags$div(style = 'padding: 15px;',
            echartsOutput('ind_radar', height = '400px', width = '100%')
          )
           )), #endcolumn
    column(8,
     my_card(tags$div(style = 'padding: 15px;',
      uiOutput('ind_texto1'),
      br(),
      accordion_menu(
               accordion_item('tab0', 'População',
                              tableOutput('tab_populacao')),
               accordion_item('tab1', 'Renda/Pobreza',
                              tableOutput('tab_renda')),
               accordion_item('tab2', 'Trabalho/Desemprego',
                              tableOutput('tab_trabalho')),
               accordion_item('tab3', 'Domicílio',
                              tableOutput('tab_domicilio')),
               accordion_item('tab4', 'Longevidade',
                              tableOutput('tab_longevidade')),               
               accordion_item('tab5', 'Escolaridade',
                              tableOutput('tab_escola'))
                              )#end accordion menu
     
      
           )))    
        ), #endrow 
  hr(),
  tags$h4('Comparativo entre municípios'), 
  fluidRow(
    column(4,        
         my_card(
          
         tags$div(style = 'display:flex;   justify-content:space-between; padding: 15px;',
          selectInput('indmunicipio2', label = 'Selecionar município', choices = municipiosf$Municipio, selected = c('Florianópolis', 'Joinville'), multiple = T, width = '22rem'),
          selectInput('ind_ano', label = 'Ano', choices = c(2000,2010), selected = 2010, multiple = F, width = '8rem')
          ), #end div
          tags$div(style = 'padding: 15px;',
            echartsOutput('ind_radar2', height = '400px', width = '100%')
          )
           )), #endcolumn
    column(5,
     
     my_card(
        tags$div(class = 'card-header',style = 'display:flex;   justify-content:space-between;',
                 h5('Série de PIB/Valor Adicionado*') ,
                 selectInput('variavell', label = NULL,
                  choices =  c('Agropecuária', 'Indústria', 'Serviços', 'Adm. Pública', 'Impostos','PIB'),#itens_serie, 
                  selected = 'PIB', multiple = F)
                ),
         tags$div(style = 'padding: 15px;',
         apexchartOutput('area', height = '380px', width = '100%'),
         br(),br(),
          p('*a preços constantes de 2022, deflacionado pelo IPCA.')
          ))),
          
   column(3,
         uiOutput('card1'),
         uiOutput('card2'),
         uiOutput('card3'),
         p('*Ano de 2020'),
         p('**Considerando população de 2022.'))       
        ), #endrow  
   br()
   )# enddiv padding
   ) #endbody
    )#fluidPage
 