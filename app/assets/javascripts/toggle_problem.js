$(document).ready(function(){
	 $('#view-problem-button').click(function(){
        $('#view-problem-text').toggle("slow", function() {
					MathJax.Hub.Queue(["Typeset",MathJax.Hub]);
				});
    });
});
