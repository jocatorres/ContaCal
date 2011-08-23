$(function() {
  $("#kcal-limit span a").mouseover(function() {
    $("#change-kcal-label").show();
  }).mouseout(function() {
    $("#change-kcal-label").hide();
  });
});