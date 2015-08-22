var ready;
ready = function() {
	window.MathJax.Hub.Queue(["Typeset",MathJax.Hub]);
};

$(document).ready(ready);
