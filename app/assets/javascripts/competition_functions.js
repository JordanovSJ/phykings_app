//~ Used for the Faye stuff. Reloads the page only in the timer is not on the page.
//~ Otherwise, renders the message.mess partial in message.component DOM element.
function change_view(message) {
	if ( message.mess == "reload" && !( $("#competition-timer").length ) ) {
		location.reload();
	} else if ( message.mess != "reload" ) {
		if ( $(message.component).length ) {
			$(message.component).html(message.mess);
		}
	}
}

//~ $(message.component).load(location.href + " " + message.component + ">*", function() {
			//~ MathJax.Hub.Queue(["Typeset",MathJax.Hub]);
		//~ });
