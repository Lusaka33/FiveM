var element = document.getElementById("number");
var num = 0;

window.setInterval(function() {
    num++;

    if (num > 100) {
        num = 0;
    }

    element.innerHTML = num + "%";

}, 500);
