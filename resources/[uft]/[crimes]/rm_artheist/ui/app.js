$(document).ready(function(){
    window.addEventListener("message", function(event){
        if(event.data.action == 'open') {
            $(".mission").css({
                "display":"block"
            });
            for(i = 0; i < event.data.list.length; i++) {
                var element = "<img src ='" + event.data.list[i] + '.png' + "' class = 'missionImage' >";
                $(".mission").append(element);
            }
            sleep(3000).then(() => {
                $(".mission").fadeOut(2000)
                $(".mission").html("");
            });
        }

        var documentWidth = document.documentElement.clientWidth;
        var documentHeight = document.documentElement.clientHeight;
        var curTask = 0;
        var lastTrigger = 0;
        var processed = [];

        function closeMain() {
            lastTrigger = 0;
            $(".divwrap").fadeOut(500);
        }

        var item = event.data;
        if (item.runProgress === true) {
            var percent = item.Length;
            $(".divwrap").fadeIn(500);
            var red = 100 + item.Length
            var green = 200 - item.Length * 2
            $('.progress-bar').css('background', "rgba(" + red + "," + green + ",0,0.6)");
            $('.progress-bar').css('width', item.Length + "%");
        }
        if(item.closeProgress === true) {
            closeMain();
        }
    });
});

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}
