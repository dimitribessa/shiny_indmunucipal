 // This isn't strictly necessary, but it's good JavaScript hygiene.
//(function() {

var binding = new Shiny.OutputBinding();

binding.find = function(scope) {
  // For the given scope, return the set of elements that belong to
  // this binding.
  return $(scope).find(".plotlyjs");
};

binding.renderValue = function(el, data) {
  // This function will be called every time we receive new output
  // values for a line chart from Shiny. The "el" argument is the
  // div for this particular chart.
  
  var $el = $(el);
  var datai = data;
  
 var dado = datai[0];

 var layout = datai[1];

 //console.log(datai);
 Plotly.newPlot(el,dado, layout);


}


// Tell Shiny about our new output binding
Shiny.outputBindings.register(binding, "shinyjs.plotlyjs");
//}) //endfunction
