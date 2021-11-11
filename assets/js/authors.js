import Tagify from '@yaireo/tagify'

document.addEventListener('DOMContentLoaded', function() {
  var authorsEl = document.getElementById("post_authors");

  if (authorsEl != null) { 
    var tagify = new Tagify(authorsEl)

    var button = authorsEl.nextElementSibling;  // "add new tag" action-button

    button.addEventListener("click", onAddButtonClick)

    function onAddButtonClick(){
        tagify.addEmptyTag()
    }
  }
});