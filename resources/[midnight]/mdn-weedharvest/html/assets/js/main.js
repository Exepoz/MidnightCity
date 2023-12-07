var hideTimeout
function Show(data) {
    if (hideTimeout !== null || true) clearTimeout(hideTimeout);
    $("#seed-name").html(data.Label);

    const progressPercentage = Math.floor(data.Progress);
    $("#progressPercentage").text(progressPercentage + "% ");
    $("#progressbarProgress").css("width", progressPercentage+ "%");
    $("#progressbarProgress").css("background-color", `rgb(${(100 - data.Progress) *2.56},${data.Progress *2.56},0)`);


    const healthPercentage = data.Health;
    $("#healthPercentage").text(healthPercentage + "% ");
    $("#progressbarHealth").css("width", healthPercentage+ "%");
    $("#progressbarHealth").css("background-color", `rgb(${(100 - data.Health) *2.56},${data.Health *2.56},0)`);

    const waterPercentage = data.Water;
    $("#waterPercentage").text(waterPercentage + "% ");
    $("#progressbarWater").css("width", waterPercentage + "%");
    $("#progressbarWater").css("background-color", `rgb(${(100 - waterPercentage) * 2.56},${waterPercentage * 2.56},0)`);

    $("#state-block").css("display", "block");
    $("#state-name").html(data.State);
    if (data.ShowOptions) {
        $("#buttons-block").removeClass("hide");
    }
    if (!data.FertilizeOptions){
        $("#fertilize-option").addClass("hide");
    }
    $("#main-container").show();
    $("#main-container").addClass("show");
}

function Hide() {
    $("#main-container").removeClass("show");
    hideTimeout = setTimeout(function () {
        $("#main-container").hide();
        $("#buttons-block").addClass("hide");
    }, 250)
}

$(document).ready(function() {
    window.addEventListener("message", (evt) => {
        const data = evt.data
        const action = data.action
        switch (action) {
            case "show":
                Show(data);
                break;
            case "hide":
                Hide()
                break;
        }
    })

    document.onkeyup = function (data) {
        if (data.which == 27) {
            Hide();
            $.post(`https://${GetParentResourceName()}/FocusOff`, JSON.stringify({}));
        }
    }

    $( ".buttons-option" ).click(function() {
        $.post(`https://${GetParentResourceName()}/OptionHandler`, JSON.stringify({action:$(this).attr('id')}));
    });
});