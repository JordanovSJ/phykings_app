$(function() {
  faye = new Faye.Client('/faye');
  faye.subscribe('/competitions/_show', function(data) { 
		eval(data);
	});
});
