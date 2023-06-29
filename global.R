 #app indicadores municípios (30-maio-2023, 15:08h)
  #carregando os pacotes...
 library('shiny')
 library('shinydashboard')
 library('shinydashboardPlus')
 library('shinyWidgets')
 #library('plotly')
 library('leaflet')
 library('leaflet.extras')
 #library('leaflet.extras2')
 #library('bs4Dash')
 library('htmltools')
 #library('bslib')

 library('dplyr')        #manipulação de dados - tydiverse
 library('stringr')      #funções de string  - tydiverse
 library('rgeos') #leitura de mapas
 library('rgdal') #leitra de mapas
 library('sf') #plot maps
 library('magrittr')     #para mudar nome de colunas
 library('reshape2')
 library('data.table')
 library('RColorBrewer')
 #library('scales')
 library('raster')
 #library('xts')
 #library('dygraphs')
 #library('highcharter')
 #library('ggplot2')
 #library('reactable') #tabelas personalizadas
 #library('kable')
 library('kableExtra')
 
# Any code in this file is guaranteed to be called before either
# ui.R or server.R

 #lendo os dados
 load('dados.RData')
 load('municipiopoly.RData')
 load('municipios_br.RData')
 load('municipiosf.RData')

 source('./functions_layout.R', local = T, encoding = 'UTF-8')
 source('./treating_data.R', local = T, encoding = 'UTF-8')
 options(warn = -1)
 
 #gráficos JS
 source('./www/apexchart/general_apex.R')
 source('./www/echarts/general_echarts.R')