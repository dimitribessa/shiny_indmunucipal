
// Create a new InputBinding object
var input_card = new Shiny.InputBinding();

// Extend this object with methods
$.extend(input_card, {
  
  // How to find the object
  find: function(scope) {
    return $(scope).find(".input_card");
  },
  // How to get the value from the objet
  getValue: function(el) {
    return $( (el)+"option:selected" ).text();
  },
  // Used to retrieve the ID of the object
  // STANDARD
  getId: function(el) {
    return el.id;
  },
  // Used to change the value when update for example
  setValue: function(el, value) {
    $(el).text(value);
    
  },
  // Register the event, and validate callback
  subscribe: function(el, callback) {
    $(el).on("change.input_card", function(e) {
      callback();
    });
  },
  // To remove the binding
  unsubscribe: function(el) {
    $(el).off(".input_card");
  }
});

// Register this object as a Shiny Input
Shiny.inputBindings.register(input_card);