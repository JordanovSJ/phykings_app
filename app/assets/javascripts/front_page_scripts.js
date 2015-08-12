// Note: This code was improved to be compatible with
// Rails 4 Turbolinks. After a link_to navigation
// the $(document).ready function stops working and
// it needs to be exchanged with the 'page:load' event
// from Turbolinks. The answer was found in Stack Overflow. 

var ready = function() {
	/* smooth scrolling for scroll to top */
	$('.scroll-top').click(function(){
		$('body,html').animate({scrollTop:0},800);
	})
	/* smooth scrolling for scroll down */
	$('.scroll-down').click(function(){
		$('body,html').animate({scrollTop:$(window).scrollTop()+500},1000);
	})

	/* highlight the top nav as scrolling occurs */
	$('body').scrollspy({ target: '#navbar' })
};

$(document).ready(ready);
$(document).on('page:load', ready);

