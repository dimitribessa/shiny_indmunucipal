 // This isn't strictly necessary, but it's good JavaScript hygiene.
//(function() {

var binding = new Shiny.OutputBinding();

binding.find = function(scope) {
  // For the given scope, return the set of elements that belong to
  // this binding.
  return $(scope).find(".apexbar");
};

binding.renderValue = function(el, data) {
  // This function will be called every time we receive new output
  // values for a line chart from Shiny. The "el" argument is the
  // div for this particular chart.
  
  var $el = $(el);
  
  $(el).empty(); // para limpar os svg´s anteriores
  //ajustando os dados aos parâmetros do gráfico (01-fev-2019)
  var teste = data;
  console.log(teste);

  var options = data;
 /*These lines are all chart setup.  Pick and choose which chart features you want to utilize. */
  var chart = new ApexCharts(el, options);
  
  //ApexCharts.exec('chart');
  chart.render();

  chart.updateOptions({
      xaxis: {
             labels: {
              formatter: function (val) {
                return Math.abs(Math.round(val)) 
            }
          }
        },
      tooltip: {
            x: {
              formatter: function (val) {
                return val
              }
            },
            y: {
              formatter: function (val) {
                return Math.abs(val)
              }
            }
          }
          
      });

};

// Tell Shiny about our new output binding
Shiny.outputBindings.register(binding, "shinyjs.apexbar");
//}) //endfunction

