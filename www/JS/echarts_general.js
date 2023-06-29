 // This isn't strictly necessary, but it's good JavaScript hygiene.
//(function() {

var binding = new Shiny.OutputBinding();

binding.find = function(scope) {
  // For the given scope, return the set of elements that belong to
  // this binding.
  return $(scope).find(".echarts");
};

binding.renderValue = function(el, data) {
  // This function will be called every time we receive new output
  // values for a line chart from Shiny. The "el" argument is the
  // div for this particular chart.
  
  var $el = $(el);
  
  //$(el).empty(); // para limpar os svg´s anteriores
  //ajustando os dados aos parâmetros do gráfico (01-fev-2019)
  var teste = data;
  console.log(teste);

  var options = data;
  $(el).empty(); // para limpar os svg´s anteriores
  
 /*These lines are all chart setup.  Pick and choose which chart features you want to utilize. */
  echarts.dispose(el);
  var myChart = echarts.init(el, null, { renderer: 'svg' });
  
 
  myChart.setOption(data,noMerge = true);
  
};

// Tell Shiny about our new output binding
Shiny.outputBindings.register(binding, "shinyjs.echarts");
//}) //endfunction

