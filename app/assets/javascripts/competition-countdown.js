// Sets the competition timer to what is remaining from the competition (remaining_sec).
function setCompetitionTimer(remaining_sec) {
		$("#competition-timer").countdown({until: +remaining_sec, onExpiry: function() {
			 location.reload(); } });
}
