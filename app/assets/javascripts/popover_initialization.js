function initialize_popover() {
		$('[data-toggle="popover"]').popover({
        html: true,
        trigger: 'manual',
        container: $(this).attr('id'),
        placement: 'left'
    }).on("mouseenter", function () {
        var _this = this;
        $(this).popover("show");
        $(".popover").on("mouseleave", function () {
            $(_this).popover("hide");
        });
    }).on("mouseleave", function () {
        var _this = this;
        setTimeout(function () {
            if (!$(".popover:hover").length) {
                $(_this).popover("hide")
            }
        }, 100);
    });
}
