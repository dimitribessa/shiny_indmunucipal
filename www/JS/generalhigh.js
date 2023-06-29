 // This isn't strictly necessary, but it's good JavaScript hygiene.
//(function() {

var binding = new Shiny.OutputBinding();

binding.find = function(scope) {
  // For the given scope, return the set of elements that belong to
  // this binding.
  return $(scope).find(".generalhigh");
};

binding.renderValue = function(el, data) {
  // This function will be called every time we receive new output
  // values for a line chart from Shiny. The "el" argument is the
  // div for this particular chart.
  
  var $el = $(el);
  
  //ajustando os dados aos parâmetros do gráfico (01-fev-2019)
  var teste = data;
   console.log(teste);
  /*Object.keys(teste).forEach(function(key) {
  teste[key].unshift(key);
});
  
 */
  
 /* 

 //para as categorias do eixo x
  var nome_x = teste['.id'];
  nome_x.shift();
*/
  //console.log(nome_x);
/*
 var empty = Array();
 for(i = 0, i = result.length)
 
  var x = [
            ['data1', 30, 200, 100, 400, 150, 250],
            ['data2', 130, 100, 140, 200, 150, 50]
        ];
  console.log(x);*/

 /*These lines are all chart setup.  Pick and choose which chart features you want to utilize. */
 
 Highcharts.chart(el, {

    chart: {
    	 renderTo: el,
        type: teste[0],
        zoomType: 'x'
    },

    title: {
      text: null
    },

    xAxis: {
      categories: teste[1],
      
        title: {
          text: null
        }
    },

      yAxis: {
        title: {
          text: null,
          align: 'high'
        },
        labels: {
          overflow: 'justify'
        }
       },  

    /*plotOptions: {
        column: {
            color: 'blue'
        },
        series: {
            color: 'blue'
        }},


     /*tooltip: {
        pointFormat: '<span style="color:{series.color}">Prioridade: <b>{point.y}</b><br/>'
    },*/

    
    legend: {
        enabled: true
    },

    
      
    series:  teste[2]

});


};

// Tell Shiny about our new output binding
Shiny.outputBindings.register(binding, "shinyjs.highbarchart");
//}) //endfunction

