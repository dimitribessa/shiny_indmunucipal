 #tratando dados (03-jun-2023, 10:38h)
 
 itens_serie <- c('Agropecuária', 'Indústria', 'Serviços', 'Adm. Pública', 'Impostos','PIB')
 names(pops) <- tolower(names(pops))
 
 pops$população <- as.numeric(pops$população)
 pops$faixa <- cut(pops$população, breaks = c(-Inf,5000, 10000, 20000, 50000, 100000, Inf),
                   labels = c('Até 5000 hab', '5001-10.000 hab', '10.001-20.000 hab',
                   '20.001-50.000 hab','50.001-100.000 hab','>100.000 hab'))