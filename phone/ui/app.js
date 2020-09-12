var map_app = [
    [
        {select: false, id: 'system'},
        {select: false, id: 'contact'},
        {select: false, id: 'message'},
        {select: false, id: 'appels'}
    ],
    [
        {select: false, id: 'calculatrice'},
        {select: false, id: 'journal'},
        {select: false, id: 'notes'},
        {select: false, id: 'chrome'}
    ],
    [
        {select: false, id: 'custom1'},
        {select: false, id: 'custom2'},
        {select: false, id: 'custom3'},
        {select: false, id: 'custom4'}
    ]
]
var in_app = false
var sel_ligne = 0
var sel_colone = 0
var max_ligne = 0
var max_colone = 3

var system_btns = [
    'system_btn1',
    'system_btn2',
    'system_btn3',
    'system_btn4',
    'system_btn5',
    'system_btn6'
]
var system_btn_actual = 0
var system_zoomvalue = 1
var system_level = 1
var fond_nb = 7

var contact_ct_actual = 1
var contact_ct_max = 3
var contact_level = 1
var contact_btns = [
    'con_nom',
    'con_num',
    'button_1',
    'button_2',
    'button_3'
]
var contact_btn_actual = 0

var message_ct_actual = 1
var message_ct_max = 3
var message_level = 1
var message_max = 1
var message_scroll = 0
var message_btn = 1


var appels_ct_actual = 1
var appels_ct_max = 6
var appels_level = 1 // 1 = appel , 2 = pol, 3 = she, 4 = amb, 5 = pompier, 6 = mecano, 7 = taxi

var Coma = false


$(document).ready(function(){
    $("#screen_home").css("display", "none");
    $("#screen_system").css("display", "none");
    $("#screen_fond").css("display", "none");
    $("#screen_message").css("display", "none");
    $("#screen_message_1").css("display", "none");
    $("#screen_message_2").css("display", "none");
    $("#screen_message_3").css("display", "none");
    $("#screen_message_4").css("display", "none");
    $("#screen_appels").css("display", "none");
    $("#screen_contact").css("display", "none");
    $("#screen_contact_2").css("display", "none");
    $("#screen_coma").css("display", "none");
    $("#screen_coma2").css("display", "none");
    $("#screen_appels_police").css("display", "none");
    $("#screen_appels_sheriff").css("display", "none");
    $("#screen_appels_ambulance").css("display", "none");
    $("#screen_appels_pompier").css("display", "none");
    $("#screen_appels_mecano").css("display", "none");
    $("#screen_appels_taxi").css("display", "none");
    $("#mes_del2").css("display", "none");
    $("#menus").css("display", "none");

    function horloge() {
        var date = new Date();
        var str = ''+(date.getHours()<10?'0':'')+date.getHours();
        str += ':'+(date.getMinutes()<10?'0':'')+date.getMinutes();
        str += ':'+(date.getSeconds()<10?'0':'')+date.getSeconds();
        document.getElementById('heure').innerHTML = str;
        setTimeout(horloge, 1000);
    }
    horloge();
    function timeConverter(timestamp){
        var a = new Date(timestamp);
        var months = ['Jan','Fev','Mar','Avr','Mai','Juin','Juil','Aout','Sep','Oct','Nov','Dec'];
        var year = a.getFullYear();
        var month = months[a.getMonth()];
        var date = a.getDate();
        var hour = a.getHours();
        var min = a.getMinutes();
        var time = date + '/' + month + '/' + year + ' à ' + hour + ':' + min ;
        return time;
    }
    function getTimestamp(){
        var n = Date.now();
        return n;
    }

    // Listen for LUA Events
    window.addEventListener('message', function(event){
      var item = event.data;

      if(item.action == 'deadMode') {
        Coma = item.value

            press('CLOSE', in_app)
            $("#app_" + map_app[sel_ligne][sel_colone].id).toggleClass('select_1', false)
            $("#screen_home").css("display", "none");
            $("#menus").css("display", "none");
            in_app = false
            $.post('http://phone/closeTel', JSON.stringify({}));
      }

      if(item.action == 'loaded') {
        system_zoomvalue = item.myzoom
        document.getElementById('menus').style.setProperty("--main-size", system_zoomvalue / 10)
        document.getElementById('system_size').innerHTML = system_zoomvalue - 9
        document.getElementById('system_phone').innerHTML = item.myphone
        document.getElementById('system_msg').innerHTML = item.myNbMsg
        document.getElementById('screen_home').style.backgroundImage = "url('../fonds/fond" + item.myfond + ".jpg')"
      }

      if(item.action == 'refreshSMSnb') {
        document.getElementById('system_msg').innerHTML = item.myNbMsg
      }

      if(item.action == 'setContactName') {
        document.getElementById('con_nom').value = item.value
      }
      if(item.action == 'setContactNumber') {
        document.getElementById('con_num').value = item.value
      }

      if(item.action == 'playSonnerie') {
        document.getElementById("bip_audio").volume = 1.0;
        document.getElementById("bip_audio").play()
        if(in_app == "message"){
            if(message_level == 2){
                $.post('http://phone/openMessageChat', JSON.stringify({
                    phone: document.getElementById('screen_message_2').phone_nb
                }));
            }
        }

      }

      if(item.action == 'openContact') {
        let contact_text_temp = '<div class="screen_2"><div class="con1"><span class="sp1">Contacts</span></div><div class="bite1">'
        contact_ct_max = 1
        contact_text_temp = contact_text_temp + '<div class="con2" id="contact_ct_1"><img class="i_con" src="../img/contact.png">Ajouter un contact</div>'
        item.mymessage.forEach(element => {
            contact_ct_max = contact_ct_max + 1
            contact_text_temp = contact_text_temp + '<div class="con2" id="contact_ct_' + contact_ct_max + '"><img class="i_con" src="../img/contact.png">' + element.name + '</div>'
        });
        contact_text_temp = contact_text_temp + '</div></div>'
        document.getElementById('screen_contact').innerHTML = contact_text_temp

        let temp_1 = 1
        document.getElementById('contact_ct_1').phone_name = ""
        document.getElementById('contact_ct_1').phone_nb = ""
        document.getElementById('contact_ct_1').phone_type = "add"
        item.mymessage.forEach(element => {
            temp_1 = temp_1 + 1
            document.getElementById('contact_ct_' + temp_1).phone_name = element.name
            document.getElementById('contact_ct_' + temp_1).phone_nb = element.phone
            document.getElementById('contact_ct_' + temp_1).phone_type = "modify"
        });

        contact_level = 1
        $("#contact_ct_" + contact_ct_actual).toggleClass('select_2', false);
        contact_ct_actual = 1;
        $("#contact_ct_" + contact_ct_actual).toggleClass('select_2', true);
        $("#screen_contact").css("display", "block");
        $("#screen_contact_2").css("display", "none");
      }


      if(item.action == 'openMessageMenu') {
        let message_text_temp = '<div class="screen_2"><div class="con1"><span class="sp1">Messages</span></div><div class="bite1">'
        message_ct_max = 1
        message_text_temp = message_text_temp + '<div class="con2" id="message_ct_1"><img class="i_con" src="../img/n_message.png">Nouvelle discution</div>'
        item.mymessage.forEach(element => {
            message_ct_max = message_ct_max + 1
            message_text_temp = message_text_temp + '<div class="con2" id="message_ct_' + message_ct_max + '"><img class="i_con" src="../img/n_message.png">' + element.name + '</div>'
        });
        message_text_temp = message_text_temp + '</div></div>'
        document.getElementById('screen_message').innerHTML = message_text_temp

        let message_text_temp_12 = '<div class="screen_5"><div class="con1"><span class="sp1">Messages</span></div><div class="bite1">'
        message_ct_max = 1
        message_text_temp_12 = message_text_temp_12 + '<div class="con2" id="message_ct_2_1"><img class="i_con" src="../img/n_message.png">Nouvelle discution</div>'
        item.mymessage.forEach(element => {
            message_ct_max = message_ct_max + 1
            message_text_temp_12 = message_text_temp_12 + '<div class="con2" id="message_ct_2_' + message_ct_max + '"><img class="i_con" src="../img/n_message.png">' + element.name + '</div>'
        });
        message_text_temp_12 = message_text_temp_12 + '</div></div><div id="mes_del1" class="con13"><span id="mes_del2" style="display: none;">Supprimer conversation</span></div>'
        document.getElementById('screen_message_1').innerHTML = message_text_temp_12


        let temp_1 = 1
        document.getElementById('message_ct_1').phone_name = ""
        document.getElementById('message_ct_1').phone_nb = ""
        document.getElementById('message_ct_1').phone_type = "add"
        item.mymessage.forEach(element => {
            temp_1 = temp_1 + 1
            document.getElementById('message_ct_' + temp_1).phone_name = element.name
            document.getElementById('message_ct_' + temp_1).phone_nb = element.phone
            document.getElementById('message_ct_' + temp_1).phone_type = "modify"
        });

        message_level = 1
        $("#message_ct_" + message_ct_actual).toggleClass('select_2', false);
        message_ct_actual = 1;
        $("#message_ct_" + message_ct_actual).toggleClass('select_2', true);
        $("#screen_message").css("display", "block");
        $("#screen_message_1").css("display", "none");
        $("#screen_message_2").css("display", "none");
        $("#screen_message_3").css("display", "none");
        $("#screen_message_4").css("display", "none");
      }

      if(item.action == 'openMessageChat') {
        let nb_msg = 1
        item.mymessage.forEach(element => {
            nb_msg = nb_msg + 1
        });

        let message_text_temp_2 = '<span class="but2"><input class="but2_2" id="message_nb_0" type="text" placeholder="Tapez votre message"><img id="but_2_i" src="../img/envoyer.png"></span><div class="con5"><span class="sp1">' + item.name + '</span></div><div id="screen_3"><div id="scren_3">'
        message_max = nb_msg
        item.mymessage.forEach(element => {
            message_max = message_max - 1
            if(element.isSender){
                message_text_temp_2 = message_text_temp_2 + '<div class="con9" id="message_nb_' + message_max + '">' + element.message + '</div><div class="con16">' + timeConverter(element.date) + '</div>'
            } else {
                message_text_temp_2 = message_text_temp_2 + '<div class="con8" id="message_nb_' + message_max + '">' + element.message + '</div><div class="con15">' + timeConverter(element.date) + '</div>'
            }
        });
        message_text_temp_2 = message_text_temp_2 + '</div></div>'
        document.getElementById('screen_message_2').innerHTML = message_text_temp_2

        let message_text_temp_3 = '<div class="con5"><span class="sp1">' + item.name + '</span></div><div id="screen_5">'
        message_max = nb_msg
        item.mymessage.forEach(element => {
            message_max = message_max + 1
            if(element.isSender){
                message_text_temp_3 = message_text_temp_3 + '<div class="con9" id="message_nb_2_' + message_max + '">' + element.message + '</div><div class="con16">' + timeConverter(element.date) + '</div>'
            } else {
                message_text_temp_3 = message_text_temp_3 + '<div class="con8" id="message_nb_2_' + message_max + '">' + element.message + '</div><div class="con15">' + timeConverter(element.date) + '</div>'
            }
        });
        message_text_temp_3 = message_text_temp_3 + '</div><div id="mes_4" class="con14">Supprimer le msg</div><div id="mes_5" class="con14">Utiliser les coordonnées</div>'
        document.getElementById('screen_message_3').innerHTML = message_text_temp_3

        let message_text_temp_4 = '<div class="con5"><span class="sp1">' + item.name + '</span></div><div id="screen_5_2">'
        message_max = nb_msg
        item.mymessage.forEach(element => {
            message_max = message_max + 1
            if(element.isSender){
                message_text_temp_4 = message_text_temp_4 + '<div class="con9" id="message_nb_3_' + message_max + '">' + element.message + '</div><div class="con16">' + timeConverter(element.date) + '</div>'
            } else {
                message_text_temp_4 = message_text_temp_4 + '<div class="con8" id="message_nb_3_' + message_max + '">' + element.message + '</div><div class="con15">' + timeConverter(element.date) + '</div>'
            }
        });
        message_text_temp_4 = message_text_temp_4 + '</div><div id="mes_1" class="con14">Envoyer message</div><div id="mes_2" class="con14">Envoyer coordonées</div><div id="mes_3" class="con14">anonyme : comming soon</div>'
        document.getElementById('screen_message_4').innerHTML = message_text_temp_4

        message_scroll = 1
        message_max = nb_msg - 1



        let temp_1 = nb_msg
        item.mymessage.forEach(element => {
            temp_1 = temp_1 - 1
            document.getElementById("message_nb_" + temp_1).phone_message = element.message
            document.getElementById("message_nb_" + temp_1).phone_date = element.date
        });

        document.getElementById('screen_message_2').phone_nb = item.phone

        message_level = 2
        $("#screen_message").css("display", "none");
        $("#screen_message_1").css("display", "none");
        $("#screen_message_2").css("display", "block");
        $("#screen_message_3").css("display", "none");
        $("#screen_message_4").css("display", "none");

        if(message_max > 0) {
            document.getElementById("message_nb_" + message_scroll).scrollIntoView()
        }
        message_scroll = 0
      }


      if(item.action == 'controlPressed') {
          if(Coma == true){
              comaScreen(item.control)
          } else {
                if(item.control == 'ENTER') {
                    if(in_app == false){
                    } else if(in_app == "home"){
                        $("#app_" + map_app[sel_ligne][sel_colone].id).toggleClass('select_1', false)
                        $("#screen_home").css("display", "none");
                        in_app = map_app[sel_ligne][sel_colone].id
                        press('OPEN', in_app)
                    } else {
                        press('ENTER', in_app)
                    }
                }
                if(item.control == 'BACKSPACE') {
                    if(in_app == false){
                    } else if(in_app == "home") {
                        $("#app_" + map_app[sel_ligne][sel_colone].id).toggleClass('select_1', false)
                        $("#screen_home").css("display", "none");
                        $("#menus").css("display", "none");
                        in_app = false
                        $.post('http://phone/closeTel', JSON.stringify({}));
                    } else {
                        press('BACKSPACE', in_app)
                    }
                }
                if(item.control == 'TOP') {
                    if(in_app == false){
                    } else if(in_app == "home") {
                        if(sel_ligne > 0){
                            $("#app_" + map_app[sel_ligne][sel_colone].id).toggleClass('select_1', false)
                            sel_ligne = sel_ligne - 1
                            $("#app_" + map_app[sel_ligne][sel_colone].id).toggleClass('select_1', true)
                        }
                    } else {
                        press('TOP', in_app)
                    }
                }
                if(item.control == 'DOWN') {
                    if(in_app == false){
                    } else if(in_app == "home") {
                        if(sel_ligne < max_ligne){
                            $("#app_" + map_app[sel_ligne][sel_colone].id).toggleClass('select_1', false)
                            sel_ligne = sel_ligne + 1
                            $("#app_" + map_app[sel_ligne][sel_colone].id).toggleClass('select_1', true)
                        }
                    } else {
                        press('DOWN', in_app)
                    }
                }
                if(item.control == 'LEFT') {
                    if(in_app == false){
                    } else if(in_app == "home") {
                        if(sel_colone > 0){
                            $("#app_" + map_app[sel_ligne][sel_colone].id).toggleClass('select_1', false)
                            sel_colone = sel_colone - 1
                            $("#app_" + map_app[sel_ligne][sel_colone].id).toggleClass('select_1', true)
                        }
                    } else {
                        press('LEFT', in_app)
                    }
                }
                if(item.control == 'RIGHT') {
                    if(in_app == false){
                    } else if(in_app == "home") {
                        if(sel_colone < max_colone){
                            $("#app_" + map_app[sel_ligne][sel_colone].id).toggleClass('select_1', false)
                            sel_colone = sel_colone + 1
                            $("#app_" + map_app[sel_ligne][sel_colone].id).toggleClass('select_1', true)
                        }
                    } else {
                        press('RIGHT', in_app)
                    }
                }
                if(item.control == 'H') {
                    if(in_app == false){
                        $("#app_" + map_app[sel_ligne][sel_colone].id).toggleClass('select_1', false)
                        $("#menus").css("display", "block");
                        $("#screen_home").css("display", "block");
                        sel_colone = 0;
                        sel_ligne = 0;
                        map_app = [
                            [
                                {select: true, id: 'system'},
                                {select: false, id: 'contact'},
                                {select: false, id: 'message'},
                                {select: false, id: 'appels'}
                            ],
                            [
                                {select: false, id: 'calculatrice'},
                                {select: false, id: 'journal'},
                                {select: false, id: 'notes'},
                                {select: false, id: 'chrome'}
                            ],
                            [
                                {select: false, id: 'custom1'},
                                {select: false, id: 'custom2'},
                                {select: false, id: 'custom3'},
                                {select: false, id: 'custom4'}
                            ]
                        ]
                        $("#app_system").toggleClass('select_1', true)
                        in_app = 'home'
                        $.post('http://phone/openTel', JSON.stringify({}));
                    } else if(in_app == "home"){
                        $("#app_" + map_app[sel_ligne][sel_colone].id).toggleClass('select_1', false)
                        $("#screen_home").css("display", "none");
                        $("#menus").css("display", "none");
                        in_app = false
                        $.post('http://phone/closeTel', JSON.stringify({}));
                    } else {
                        press('CLOSE', in_app)
                        $("#menus").css("display", "none");
                        in_app = false
                        $.post('http://phone/closeTel', JSON.stringify({}));
                    }
                }
            }
      }
    });
    function openHome () {
        $("#app_" + map_app[sel_ligne][sel_colone].id).toggleClass('select_1', false)
        $("#screen_home").css("display", "block");
        sel_colone = 0;
        sel_ligne = 0;
        map_app = [
            [
                {select: true, id: 'system'},
                {select: false, id: 'contact'},
                {select: false, id: 'message'},
                {select: false, id: 'appels'}
            ],
            [
                {select: false, id: 'calculatrice'},
                {select: false, id: 'journal'},
                {select: false, id: 'notes'},
                {select: false, id: 'chrome'}
            ],
            [
                {select: false, id: 'custom1'},
                {select: false, id: 'custom2'},
                {select: false, id: 'custom3'},
                {select: false, id: 'custom4'}
            ]
        ]
        $("#app_system").toggleClass('select_1', true)
        in_app = 'home'
    }


    function press (action, app){
        if(app == "system"){
            app_system(action)
        }
        if(app == "contact"){
            app_contact(action)
        }
        if(app == "message"){
            app_message(action)
        }
        if(app == "appels"){
            app_appels(action)
        }
    }




    function app_system(action){
        if(action == 'OPEN'){
            system_level = 1
            $("#" + system_btns[system_btn_actual]).toggleClass('select_2', false);
            system_btn_actual = 0;
            $("#" + system_btns[system_btn_actual]).toggleClass('select_2', true);
            $("#screen_system").css("display", "block");
            $("#screen_fond").css("display", "none");
        }
        if(action == 'CLOSE'){
            system_level = 1
            $("#" + system_btns[system_btn_actual]).toggleClass('select_2', false);
            system_btn_actual = 0;
            $("#screen_system").css("display", "none");
            $("#screen_fond").css("display", "none");
        }
        if(action == 'LEFT'){
            if(system_level == 1){
                if(system_btn_actual == 0){
                    if(system_zoomvalue > 10){
                        system_zoomvalue = system_zoomvalue - 1
                        document.getElementById('menus').style.setProperty("--main-size", system_zoomvalue / 10)
                        document.getElementById('system_size').innerHTML = system_zoomvalue - 9
                    }
                }
            }
        }
        if(action == 'RIGHT'){
            if(system_level == 1){
                if(system_btn_actual == 0){
                    if(system_zoomvalue < 21){
                        system_zoomvalue = system_zoomvalue + 1
                        document.getElementById('menus').style.setProperty("--main-size", system_zoomvalue / 10)
                        document.getElementById('system_size').innerHTML = system_zoomvalue - 9
                    }
                }
            }
        }
        if(action == 'TOP'){
            if(system_level == 1){
                if(system_btn_actual > 0){
                    $("#" + system_btns[system_btn_actual]).toggleClass('select_2', false);
                    system_btn_actual = system_btn_actual - 1;
                    $("#" + system_btns[system_btn_actual]).toggleClass('select_2', true);
                }
            }
            if(system_level == 2){
                if(system_btn_actual > 1){
                    $("#fond_" + system_btn_actual).toggleClass('select_2', false);
                    system_btn_actual = system_btn_actual - 1;
                    $("#fond_" + system_btn_actual).toggleClass('select_2', true);
                }
            }
        }
        if(action == 'DOWN'){
            if(system_level == 1){
                if(system_btn_actual < 5){
                    $("#" + system_btns[system_btn_actual]).toggleClass('select_2', false);
                    system_btn_actual = system_btn_actual + 1;
                    $("#" + system_btns[system_btn_actual]).toggleClass('select_2', true);
                }
            }
            if(system_level == 2){
                if(system_btn_actual < 8){
                    $("#fond_" + system_btn_actual).toggleClass('select_2', false);
                    system_btn_actual = system_btn_actual + 1;
                    $("#fond_" + system_btn_actual).toggleClass('select_2', true);
                }
            }
        }
        if(action == 'ENTER'){
            if(system_level == 1){
                if(system_btn_actual == 3){
                    $.post('http://phone/resetSMS', JSON.stringify({}));
                    press('CLOSE', in_app)
                    $("#menus").css("display", "none");
                    in_app = false
                }
                if(system_btn_actual == 4){
                    $.post('http://phone/resetTel', JSON.stringify({}));
                    press('CLOSE', in_app)
                    $("#menus").css("display", "none");
                    in_app = false
                }
                if(system_btn_actual == 1){
                    system_level = 2
                    $("#" + system_btns[system_btn_actual]).toggleClass('select_2', false);
                    system_btn_actual = 1
                    $("#fond_" + system_btn_actual).toggleClass('select_2', true);
                    $("#screen_system").css("display", "none");
                    $("#screen_fond").css("display", "block");
                }
                if(system_btn_actual == 5){
                    $.post('http://phone/saveData', JSON.stringify({
                        zoom: system_zoomvalue,
                        fond: fond_nb
                    }));
                    press('CLOSE', in_app)
                    $("#menus").css("display", "none");
                    in_app = false
                }
            } else if(system_level == 2){
                document.getElementById('screen_home').style.backgroundImage = "url('../fonds/fond" + system_btn_actual + ".jpg')"
                fond_nb = system_btn_actual
                system_level = 1
                $("#fond_" + system_btn_actual).toggleClass('select_2', false);
                system_btn_actual = 2
                $("#" + system_btns[system_btn_actual]).toggleClass('select_2', true);
                $("#screen_system").css("display", "block");
                $("#screen_fond").css("display", "none");
            }
            /*$("#" + system_btns[system_btn_actual]).toggleClass('select_2', false);
            system_btn_actual = 0;
            $("#" + system_btns[system_btn_actual]).toggleClass('select_2', true);
            $("#screen_system").css("display", "block");*/
        }
        if(action == 'BACKSPACE'){
            if(system_level == 1){
                $("#" + system_btns[system_btn_actual]).toggleClass('select_2', false);
                system_btn_actual = 0;
                $("#screen_system").css("display", "none");
                openHome()
            }
            if(system_level == 2){
                system_level = 1
                $("#fond_" + system_btn_actual).toggleClass('select_2', false);
                system_btn_actual = 1
                $("#" + system_btns[system_btn_actual]).toggleClass('select_2', true);
                $("#screen_system").css("display", "block");
                $("#screen_fond").css("display", "none");
            }
        }
    }

    function app_contact(action){
        if(action == 'OPEN'){
            /*contact_level = 1
            $("#contact_ct_" + contact_ct_actual).toggleClass('select_2', false);
            contact_ct_actual = 1;
            $("#contact_ct_" + contact_ct_actual).toggleClass('select_2', true);
            $("#screen_contact").css("display", "block");*/
            $.post('http://phone/openContact', JSON.stringify({}));
        }
        if(action == 'CLOSE'){
            contact_level = 1
            $("#contact_ct_" + contact_ct_actual).toggleClass('select_2', false);
            contact_ct_actual = 1;
            $("#screen_contact").css("display", "none");
            $("#screen_contact_2").css("display", "none");
        }
        if(action == 'LEFT'){
            //nothing
        }
        if(action == 'RIGHT'){
            // maybe little menu { delete conversation }
        }
        if(action == 'TOP'){
            if(contact_level == 1){
                if(contact_ct_actual > 1){
                    $("#contact_ct_" + contact_ct_actual).toggleClass('select_2', false);
                    contact_ct_actual = contact_ct_actual - 1;
                    $("#contact_ct_" + contact_ct_actual).toggleClass('select_2', true);
                    document.getElementById("contact_ct_" + contact_ct_actual).scrollIntoView()
                }
            }
            if(contact_level == 2){
                if(contact_btn_actual > 0){
                    $("#" + contact_btns[contact_btn_actual]).toggleClass('ct_over', false);
                    contact_btn_actual = contact_btn_actual - 1;
                    $("#" + contact_btns[contact_btn_actual]).toggleClass('ct_over', true);
                }
            }
        }
        if(action == 'DOWN'){
            if(contact_level == 1){
                if(contact_ct_actual < contact_ct_max){
                    $("#contact_ct_" + contact_ct_actual).toggleClass('select_2', false);
                    contact_ct_actual = contact_ct_actual + 1;
                    $("#contact_ct_" + contact_ct_actual).toggleClass('select_2', true);
                    document.getElementById("contact_ct_" + contact_ct_actual).scrollIntoView()
                }
            }
            if(contact_level == 2){
                if(contact_btn_actual < 4){
                    $("#" + contact_btns[contact_btn_actual]).toggleClass('ct_over', false);
                    contact_btn_actual = contact_btn_actual + 1;
                    $("#" + contact_btns[contact_btn_actual]).toggleClass('ct_over', true);
                }
            }
        }
        if(action == 'ENTER'){
            if(contact_level == 1){
                document.getElementById('con_nom').value = document.getElementById('contact_ct_' + contact_ct_actual).phone_name
                document.getElementById('con_num').value = document.getElementById('contact_ct_' + contact_ct_actual).phone_nb
                contact_level = 2
                contact_btn_actual = 0
                $("#contact_ct_" + contact_ct_actual).toggleClass('select_2', false);
                $("#" + contact_btns[contact_btn_actual]).toggleClass('ct_over', true);
                $("#screen_contact").css("display", "none");
                $("#screen_contact_2").css("display", "block");
            } else if(contact_level == 2){
                if(contact_btn_actual == 0){
                    $.post('http://phone/askContactName', JSON.stringify({
                        value: document.getElementById('con_nom').value
                    }));
                }
                if(contact_btn_actual == 1){
                    $.post('http://phone/askContactNumber', JSON.stringify({
                        value: document.getElementById('con_num').value
                    }));
                }
                if(contact_btn_actual == 2){
                    if(document.getElementById('contact_ct_' + contact_ct_actual).phone_type == 'add'){
                        $.post('http://phone/addContact', JSON.stringify({
                            name: document.getElementById('con_nom').value,
                            phone: document.getElementById('con_num').value
                        }));
                    }
                    if(document.getElementById('contact_ct_' + contact_ct_actual).phone_type == 'modify'){
                        $.post('http://phone/modifyContact', JSON.stringify({
                            original: document.getElementById('contact_ct_' + contact_ct_actual).phone_nb,
                            name: document.getElementById('con_nom').value,
                            phone: document.getElementById('con_num').value
                        }));
                    }
                    contact_level = 1
                    $("#screen_contact_2").css("display", "none");
                    $("#screen_contact").css("display", "block");
                    $("#" + contact_btns[contact_btn_actual]).toggleClass('ct_over', false);
                    contact_btn_actual = 0
                    $("#contact_ct_" + contact_ct_actual).toggleClass('select_2', true);
                }
                if(contact_btn_actual == 3){
                    contact_level = 1
                    $("#screen_contact_2").css("display", "none");
                    $("#screen_contact").css("display", "block");
                    $("#" + contact_btns[contact_btn_actual]).toggleClass('ct_over', false);
                    contact_btn_actual = 0
                    $("#contact_ct_" + contact_ct_actual).toggleClass('select_2', true);
                }
                if(contact_btn_actual == 4){
                    $.post('http://phone/delContact', JSON.stringify({
                        phone: document.getElementById('contact_ct_' + contact_ct_actual).phone_nb
                    }));
                    contact_level = 1
                    contact_ct_actual = 1
                    $("#screen_contact_2").css("display", "none");
                    $("#screen_contact").css("display", "block");
                    $("#contact_ct_" + contact_ct_actual).toggleClass('select_2', true);
                    $("#" + contact_btns[contact_btn_actual]).toggleClass('ct_over', false);
                    contact_btn_actual = 0
                }
            }
        }
        if(action == 'BACKSPACE'){
            if(contact_level == 1){
                $("#contact_ct_" + contact_ct_actual).toggleClass('select_2', false);
                contact_ct_actual = 1;
                $("#screen_contact").css("display", "none");
                openHome()
            }
            if(contact_level == 2){
                contact_level = 1
                $("#screen_contact_2").css("display", "none");
                $("#screen_contact").css("display", "block");
                $("#" + contact_btns[contact_btn_actual]).toggleClass('ct_over', false);
                contact_btn_actual = 0
                $("#contact_ct_" + contact_ct_actual).toggleClass('select_2', true);
            }
        }
    }

    function app_message(action){
        if(action == 'OPEN'){
            /*message_level = 1
            $("#message_ct_" + message_ct_actual).toggleClass('select_2', false);
            message_ct_actual = 1;
            $("#message_ct_" + message_ct_actual).toggleClass('select_2', true);
            $("#screen_message").css("display", "block");*/
            $("#screen_message").css("display", "none");
            $("#screen_message_1").css("display", "none");
            $("#screen_message_2").css("display", "none");
            $("#screen_message_3").css("display", "none");
            $("#screen_message_4").css("display", "none");
            $("#mes_del2").css("display", "none");
            $.post('http://phone/openMessageMenu', JSON.stringify({}));
        }
        if(action == 'CLOSE'){
            message_level = 1
            $("#message_ct_" + message_ct_actual).toggleClass('select_2', false);
            message_ct_actual = 1;
            $("#screen_message").css("display", "none");
            $("#screen_message_1").css("display", "none");
            $("#screen_message_2").css("display", "none");
            $("#screen_message_3").css("display", "none");
            $("#screen_message_4").css("display", "none");
            $("#mes_del2").css("display", "none");
        }
        if(action == 'LEFT'){
            //nothing
            /*if(message_level == 2){
                $.post('http://phone/SendAnonymeMessage', JSON.stringify({
                    phone: document.getElementById('screen_message_2').phone_nb
                }));
            }*/
        }
        if(action == 'RIGHT'){
            // maybe little menu { delete conversation }
            if(message_level == 1){
                if(document.getElementById('message_ct_' + message_ct_actual).phone_type == 'modify'){
                    message_level = 12
                    $("#mes_del1").toggleClass('con13_2', true);
                    $("#mes_del2").css("display", "block");
                    $("#screen_message").css("display", "none");
                    $("#screen_message_1").css("display", "block");
                    document.getElementById("message_ct_2_" + message_ct_actual).scrollIntoView()
                    /*$.post('http://phone/deleteConversation', JSON.stringify({
                        phone: document.getElementById('message_ct_' + message_ct_actual).phone_nb
                    }));*/
                }
            }
            /*if(message_level == 2){
                if (message_scroll > message_max){
                    $.post('http://phone/SendGPSMessage', JSON.stringify({
                        phone: document.getElementById('screen_message_2').phone_nb
                    }));
                } else {
                    $.post('http://phone/DeleteMessage', JSON.stringify({
                        phone: document.getElementById('screen_message_2').phone_nb,
                        msg: document.getElementById("message_nb_" + message_scroll).phone_message,
                        date: document.getElementById("message_nb_" + message_scroll).phone_date
                    }));
                }
            }*/
        }
        if(action == 'TOP'){
            if(message_level == 1){
                if(message_ct_actual > 1){
                    $("#message_ct_" + message_ct_actual).toggleClass('select_2', false);
                    message_ct_actual = message_ct_actual - 1;
                    $("#message_ct_" + message_ct_actual).toggleClass('select_2', true);
                    document.getElementById("message_ct_" + message_ct_actual).scrollIntoView()
                }
            }
            if(message_level == 2){
                if (message_scroll < message_max){
                    $("#message_nb_" + message_scroll).toggleClass('select_4', false);
                    $("#message_nb_0").toggleClass('select_2', false);
                    message_scroll = message_scroll + 1
                    $("#message_nb_" + message_scroll).toggleClass('select_4', true);
                    document.getElementById("message_nb_" + message_scroll).scrollIntoView()
                }
            }
            if(message_level == 3){
                if(message_btn > 4){
                    $("#mes_" + message_btn).toggleClass('select_5', false);
                    message_btn = message_btn - 1;
                    $("#mes_" + message_btn).toggleClass('select_5', true);
                }
            }
            if(message_level == 4){
                if(message_btn > 1){
                    $("#mes_" + message_btn).toggleClass('select_6', false);
                    message_btn = message_btn - 1;
                    $("#mes_" + message_btn).toggleClass('select_6', true);
                }
            }
        }
        if(action == 'DOWN'){
            if(message_level == 1){
                if(message_ct_actual < message_ct_max){
                    $("#message_ct_" + message_ct_actual).toggleClass('select_2', false);
                    message_ct_actual = message_ct_actual + 1;
                    $("#message_ct_" + message_ct_actual).toggleClass('select_2', true);
                    document.getElementById("message_ct_" + message_ct_actual).scrollIntoView()
                }
            }
            if(message_level == 2){
                if (message_scroll > 1){
                    $("#message_nb_" + message_scroll).toggleClass('select_4', false);
                    message_scroll = message_scroll - 1
                    $("#message_nb_" + message_scroll).toggleClass('select_4', true);
                    document.getElementById("message_nb_" + message_scroll).scrollIntoView()
                } else {
                    if(message_scroll == 1){
                        $("#message_nb_1").toggleClass('select_4', false);
                        message_scroll = 0
                        $("#message_nb_0").toggleClass('select_4', true);
                    }
                }
            }
            if(message_level == 3){
                if(message_btn < 5){
                    $("#mes_" + message_btn).toggleClass('select_5', false);
                    message_btn = message_btn + 1;
                    $("#mes_" + message_btn).toggleClass('select_5', true);
                }
            }
            if(message_level == 4){
                if(message_btn < 3){
                    $("#mes_" + message_btn).toggleClass('select_6', false);
                    message_btn = message_btn + 1;
                    $("#mes_" + message_btn).toggleClass('select_6', true);
                }
            }
        }
        if(action == 'ENTER'){
            if(message_level == 1){
                message_level = 2
                $("#message_ct_" + message_ct_actual).toggleClass('select_2', false);
                //$("#screen_message").css("display", "none");
                //$("#screen_message_2").css("display", "block");
                if(document.getElementById('message_ct_' + message_ct_actual).phone_type == 'add'){
                    $.post('http://phone/openNewMessageChat', JSON.stringify({}));
                } else {
                    $.post('http://phone/openMessageChat', JSON.stringify({
                        phone: document.getElementById('message_ct_' + message_ct_actual).phone_nb
                    }));
                }
            /*} else if(message_level == 2){
                if (message_scroll > message_max){
                    $.post('http://phone/SendMessage', JSON.stringify({
                        phone: document.getElementById('screen_message_2').phone_nb
                    }));
                } else {
                    $.post('http://phone/setGPS', JSON.stringify({
                        phone: document.getElementById('screen_message_2').phone_nb,
                        msg: document.getElementById("message_nb_" + message_scroll).phone_message
                    }));
                }
            }*/
            } else if(message_level == 2){
                if (message_scroll == 0){
                    $("#screen_message_2").css("display", "none");
                    $("#screen_message_4").css("display", "block");
                    message_level = 4
                    message_btn = 1
                    $("#mes_" + message_btn).toggleClass('select_6', true);
                } else {
                    $("#screen_message_2").css("display", "none");
                    $("#screen_message_3").css("display", "block");
                    message_level = 3
                    message_btn = 4
                    $("#message_nb_2_" + message_scroll).toggleClass('select_4', true);
                    $("#mes_" + message_btn).toggleClass('select_5', true);
                }
            } else if(message_level == 12){
                message_level = 1
                $("#mes_del1").toggleClass('con13_2', false);
                $("#mes_del2").css("display", "none");
                $("#screen_message").css("display", "block");
                $("#screen_message_1").css("display", "none");
                document.getElementById("message_ct_2_" + message_ct_actual).scrollIntoView()
                $.post('http://phone/deleteConversation', JSON.stringify({
                    phone: document.getElementById('message_ct_' + message_ct_actual).phone_nb
                }));
            } else {
                if (message_btn == 1){
                    $.post('http://phone/SendMessage', JSON.stringify({
                        phone: document.getElementById('screen_message_2').phone_nb,
                        ts: getTimestamp()
                    }));
                    message_level = 2
                    $("#screen_message_4").css("display", "none");
                    $("#screen_message_2").css("display", "block");
                    $("#mes_" + message_btn).toggleClass('select_6', false);
                }
                if (message_btn == 3){
                    /*$.post('http://phone/SendAnonymeMessage', JSON.stringify({
                        phone: document.getElementById('screen_message_2').phone_nb
                    }));*/
                    message_level = 2
                    $("#screen_message_4").css("display", "none");
                    $("#screen_message_2").css("display", "block");
                    $("#mes_" + message_btn).toggleClass('select_6', false);
                }
                if (message_btn == 2){
                    $.post('http://phone/SendGPSMessage', JSON.stringify({
                        phone: document.getElementById('screen_message_2').phone_nb,
                        ts: getTimestamp()
                    }));
                    message_level = 2
                    $("#screen_message_4").css("display", "none");
                    $("#screen_message_2").css("display", "block");
                    $("#mes_" + message_btn).toggleClass('select_6', false);
                }
                if (message_btn == 4){
                    $.post('http://phone/DeleteMessage', JSON.stringify({
                        phone: document.getElementById('screen_message_2').phone_nb,
                        msg: document.getElementById("message_nb_" + message_scroll).phone_message,
                        date: document.getElementById("message_nb_" + message_scroll).phone_date
                    }));
                    message_level = 2
                    $("#screen_message_3").css("display", "none");
                    $("#screen_message_2").css("display", "block");
                    $("#message_nb_2_" + message_scroll).toggleClass('select_4', false);
                    $("#mes_" + message_btn).toggleClass('select_5', false);
                }
                if (message_btn == 5){
                    $.post('http://phone/setGPS', JSON.stringify({
                        phone: document.getElementById('screen_message_2').phone_nb,
                        msg: document.getElementById("message_nb_" + message_scroll).phone_message
                    }));
                    message_level = 2
                    $("#screen_message_3").css("display", "none");
                    $("#screen_message_2").css("display", "block");
                    $("#message_nb_2_" + message_scroll).toggleClass('select_4', false);
                    $("#mes_" + message_btn).toggleClass('select_5', false);
                }
            }
        }
        if(action == 'BACKSPACE'){
            if(message_level == 1){
                $("#message_ct_" + message_ct_actual).toggleClass('select_2', false);
                message_ct_actual = 1;
                $("#screen_message").css("display", "none");
                openHome()
            }
            if(message_level == 2){
                message_level = 1
                $("#screen_message_2").css("display", "none");
                $("#screen_message").css("display", "block");
                $("#message_nb_" + message_scroll).toggleClass('select_4', false);
                $("#message_nb_0").toggleClass('select_2', false);
                $("#message_ct_" + message_ct_actual).toggleClass('select_2', true);
                $.post('http://phone/openMessageMenu', JSON.stringify({}));
            }
            if(message_level == 3){
                message_level = 2
                $("#screen_message_3").css("display", "none");
                $("#screen_message_2").css("display", "block");
                $("#message_nb_2_" + message_scroll).toggleClass('select_4', false);
                $("#mes_" + message_btn).toggleClass('select_5', false);
            }
            if(message_level == 4){
                message_level = 2
                $("#screen_message_4").css("display", "none");
                $("#screen_message_2").css("display", "block");
                $("#mes_" + message_btn).toggleClass('select_6', false);
            }
            if(message_level == 12){
                message_level = 1
                $("#mes_del1").toggleClass('con13_2', false);
                $("#mes_del2").css("display", "none");
                $("#screen_message").css("display", "block");
                $("#screen_message_1").css("display", "none");
            }
        }
    }

    function app_appels(action){
        if(action == 'OPEN'){
            appels_level = 1
            $("#appels_ls_" + appels_ct_actual).toggleClass('select_2', false);
            appels_ct_actual = 1;
            $("#appels_ls_" + appels_ct_actual).toggleClass('select_2', true);
            $("#screen_appels").css("display", "block");
            $("#screen_appels_police").css("display", "none");
            $("#screen_appels_sheriff").css("display", "none");
            $("#screen_appels_ambulance").css("display", "none");
            $("#screen_appels_pompier").css("display", "none");
            $("#screen_appels_mecano").css("display", "none");
            $("#screen_appels_taxi").css("display", "none");
        }
        if(action == 'CLOSE'){
            appels_level = 1
            $("#appels_ls_" + appels_ct_actual).toggleClass('select_2', false);
            appels_ct_actual = 1;
            $("#screen_appels").css("display", "none");
            $("#screen_appels_police").css("display", "none");
            $("#screen_appels_sheriff").css("display", "none");
            $("#screen_appels_ambulance").css("display", "none");
            $("#screen_appels_pompier").css("display", "none");
            $("#screen_appels_mecano").css("display", "none");
            $("#screen_appels_taxi").css("display", "none");
        }
        if(action == 'LEFT'){
            //nothing
        }
        if(action == 'RIGHT'){
            // maybe little menu { delete conversation }
        }
        if(action == 'TOP'){
            if(appels_level == 1){
                if(appels_ct_actual > 1){
                    $("#appels_ls_" + appels_ct_actual).toggleClass('select_2', false);
                    appels_ct_actual = appels_ct_actual - 1;
                    $("#appels_ls_" + appels_ct_actual).toggleClass('select_2', true);
                }
            } else {
                if(appels_ct_actual > 1){
                    $("#appels_ls_" + appels_level + "_" + appels_ct_actual).toggleClass('select_2', false);
                    appels_ct_actual = appels_ct_actual - 1;
                    $("#appels_ls_" + appels_level + "_" + appels_ct_actual).toggleClass('select_2', true);
                }
            }
        }
        if(action == 'DOWN'){
            if(appels_level == 1){
                if(appels_ct_actual < 6){
                    $("#appels_ls_" + appels_ct_actual).toggleClass('select_2', false);
                    appels_ct_actual = appels_ct_actual + 1;
                    $("#appels_ls_" + appels_ct_actual).toggleClass('select_2', true);
                }
            }
            if(appels_level == 2){
                if(appels_ct_actual < 7){
                    $("#appels_ls_2_" + appels_ct_actual).toggleClass('select_2', false);
                    appels_ct_actual = appels_ct_actual + 1;
                    $("#appels_ls_2_" + appels_ct_actual).toggleClass('select_2', true);
                }
            }
            if(appels_level == 3){
                if(appels_ct_actual < 7){
                    $("#appels_ls_3_" + appels_ct_actual).toggleClass('select_2', false);
                    appels_ct_actual = appels_ct_actual + 1;
                    $("#appels_ls_3_" + appels_ct_actual).toggleClass('select_2', true);
                }
            }
            if(appels_level == 4){
                if(appels_ct_actual < 7){
                    $("#appels_ls_4_" + appels_ct_actual).toggleClass('select_2', false);
                    appels_ct_actual = appels_ct_actual + 1;
                    $("#appels_ls_4_" + appels_ct_actual).toggleClass('select_2', true);
                }
            }
            if(appels_level == 5){
                if(appels_ct_actual < 7){
                    $("#appels_ls_5_" + appels_ct_actual).toggleClass('select_2', false);
                    appels_ct_actual = appels_ct_actual + 1;
                    $("#appels_ls_5_" + appels_ct_actual).toggleClass('select_2', true);
                }
            }
            if(appels_level == 6){
                if(appels_ct_actual < 6){
                    $("#appels_ls_6_" + appels_ct_actual).toggleClass('select_2', false);
                    appels_ct_actual = appels_ct_actual + 1;
                    $("#appels_ls_6_" + appels_ct_actual).toggleClass('select_2', true);
                }
            }
            if(appels_level == 7){
                if(appels_ct_actual < 6){
                    $("#appels_ls_7_" + appels_ct_actual).toggleClass('select_2', false);
                    appels_ct_actual = appels_ct_actual + 1;
                    $("#appels_ls_7_" + appels_ct_actual).toggleClass('select_2', true);
                }
            }
        }
        if(action == 'ENTER'){
            if(appels_level == 1){
                $("#appels_ls_" + appels_ct_actual).toggleClass('select_2', false);
                $("#screen_appels").css("display", "none");

                if(appels_ct_actual == 1){
                    appels_level = 2
                    $("#screen_appels_police").css("display", "block");
                }
                if(appels_ct_actual == 2){
                    appels_level = 3
                    $("#screen_appels_sheriff").css("display", "block");
                }
                if(appels_ct_actual == 3){
                    appels_level = 4
                    $("#screen_appels_ambulance").css("display", "block");
                }
                if(appels_ct_actual == 4){
                    appels_level = 5
                    $("#screen_appels_pompier").css("display", "block");
                }
                if(appels_ct_actual == 5){
                    appels_level = 6
                    $("#screen_appels_mecano").css("display", "block");
                }
                if(appels_ct_actual == 6){
                    appels_level = 7
                    $("#screen_appels_taxi").css("display", "block");
                }
                appels_ct_actual = 1
            } else {
                if(appels_level == 2){
                    $.post('http://phone/Appel', JSON.stringify({
                        service: 'police',
                        raison: document.getElementById('appels_ls_2_' + appels_ct_actual).innerHTML
                    }));
                    app_appels('CLOSE')
                    in_app = 'home'
                    openHome()
                }
                if(appels_level == 3){
                    $.post('http://phone/Appel', JSON.stringify({
                        service: 'sheriff',
                        raison: document.getElementById('appels_ls_3_' + appels_ct_actual).innerHTML
                    }));
                    app_appels('CLOSE')
                    in_app = 'home'
                    openHome()
                }
                if(appels_level == 4){
                    $.post('http://phone/Appel', JSON.stringify({
                        service: 'ambulance',
                        raison: document.getElementById('appels_ls_4_' + appels_ct_actual).innerHTML
                    }));
                    app_appels('CLOSE')
                    in_app = 'home'
                    openHome()
                }
                if(appels_level == 5){
                    $.post('http://phone/Appel', JSON.stringify({
                        service: 'pompier',
                        raison: document.getElementById('appels_ls_5_' + appels_ct_actual).innerHTML
                    }));
                    app_appels('CLOSE')
                    in_app = 'home'
                    openHome()
                }
                if(appels_level == 6){
                    $.post('http://phone/Appel', JSON.stringify({
                        service: 'mecano',
                        raison: document.getElementById('appels_ls_6_' + appels_ct_actual).innerHTML
                    }));
                    app_appels('CLOSE')
                    in_app = 'home'
                    openHome()
                }
                if(appels_level == 7){
                    $.post('http://phone/Appel', JSON.stringify({
                        service: 'taxi',
                        raison: document.getElementById('appels_ls_7_' + appels_ct_actual).innerHTML
                    }));
                    app_appels('CLOSE')
                    in_app = 'home'
                    openHome()
                }
            }
        }
        if(action == 'BACKSPACE'){
            if(appels_level == 1){
                $("#appels_ls_" + appels_ct_actual).toggleClass('select_2', false);
                appels_ct_actual = 1;
                $("#screen_appels").css("display", "none");
                openHome()
            }
            if(appels_level == 2){
                appels_level = 1
                $("#screen_appels").css("display", "block");
                $("#screen_appels_police").css("display", "none");
                $("#appels_ls_" + appels_ct_actual).toggleClass('select_2', true);
            }
            if(appels_level == 3){
                appels_level = 1
                $("#screen_appels").css("display", "block");
                $("#screen_appels_sheriff").css("display", "none");
                $("#appels_ls_" + appels_ct_actual).toggleClass('select_2', true);
            }
            if(appels_level == 4){
                appels_level = 1
                $("#screen_appels").css("display", "block");
                $("#screen_appels_ambulance").css("display", "none");
                $("#appels_ls_" + appels_ct_actual).toggleClass('select_2', true);
            }
            if(appels_level == 5){
                appels_level = 1
                $("#screen_appels").css("display", "block");
                $("#screen_appels_pompier").css("display", "none");
                $("#appels_ls_" + appels_ct_actual).toggleClass('select_2', true);
            }
            if(appels_level == 6){
                appels_level = 1
                $("#screen_appels").css("display", "block");
                $("#screen_appels_mecano").css("display", "none");
                $("#appels_ls_" + appels_ct_actual).toggleClass('select_2', true);
            }
            if(appels_level == 7){
                appels_level = 1
                $("#screen_appels").css("display", "block");
                $("#screen_appels_taxi").css("display", "none");
                $("#appels_ls_" + appels_ct_actual).toggleClass('select_2', true);
            }
        }
    }


    var coma_level = 0
    var coma_btn_1 = 1
    var coma_btn_2 = 1
    function comaScreen(action){
        if(action == 'H'){
            if(coma_level == 0){
                coma_level = 1
                coma_btn_1 = 1
                coma_btn_2 = 1
                $("#coma_btn_11").toggleClass('button_4', false);
                $("#coma_btn_11").toggleClass('button_4_2', true);
                $("#coma_btn_21").toggleClass('button_5', true);
                $("#coma_btn_21").toggleClass('button_5_2', false);
                $("#coma_btn_12").toggleClass('button_4', false);
                $("#coma_btn_12").toggleClass('button_4_2', true);
                $("#coma_btn_22").toggleClass('button_5', true);
                $("#coma_btn_22").toggleClass('button_5_2', false);

                $("#menus").css("display", "block");
                $("#screen_coma").css("display", "block");
                $("#screen_coma2").css("display", "none");
            } else {
                coma_level = 0
                coma_btn_1 = 1
                coma_btn_2 = 1
                $("#coma_btn_11").toggleClass('button_4', false);
                $("#coma_btn_11").toggleClass('button_4_2', true);
                $("#coma_btn_21").toggleClass('button_5', true);
                $("#coma_btn_21").toggleClass('button_5_2', false);
                $("#coma_btn_12").toggleClass('button_4', false);
                $("#coma_btn_12").toggleClass('button_4_2', true);
                $("#coma_btn_22").toggleClass('button_5', true);
                $("#coma_btn_22").toggleClass('button_5_2', false);

                $("#menus").css("display", "none");
                $("#screen_coma").css("display", "none");
                $("#screen_coma2").css("display", "none");
            }
        }
        if(action == 'ENTER'){
            if(coma_level == 1){
                if(coma_btn_1 == 1){
                    $.post('http://phone/callComa', JSON.stringify({}));
                    coma_level = 0
                    coma_btn_1 = 1
                    coma_btn_2 = 1
                    $("#coma_btn_11").toggleClass('button_4', false);
                    $("#coma_btn_11").toggleClass('button_4_2', true);
                    $("#coma_btn_21").toggleClass('button_5', true);
                    $("#coma_btn_21").toggleClass('button_5_2', false);
                    $("#coma_btn_12").toggleClass('button_4', false);
                    $("#coma_btn_12").toggleClass('button_4_2', true);
                    $("#coma_btn_22").toggleClass('button_5', true);
                    $("#coma_btn_22").toggleClass('button_5_2', false);

                    $("#coma_btn_3").toggleClass('con11', false);
                    $("#coma_btn_3").toggleClass('con12', true);
                    $("#coma_btn_4").toggleClass('con11', true);
                    $("#coma_btn_4").toggleClass('con12', false);

                    $("#menus").css("display", "none");
                    $("#screen_coma").css("display", "none");
                    $("#screen_coma2").css("display", "none");
                } else {
                    coma_level = 2
                    coma_btn_2 = 1
                    $("#coma_btn_3").toggleClass('con11', false);
                    $("#coma_btn_3").toggleClass('con12', true);
                    $("#coma_btn_4").toggleClass('con11', true);
                    $("#coma_btn_4").toggleClass('con12', false);

                    $("#screen_coma").css("display", "none");
                    $("#screen_coma2").css("display", "block");
                }

            } else if(coma_level == 2) {
                if(coma_btn_2 == 1){
                    coma_level = 1
                    coma_btn_1 = 1
                    coma_btn_2 = 1
                    $("#coma_btn_11").toggleClass('button_4', false);
                    $("#coma_btn_11").toggleClass('button_4_2', true);
                    $("#coma_btn_21").toggleClass('button_5', true);
                    $("#coma_btn_21").toggleClass('button_5_2', false);
                    $("#coma_btn_12").toggleClass('button_4', false);
                    $("#coma_btn_12").toggleClass('button_4_2', true);
                    $("#coma_btn_22").toggleClass('button_5', true);
                    $("#coma_btn_22").toggleClass('button_5_2', false);

                    $("#coma_btn_3").toggleClass('con11', false);
                    $("#coma_btn_3").toggleClass('con12', true);
                    $("#coma_btn_4").toggleClass('con11', true);
                    $("#coma_btn_4").toggleClass('con12', false);

                    $("#screen_coma").css("display", "block");
                    $("#screen_coma2").css("display", "none");
                } else {
                    $.post('http://phone/respawn', JSON.stringify({}));
                    coma_level = 0
                    coma_btn_1 = 1
                    coma_btn_2 = 1
                    $("#coma_btn_3").toggleClass('con11', false);
                    $("#coma_btn_3").toggleClass('con12', true);
                    $("#coma_btn_4").toggleClass('con11', true);
                    $("#coma_btn_4").toggleClass('con12', false);

                    $("#menus").css("display", "none");
                    $("#screen_coma").css("display", "none");
                    $("#screen_coma2").css("display", "none");
                }
            }
        }
        if(action == 'TOP'){
            if(coma_level == 1){
                coma_btn_1 = 1
                coma_btn_2 = 1
                $("#coma_btn_11").toggleClass('button_4', false);
                $("#coma_btn_11").toggleClass('button_4_2', true);
                $("#coma_btn_21").toggleClass('button_5', true);
                $("#coma_btn_21").toggleClass('button_5_2', false);
                $("#coma_btn_12").toggleClass('button_4', false);
                $("#coma_btn_12").toggleClass('button_4_2', true);
                $("#coma_btn_22").toggleClass('button_5', true);
                $("#coma_btn_22").toggleClass('button_5_2', false);
            } else if(coma_level == 2) {
                coma_btn_2 = 1
                $("#coma_btn_3").toggleClass('con11', false);
                $("#coma_btn_3").toggleClass('con12', true);
                $("#coma_btn_4").toggleClass('con11', true);
                $("#coma_btn_4").toggleClass('con12', false);
            }
        }
        if(action == 'DOWN'){
            if(coma_level == 1){
                coma_btn_1 = 2
                coma_btn_2 = 1
                $("#coma_btn_11").toggleClass('button_4', true);
                $("#coma_btn_11").toggleClass('button_4_2', false);
                $("#coma_btn_21").toggleClass('button_5', false);
                $("#coma_btn_21").toggleClass('button_5_2', true);
                $("#coma_btn_12").toggleClass('button_4', true);
                $("#coma_btn_12").toggleClass('button_4_2', false);
                $("#coma_btn_22").toggleClass('button_5', false);
                $("#coma_btn_22").toggleClass('button_5_2', true);
            } else if(coma_level == 2) {
                coma_btn_2 = 2
                $("#coma_btn_3").toggleClass('con11', true);
                $("#coma_btn_3").toggleClass('con12', false);
                $("#coma_btn_4").toggleClass('con11', false);
                $("#coma_btn_4").toggleClass('con12', true);
            }
        }
        if(action == 'BACKSPACE'){
            if(coma_level == 1){
                coma_level = 0
                coma_btn_1 = 1
                coma_btn_2 = 1
                $("#coma_btn_11").toggleClass('button_4', false);
                $("#coma_btn_11").toggleClass('button_4_2', true);
                $("#coma_btn_21").toggleClass('button_5', true);
                $("#coma_btn_21").toggleClass('button_5_2', false);
                $("#coma_btn_12").toggleClass('button_4', false);
                $("#coma_btn_12").toggleClass('button_4_2', true);
                $("#coma_btn_22").toggleClass('button_5', true);
                $("#coma_btn_22").toggleClass('button_5_2', false);

                $("#coma_btn_3").toggleClass('con11', false);
                $("#coma_btn_3").toggleClass('con12', true);
                $("#coma_btn_4").toggleClass('con11', true);
                $("#coma_btn_4").toggleClass('con12', false);

                $("#menus").css("display", "none");
                $("#screen_coma").css("display", "none");
                $("#screen_coma2").css("display", "none");
            } else if(coma_level == 2) {
                coma_level = 1
                coma_btn_1 = 1
                coma_btn_2 = 1
                $("#coma_btn_11").toggleClass('button_4', false);
                $("#coma_btn_11").toggleClass('button_4_2', true);
                $("#coma_btn_21").toggleClass('button_5', true);
                $("#coma_btn_21").toggleClass('button_5_2', false);
                $("#coma_btn_12").toggleClass('button_4', false);
                $("#coma_btn_12").toggleClass('button_4_2', true);
                $("#coma_btn_22").toggleClass('button_5', true);
                $("#coma_btn_22").toggleClass('button_5_2', false);

                $("#coma_btn_3").toggleClass('con11', false);
                $("#coma_btn_3").toggleClass('con12', true);
                $("#coma_btn_4").toggleClass('con11', true);
                $("#coma_btn_4").toggleClass('con12', false);

                $("#screen_coma").css("display", "block");
                $("#screen_coma2").css("display", "none");
            }
        }
    }
    // Handle Form Submits
    /*
    $("#withdraw-form").submit(function(e) {
        e.preventDefault();
        $.post('http://banking/withdrawSubmit', JSON.stringify({
            amount: $("#withdraw-form #amount").val()
        }));
        $("#withdraw-form #amount").prop('disabled', true)
        $("#withdraw-form #submit").css('display', 'none')
        setTimeout(function(){
          $("#withdraw-form #amount").prop('disabled', false)
          $("#withdraw-form #submit").css('display', 'block')
        }, 2000)

        $("#withdraw-form #amount").val('')
    });
    $("#deposit-form").submit(function(e) {
        e.preventDefault();
        $.post('http://banking/depositSubmit', JSON.stringify({
            amount: $("#deposit-form #amount").val()
        }));
        $("#deposit-form #amount").prop('disabled', true)
        $("#deposit-form #submit").css('display', 'none')
        setTimeout(function(){
          $("#deposit-form #amount").prop('disabled', false)
          $("#deposit-form #submit").css('display', 'block')
        }, 2000)
        $("#deposit-form #amount").val('')
    });
    $("#transfer-form").submit(function(e) {
        e.preventDefault();
        $.post('http://banking/transferSubmit', JSON.stringify({
            amount: $("#transfer-form #amount").val(),
            toPlayer: $("#transfer-form #toPlayer").val()
        }));
        $("#transfer-form #amount").prop('disabled', true)
        $("#transfer-form #toPlayer").prop('disabled', true)
        $("#transfer-form #submit").css('display', 'none')
        setTimeout(function(){
          $("#transfer-form #amount").prop('disabled', false)
          $("#transfer-form #submit").css('display', 'block')
          $("#transfer-form #toPlayer").prop('disabled', false)
        }, 2000)
        $("#transfer-form #amount").val('')
        $("#transfer-form #toPlayer").val('')
    });*/
  });

