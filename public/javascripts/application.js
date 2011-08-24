$(function() {
  $("#kcal-limit span a").mouseover(function() {
    $("#change-kcal-label").show();
  }).mouseout(function() {
    $("#change-kcal-label").hide();
  });
});

var debug = new $.debug({
	posTo : { x:'right', y:'bottom' },
	width: '280px',
	height: '200px',
	itemDivider : '<hr>',
	listDOM : [ 'tagName','id', 'innerText', 'href' ]
});
