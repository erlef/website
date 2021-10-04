import Tagify from '@yaireo/tagify'
  
document.addEventListener('DOMContentLoaded', function() {
  var tagsEl = document.querySelector('input[id=post_tags]');

  var whitelist = ["announcements", "embedded", "education", "infrastructure"]

  if (tagsEl != null) { 
   var tagifiy = new Tagify(tagsEl)

   document.querySelector('tags').classList.add("h-100")
  }
});