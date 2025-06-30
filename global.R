 #app indicadores municípios (30-maio-2023, 15:08h)
  #carregando os pacotes...
 library('shiny')
 #library('shinydashboard')
 #library('shinydashboardPlus')
 library('shinyWidgets')
 library('leaflet')
 library('leaflet.extras')
 library('htmltools')
 
 library('dplyr')        #manipulação de dados - tydiverse
 library('stringr')      #funções de string  - tydiverse
 library('sf') #plot maps
 library('magrittr')     #para mudar nome de colunas
 library('reshape2')
 library('data.table')
 library('RColorBrewer')
 library('kableExtra')
 
# ui.R or server.R

 #reading data
 load('./data/dados.RData')
 load('./data/municipiopoly.RData')
 load('./data/municipios_br.RData')
 load('./data/municipiosf.RData')

 #loading mdb features
 source('www/mdb/functions_layout.R',  encoding = 'UTF-8')
 
 source('./treating_data.R', local = T, encoding = 'UTF-8')
 options(warn = -1)
 
 #JS graphs libraries
 source('./www/apexchart/general_apex.R')
 source('./www/echarts/general_echarts.R')