import Tagify from '@yaireo/tagify'
  
document.addEventListener('DOMContentLoaded', function() {
  var tagsEl = document.getElementById("post_tags");

  if (tagsEl != null) {
    var whitelist = JSON.parse(document.getElementById("blog_categories").innerText)

    var tagify = new Tagify(tagsEl, {
      whitelist: whitelist,
      dropdown: {
        fuzzysearch: false,
        maxItems: 5,
        position: "text",
        enabled: 0
      }
    })

    document.querySelector('tags').classList.add("h-100")
  }
});