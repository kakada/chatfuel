document.addEventListener("turbolinks:load", function(){

  Owso = (function($){
    var app = {}
    
    function addPair() {
      console.log($)
    }

    function factory(dom) {
      let newIndex = +$(dom).data("index") + 1

      return {
        object: $(dom),
        name: dom.name.replace(/\d+/, newIndex),
        id: dom.id.replace(/\d+/, newIndex),
        index: newIndex
      }
    }

    // Dictionaries
    $(".table").on("click", ".dictionary-add-pair", function(e) {
      e.preventDefault()

      var lastChild = $(".value-row:last-of-type")
      var newChild = lastChild.clone()
      var input = newChild.find("input.form-control")

      var dom = factory(input[0])
      dom.object.attr({ name: dom.name, id: dom.id, "data-index": dom.index })

      dom = factory(input[1])
      dom.object.attr({ name: dom.name, id: dom.id, "data-index": dom.index })

      lastChild.after(newChild)
    })

    $(".table").on("click", ".dictionary-remove-pair", function(e) {
      e.preventDefault()
      var row = $(this).closest("tr")

      console.log( row.closest("tbody").children(".value-row").length )
      if( row.closest("tbody").children(".value-row").length > 1 ) {
        row.remove()
      } else {
        alert("Unable to empty dictionary")
      }
    })

    app.addPair = addPair

    return app
  }(jQuery))
})