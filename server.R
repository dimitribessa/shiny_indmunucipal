#indicadores municipais (31-mai-2023, 16:01h)

server <- shinyServer(function(input, output, session) {


 #-----------------------------------------------------------------------------
 #mapa
 
 dado_mapa  <- reactive({
                 input <- input$indicador_mapa
                 if(input %in% 1:4){
                    dadoi <- ivs[,c(4,5,7:11)]
                    if(input == 1){
                    dadoi <- dadoi[,c(3,1:2,4)]}
                    if(input == 2){
                    dadoi <- dadoi[,c(3,1:2,5)]}
                    if(input == 3){
                    dadoi <- dadoi[,c(3,1:2,6)]}
                    if(input == 4){
                    dadoi <- dadoi[,c(3,1:2,7)]}
                    }else{
                    dadoi  <- dadosidh[,c(1,4,5,234:237)]       
                    if(input == 5){
                    dadoi <- dadoi[,c(1:4)]}
                    if(input == 6){
                    dadoi <- dadoi[,c(1:3,5)]}
                    if(input == 7){
                    dadoi <- dadoi[,c(1:3,6)]}
                    if(input == 8){
                    dadoi <- dadoi[,c(1:3,7)]}
                    }
                    dadoi
                        }) 
 
 
  output$mapa_municipio <- renderLeaflet({ leaflet_data()
        })
        
   leaflet_data <- reactive({
                variavel <- c('IVS','IVS-Infra','IVS-CapitalHumano',
                              'IVS-Renda', 'IDHM', 'IDHM-E', 'IDHM-L', 'IDHM-R') %>%
                               .[as.numeric(input$indicador_mapa)]
                
                dadoi <- dado_mapa()
                names(dadoi) <- c('ano','codigo','municipio','indicador')
                municipiosf$codigo <- as.numeric(municipiosf$CD_GEOCMU)
                dadoi[is.na(dadoi$indicador)] <- 0
               
               anos <- unique(dadoi$ano) %>% as.character
               #lista mapas
                mapa_dado <- lapply(split(dadoi, dadoi$ano), function(x){
                                    dplyr::left_join(municipiosf, x[,-3], by = 'codigo')
                                    })



                fill_color <- function(x){
                   bins <- unique(as.vector(quantile(x, probs = c(0,0.30,0.50,0.85,0.95,0.98,1),na.rm = T)))
                   pal <- colorBin("YlOrRd", domain = x, bins = bins)
                   colorData <- pal(x)
                   list(pal, colorData)
                          }


   labell <- function(x){
             mapa_dado <- x
     sprintf(
  "<strong>%s</strong><br/> %s: %s " , #  people / mi<sup>2</sup>",
  mapa_dado$Municipio, variavel, mapa_dado$indicador) %>% lapply(htmltools::HTML)
         }
  
 mapas <-  function(x, ...){
        addPolygons(..., data = x, group = as.character(x$ano[1]), color = "#444444", fillColor =  fill_color(x$indicador)[[2]], 
        stroke = T, smoothFactor = 0.5, fillOpacity = 0.8, weight = 1.5,
    highlight = highlightOptions(
    weight = 5,
    color = "#666",
    fillOpacity = 0.7,
    bringToFront = TRUE),
  label = labell(x),
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "12px",
    maxWidth = '200px',
    direction = "auto")) %>% 
    addLegend(pal = fill_color(x$indicador)[[1]], values = x$indicador ,opacity = 0.7, title = variavel,
  position = "bottomleft", group =  as.character(x$ano[1]), layerId = 'Município')  
   }
 
 #mapa base
 mapa_base  <-  leaflet() %>% 
  addProviderTiles('CartoDB.Positron') %>%
        setView(lat = -27.5, lng = -51, zoom = 7) %>% clearControls() %>% clearShapes() %>%  
   addLayersControl(position = 'topright', baseGroups = anos,
               options = layersControlOptions(collapsed = F))  %>%
  htmlwidgets::onRender("
    function() { 
      var map = this;
      var legends = map.controls._controlsById;
      function addActualLegend() {
         var sel = $('.leaflet-control-layers-base').find('input[type=\"radio\"]:checked').siblings('span').text().trim();
         $.each(map.controls._controlsById, (nm) => map.removeControl(map.controls.get(nm)));
         map.addControl(legends[sel]);
      }
      $('.leaflet-control-layers-base').on('click', addActualLegend);
      addActualLegend();
   }")
  
 if(as.numeric(input$indicador_mapa) %in% 1:4){
  mapa_base %>%  
  mapas(mapa_dado[[1]], map = .) %>% mapas(mapa_dado[[2]], map = .)}else{
  mapa_base %>%
  mapas(mapa_dado[[1]], map = .) %>%
  mapas(mapa_dado[[2]], map = .) %>% 
  mapas(mapa_dado[[3]], map = .)  }
   
     })#end leaflet_data 
 
 #-----------------------------------------------------------------------------
 #tabelas
 
 #indicador1
 
  tab_indicador1 <- reactive({
                                  dadoi <- dado_mapa() 
                                  names(dadoi) <- c('ano','codigo','Município','indicador')
                                  #dadoi[is.na(dadoi$indicador)] <- 0
                                  dadoi <- tidyr::spread(dadoi[,-2], key = ano, value = indicador)
                                  
                                  if(as.numeric(input$indicador_mapa) <= 4){
                                  dadoi$`Var %` <- with(dadoi, round((`2010` - `2000`)*100/`2000`,2))
                                  }else{
                                  dadoi$`Var 91-00` <- with(dadoi, round((`2000` - `1991`)*100/`1991`,2))
                                  dadoi$`Var 00-10` <- with(dadoi, round((`2010` - `2000`)*100/`2000`,2))
                                  }
                                  dadoi
                                  })
 
  output$tabindicador <- DT::renderDT({tab_indicador1()})
  
  
 
 
 
 #-----------------------------------------------------------------------------
 #gráficos
 
 dado_municipio <- reactive({
                     municipio <- with(municipios_br, municipios_br[uf == 'Santa Catarina' & municipio == input$indmunicipio, 'codigo'])
                    dadoiivs <- ivs[which(ivs$Município == municipio), c(7:11)]
                    dadoiidh <- dadosidh[which(dadosidh$Codmun7 == municipio), c(1,234:237)]
                    dplyr::full_join(dadoiivs, dadoiidh, by = c('Ano' = 'ANO'))
                    })

 #múltiplos municípios 
 dado_municipio2 <- reactive({
                     municipio <- with(municipios_br, municipios_br[which((uf == 'Santa Catarina') & (municipio %in% input$indmunicipio2)), 'codigo'])
                    dadoiivs <- ivs[which((ivs$Município %in% municipio) & ivs$Ano == input$ind_ano), c(4,8:11)]
                    dadoiidh <- dadosidh[which(dadosidh$Codmun7 %in% municipio & dadosidh$ANO == input$ind_ano), c(4,234:237)]
                    dplyr::full_join(dadoiivs, dadoiidh, by = c('Município' = 'Codmun7')) %>%
                    dplyr::left_join(., municipios_br[,c(3,4)], by  = c('Município' = 'codigo'))
                    })
 
 #série PIB
 dado_municipio3 <- reactive({
                    municipio <- with(municipios_br, municipios_br[which((uf == 'Santa Catarina') & (municipio %in% input$indmunicipio2)), 'codigo'])
                    variavel <- c('Agropecuária', 'Indústria', 'Serviços', 'Adm. Pública', 'Impostos','PIB') 
                    variavel <- which(variavel == input$variavell) + 4
                    pib_deflac <- pib_deflac[,-c(9)]
                    pib_deflac[which((pib_deflac$codigo %in% municipio)), c(1,3:4,variavel)]
                    
                    })
 
 testei <- reactiveVal()
 observe(testei <- testei(input$variavell))
 output$teste  <- renderPrint({testei()})                   
 #gráfivco pop região
 dado_pop <- reactive({dadoi <- dado_mapa()
                           names(dadoi)[1:3] <- c('Ano', 'codigo','nome_municipio')
                           dadoi$codigo <- as.numeric(dadoi$codigo)
                           dadoi <- dplyr::left_join(dadoi, pops[,6:7], by = c('codigo' = 'cod7')) 
                           names(dadoi)[4:5] <- c('variavel','faixa')
                           dadoi <- aggregate(variavel ~ Ano + faixa, data = dadoi, FUN = mean, na.rm = T)
                           
                           serie <- lapply(split(dadoi, dadoi$Ano), function(x){
                                           list(name = as.character(x$Ano)[1],
                                                #type = 'bar',
                                                data = round(x$variavel,3))
                                           }) %>% unname
                          list(dadoi, serie)                 
                                           })
 
 
 output$outronome <- renderApex({
                          dadoi <- dado_pop()[[1]]
                          serie <- dado_pop()[[2]] 
                          list(
                               chart = list(type = 'bar',
                                            height = 300),
                               plotOptions = list(
                                                  bar = list(
                                                             horizontal = 'false',
                                                             endingShape = 'rounded')),
                                      
                               xaxis = list(
                                            categories = unique(dadoi$faixa)),
                               
                               series = serie
                               ) 
                                    })
 

 #radar1 (anos)
 
  output$ind_radar  <- renderEcharts({
                         dadoi <- dado_municipio()
                         
                         list(
                              legend = list(data = c('1991','2000','2010')),
                              radar = list(
                                           indicator = list(
                                                            list(name = 'IVS', max = 0.7),
                                                            list(name = 'IVS.Infraestrutura', max = 0.7),
                                                            list(name = 'IVS.CapHumano', max = 0.7),
                                                            list(name = 'IVS.Renda', max = 0.7),
                                                            list(name = 'IDH-M', max = 0.9),
                                                            list(name = 'IDH-E', max = 0.9),
                                                            list(name = 'IDH-L', max = 0.9),
                                                            list(name = 'IDH-R', max = 0.9)
                                                            )),
                            series = list(               #name = 'radarchart',
                                                         type = 'radar',
                                                         data = list(
                                                         list(value = as.numeric(dadoi[3,-1]), name = '1991'),
                                                         list(value = as.numeric(dadoi[1,-1]), name = '2000'),
                                                         list(value = as.numeric(dadoi[2,-1]), name = '2010'))
                                                         )
                              
                              )            
                                     })

  #radar (municípios)
 
  output$ind_radar2  <- renderEcharts({
                         dadoi <- dado_municipio2()
                         serie <- lapply(split(dadoi, dadoi$municipio), function(x){
                                         list(value = as.numeric(x[,-c(1,10)]),
                                              name = x[1,10])
                                         }) %>% unname
                         list(
                              legend = list(data = dadoi$municipio),
                              radar = list(
                                           indicator = list(
                                                            list(name = 'IVS', max = 0.7),
                                                            list(name = 'IVS.Infraestrutura', max = 0.7),
                                                            list(name = 'IVS.CapHumano', max = 0.7),
                                                            list(name = 'IVS.Renda', max = 0.7),
                                                            list(name = 'IDH-M', max = 0.9),
                                                            list(name = 'IDH-E', max = 0.9),
                                                            list(name = 'IDH-L', max = 0.9),
                                                            list(name = 'IDH-R', max = 0.9)
                                                            )),
                            series = list(               #name = 'radarchart',
                                                         type = 'radar',
                                                         data = serie)
                                                        
                              
                              )            
                                     })
 
 
 #stacked area (pibs)
 #atualizado em 09-ago023 (trocado)
 output$area  <- renderEcharts({
                         Sys.sleep(.3)
                         dadoi <- dado_municipio3()
                         serie  <- lapply(split(dadoi, dadoi$municipio), function(x){
                                          list(name = x$municipio[1],
                                               data = round(x[,4],2))
                                          }) %>% unname
                         
                         list(
                              chart = list(
                                   type  ='area',
                                   height = '100%'
                              ),
                              dataLabels = list(enabled = FALSE),
                              stroke = list(curve = 'straight'),
                              xaxis = list(categories = unique(dadoi$ano)),
                              yaxis = list(opposite = TRUE),
                              series = serie                          
                              
                              )            
                                     })
 
 
 #-----------------------------------------------------------------------------
 #tabela
 output$ind_texto1 <- renderUI({
                               tags$h5(paste('Lista de indicadores para o município de', input$indmunicipio))  
                               })
 

 
 #tab população
 output$tab_populacao <- renderText({
                          municipio <- with(municipios_br, municipios_br[uf == 'Santa Catarina' & municipio == input$indmunicipio, 'codigo'])
                          dadoiidh <- dadosidh[which(dadosidh$Codmun7 == municipio), c(1,10,152,153,154,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231)]
                          names(dadoiidh) <- toupper(names(dadoiidh))
                          nomesidh[,1] <- toupper(nomesidh[,1])
                          dadoiidh <- reshape2::melt(dadoiidh, id.vars = 'ANO') %>%
                                   tidyr::spread(., key = ANO, value = value)
                          dadoiidh <- dplyr::left_join(dadoiidh, nomesidh[,1:2], by = c('variable' = 'SIGLA'))
                          names(dadoiidh)[5] <- c('Indicador')
                          dadoiidh$`Var % 91/00` <- with(dadoiidh, round((`2000` - `1991`)*100/`1991`,2))
                          dadoiidh$`Var % 00/10` <- with(dadoiidh, round((`2010` - `2000`)*100/`2000`,2))
                          
                           kbl(dadoiidh[,c(5,2:4,6,7)]) %>%
                           kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive")) %>%
                           scroll_box(width = "100%", height = "500px")
                           
                          })
                          
 #tab renda
 output$tab_renda <- renderText({
                          municipio <- with(municipios_br, municipios_br[uf == 'Santa Catarina' & municipio == input$indmunicipio, 'codigo'])
                          dadoiidh <- dadosidh[which(dadosidh$Codmun7 == municipio), c(1,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,155,156,157)]
                          names(dadoiidh) <- toupper(names(dadoiidh))
                          nomesidh[,1] <- toupper(nomesidh[,1])
                          dadoiidh <- reshape2::melt(dadoiidh, id.vars = 'ANO') %>%
                                   tidyr::spread(., key = ANO, value = value)
                          dadoiidh <- dplyr::left_join(dadoiidh, nomesidh[,1:2], by = c('variable' = 'SIGLA'))
                          names(dadoiidh)[5] <- c('Indicador')
                          dadoiidh$`Var % 91/00` <- with(dadoiidh, round((`2000` - `1991`)*100/`1991`,2))
                          dadoiidh$`Var % 00/10` <- with(dadoiidh, round((`2010` - `2000`)*100/`2000`,2))
                          
                           kbl(dadoiidh[,c(5,2:4,6,7)]) %>%
                           kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive")) %>%
                           scroll_box(width = "100%", height = "500px")
                           
                          })                        
  
 #tab trabalho
 output$tab_trabalho <- renderText({
                          municipio <- with(municipios_br, municipios_br[uf == 'Santa Catarina' & municipio == input$indmunicipio, 'codigo'])
                          dadoiidh <- dadosidh[which(dadosidh$Codmun7 == municipio), c(1,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138)]
                          names(dadoiidh) <- toupper(names(dadoiidh))
                          nomesidh[,1] <- toupper(nomesidh[,1])
                          dadoiidh <- reshape2::melt(dadoiidh, id.vars = 'ANO') %>%
                                   tidyr::spread(., key = ANO, value = value)
                          dadoiidh <- dplyr::left_join(dadoiidh, nomesidh[,1:2], by = c('variable' = 'SIGLA'))
                          names(dadoiidh)[5] <- c('Indicador')
                          dadoiidh$`Var % 91/00` <- with(dadoiidh, round((`2000` - `1991`)*100/`1991`,2))
                          dadoiidh$`Var % 00/10` <- with(dadoiidh, round((`2010` - `2000`)*100/`2000`,2))
                          
                           kbl(dadoiidh[,c(5,2:4,6,7)]) %>%
                           kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive")) %>%
                           scroll_box(width = "100%", height = "500px")
                           
                          })
  
 #tab domicili
 output$tab_domicilio <- renderText({
                          municipio <- with(municipios_br, municipios_br[uf == 'Santa Catarina' & municipio == input$indmunicipio, 'codigo'])
                          dadoiidh <- dadosidh[which(dadosidh$Codmun7 == municipio), c(1,139,140,141,142,143,144,145,146,149,150,151,158)]
                          names(dadoiidh) <- toupper(names(dadoiidh))
                          nomesidh[,1] <- toupper(nomesidh[,1])
                          dadoiidh <- reshape2::melt(dadoiidh, id.vars = 'ANO') %>%
                                   tidyr::spread(., key = ANO, value = value)
                          dadoiidh <- dplyr::left_join(dadoiidh, nomesidh[,1:2], by = c('variable' = 'SIGLA'))
                          names(dadoiidh)[5] <- c('Indicador')
                          dadoiidh$`Var % 91/00` <- with(dadoiidh, round((`2000` - `1991`)*100/`1991`,2))
                          dadoiidh$`Var % 00/10` <- with(dadoiidh, round((`2010` - `2000`)*100/`2000`,2))
                          
                           kbl(dadoiidh[,c(5,2:4,6,7)]) %>%
                           kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive")) %>%
                           scroll_box(width = "100%", height = "500px")
                           
                          })
 
  #tab longevidade
 output$tab_longevidade <- renderText({
                          municipio <- with(municipios_br, municipios_br[uf == 'Santa Catarina' & municipio == input$indmunicipio, 'codigo'])
                          dadoiidh <- dadosidh[which(dadosidh$Codmun7 == municipio), c(1,6,7,8,9,11,12,13)]
                          names(dadoiidh) <- toupper(names(dadoiidh))
                          nomesidh[,1] <- toupper(nomesidh[,1])
                          dadoiidh <- reshape2::melt(dadoiidh, id.vars = 'ANO') %>%
                                   tidyr::spread(., key = ANO, value = value)
                          dadoiidh <- dplyr::left_join(dadoiidh, nomesidh[,1:2], by = c('variable' = 'SIGLA'))
                          names(dadoiidh)[5] <- c('Indicador')
                          dadoiidh$`Var % 91/00` <- with(dadoiidh, round((`2000` - `1991`)*100/`1991`,2))
                          dadoiidh$`Var % 00/10` <- with(dadoiidh, round((`2010` - `2000`)*100/`2000`,2))
                          
                           kbl(dadoiidh[,c(5,2:4,6,7)]) %>%
                           kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive")) %>%
                           scroll_box(width = "100%", height = "500px")
                           
                          })                         
 
 #tab escolaridade
 output$tab_escola <- renderText({
                          municipio <- with(municipios_br, municipios_br[uf == 'Santa Catarina' & municipio == input$indmunicipio, 'codigo'])
                          dadoiidh <- dadosidh[which(dadosidh$Codmun7 == municipio), c(1,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,147,148,232,233)]
                          names(dadoiidh) <- toupper(names(dadoiidh))
                          nomesidh[,1] <- toupper(nomesidh[,1])
                          dadoiidh <- reshape2::melt(dadoiidh, id.vars = 'ANO') %>%
                                   tidyr::spread(., key = ANO, value = value)
                          dadoiidh <- dplyr::left_join(dadoiidh, nomesidh[,1:2], by = c('variable' = 'SIGLA'))
                          names(dadoiidh)[5] <- c('Indicador')
                          dadoiidh$`Var % 91/00` <- with(dadoiidh, round((`2000` - `1991`)*100/`1991`,2))
                          dadoiidh$`Var % 00/10` <- with(dadoiidh, round((`2010` - `2000`)*100/`2000`,2))
                          
                           kbl(dadoiidh[,c(5,2:4,6,7)]) %>%
                           kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive")) %>%
                           scroll_box(width = "100%", height = "500px")
                           
                          })                         
  
 #------------------------------------------------------------------------
  #box cards
  
  output$card1 <- renderUI({
                           dadoi <- dado_municipio3()
                           dadoi <- dadoi[dadoi$ano == 2020,]
                           dadoi <- dplyr::arrange(dadoi, desc(dadoi[,4]))
                           titulo <- paste0('Maior valor ', input$variavell,'*')
                           numero <- paste('R$',round(dadoi[1,4],2))
                           icone <- "fa fa-chevron-up"
                           texto <- dadoi[1,2]
                           perc <-  paste0(round(dadoi[1,4]*100/sum(dadoi[,4], na.rm = T),2),'%')
                           box_card(titulo = titulo, texto = texto, i = icone, numero = numero, texto_num = perc)
                           })
  
  output$card2 <- renderUI({
                           dadoi <- dado_municipio3()
                           dadoi <- dadoi[dadoi$ano == 2020,]
                           titulo <- paste0('Participação da ', input$variavell,' no estado*')
                           numero <- paste0(round(sum(dadoi[,4], na.rm = T)*100/sum(pib_deflac[pib_deflac$ano == 2020,names(dadoi)[4]], na.rm = T),2),'%')
                           icone <- "fa-solid fa-percent"
                           
                           box_card(titulo = titulo, i = icone, numero = numero)
                           })
  
  output$card3 <- renderUI({
                           dadoi <- dado_municipio3()
                           dadoi <- dadoi[dadoi$ano == 2020,]
                           dadoi <- dplyr::left_join(dadoi, pops[,c(4,5)], by = c('municipio' = 'nome.do.município'))
                           
                           titulo <- paste0('Valor per capita da ', input$variavell,'**')
                           numero <- paste0('R$ ',round(sum(dadoi[,4]*1000, na.rm = T)/sum(dadoi[,5], na.rm = T),2))
                           icone <- "fa-solid fa-user-group"
                           
                           box_card(titulo = titulo, i = icone, numero = numero)
                           })
                          
  }) #end
 