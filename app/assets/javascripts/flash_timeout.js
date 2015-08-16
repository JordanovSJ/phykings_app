//~ This function makes the flash messages disappear after some time
function FlashTimeout ()
{
	setTimeout(function(){
    $('.flash').remove();
		}, 5000);
}

//~ This line executes only after page load. 
//~ It does not work after an AJAX request.
$(document).ready(FlashTimeout);

//~ This line executes after an AJAX request.
// As in the case of creating a new solution, an ajax
// request could call the flash.now and the flash message needs to
// timeout in the same way as the normal flash messages.
$(document).ajaxComplete(FlashTimeout);

