$(document).ready(function () {
    $(document).keydown(function (event) {
        var keycode = (event.keyCode ? event.keyCode : event.which);
        if (keycode == '27') {
            closeTablet();
        }
    });

    function closeTablet() {
        $.post("https://rahe-racing/closeTablet", JSON.stringify({}));
    }
});