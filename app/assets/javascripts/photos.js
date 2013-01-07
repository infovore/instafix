// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  var instagramTags = ["square",
                       "squareformat",
                       "iphoneography",
                       "instagramapp",
                       "normal",
                       "valencia", 
                       "xproii", 
                       "amaro", 
                       "sierra", 
                       "rise", 
                       "hudson", 
                       "lomofi", 
                       "sutro"];
  $("#remove_instagram_tags").click(function() {
    $("input.taglist").each(function() {
      var rawTaglist = $(this).val();
      var tags = rawTaglist.split(" ");
      var newTags = _.difference(tags, instagramTags);
      $(this).val(newTags.join(" "));
    });
    updateAllPhotos();
    return false;
  });

  $("#check_all").click(function() {
    $(".checkbox input").attr("checked", "checked");
    updateAllPhotos();
    return false;
  });

  $("input, textarea").focus(function() {
    updateThisPhoto(this);
  });

  function updateThisPhoto(el) {
    var cbs = $(el).parents("fieldset").find(".update_cb");
    if(cbs.length > 0) {
      $(cbs[0]).attr("checked", "checked");
    }
  }

  function updateAllPhotos() {
    $(".update_cb").attr("checked", "checked");
  }
});
