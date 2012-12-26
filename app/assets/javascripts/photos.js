// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  var instagramTags = ["square",
                       "squareformat",
                       "iphoneography",
                       "instagramapp",
                       "normal",
                       "valencia", "xproii"];
  $("#remove_instagram_tags").click(function() {
    $("input.taglist").each(function() {
      var rawTaglist = $(this).val();
      var tags = rawTaglist.split(" ");
      var newTags = _.difference(tags, instagramTags);
      $(this).val(newTags.join(" "));
    });
  });
});
