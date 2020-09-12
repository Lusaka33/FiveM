var btns = [
    'system_btn1',
    'system_btn2',
    'system_btn3',
    'system_btn4',
    'system_btn5'
]
var btn_actual = 0
var zoomvalue = 1

$(document).ready(function(){
    function app_system(action){
        if(action == 'OPEN'){
            $("#" + btns[btn_actual]).toggleClass('select_2', false);
            btn_actual = 0;
            $("#" + btns[btn_actual]).toggleClass('select_2', true);
            $("#screen_system").css("display", "block");
        }
        if(action == 'CLOSE'){
            $("#" + btns[btn_actual]).toggleClass('select_2', false);
            btn_actual = 0;
            $("#screen_system").css("display", "none");
        }
        if(action == 'LEFT'){
            if(btn_actual == 0){
                if(zoomvalue > 1){
                    zoomvalue = zoomvalue - 0.1
                    document.getElementById('menus').style.setProperty("--main-size", zoomvalue)
                    document.getElementById('system_size').innerHTML = zoomvalue
                }
            }
        }
        if(action == 'RIGHT'){
            if(btn_actual == 0){
                if(zoomvalue < 2){
                    zoomvalue = zoomvalue + 0.1
                    document.getElementById('menus').style.setProperty("--main-size", zoomvalue)
                    document.getElementById('system_size').innerHTML = zoomvalue
                }
            }
        }
        if(action == 'TOP'){
            if(btn_actual < 0){
                $("#" + btns[btn_actual]).toggleClass('select_2', false);
                btn_actual = btn_actual - 1;
                $("#" + btns[btn_actual]).toggleClass('select_2', true);
            }
        }
        if(action == 'DOWN'){
            if(btn_actual > 4){
                $("#" + btns[btn_actual]).toggleClass('select_2', false);
                btn_actual = btn_actual + 1;
                $("#" + btns[btn_actual]).toggleClass('select_2', true);
            }
        }
        if(action == 'ENTER'){
            $("#" + btns[btn_actual]).toggleClass('select_2', false);
            btn_actual = 0;
            $("#" + btns[btn_actual]).toggleClass('select_2', true);
            $("#screen_system").css("display", "block");
        }
        if(action == 'BACKSPACE'){
            $("#" + btns[btn_actual]).toggleClass('select_2', false);
            btn_actual = 0;
            $("#screen_system").css("display", "none");
            openHome()
        }
    }
});