$(function(){
	
	$(document).on("click", "#sidebar li", function() { 
		$("li.active").toggleClass("active");
		$(this).toggleClass("active"); 
	});
	
});

$(document).ready(function() {
  $('[data-toggle=offcanvas]').click(function() {
    $('.row-offcanvas').toggleClass('active');
  });
});
