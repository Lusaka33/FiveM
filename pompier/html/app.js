document.getElementById("garage_menu_1").style.display = "none"
document.getElementById("job_menu_1").style.display = "none"
document.getElementById("inter_menu_1").style.display = "none"
document.getElementById("skin_menu_1").style.display = "none"
document.getElementById("acc_menu_1").style.display = "none"
document.getElementById("tool_menu_1").style.display = "none"
document.getElementById("action_menu_1").style.display = "none"
document.getElementById("tp_menu_1").style.display = "none"
document.getElementById("gps_menu_1").style.display = "none"
document.getElementById("mission_menu_1").style.display = "none"
document.getElementById("mission_menu_2").style.display = "none"

var menu_garage1 = [
    {},
    { id: 'garage_delete' },
    { id: 'garage_vl' },
    { id: 'garage_vsav' },
    { id: 'garage_fpt' },
    { id: 'garage_ccgc' },
    { id: 'garage_lifeguard' },
    { id: 'garage_quad' },
    { id: 'garage_beson' },
    { id: 'garage_heli' },
    { id: 'garage_heli2' },
    { id: 'garage_heli3' },
    { id: 'garage_baller1' },
    { id: 'garage_baller2' },
    { id: 'garage_taco' },
    { id: 'garage_bus' }
]

var limit_garage1 = 16

var menu_job1 = [
    {},
    { id: 'job_inter' },
    { id: 'job_skin' },
    { id: 'job_acc' },
    { id: 'job_tool' },
    { id: 'job_action' },
    { id: 'job_tp' },
    { id: 'job_gps' },
    { id: 'job_mission' }
]

var limit_job1 = 9

var menu_inter1 = [
    {},
    { id: 'inter_see' },
    { id: 'inter_start' },
    { id: 'inter_end' }
]

var limit_inter1 = 4

var menu_skin1 = [
    {},
    { id: 'skin_f1' },
    { id: 'skin_medic' },
    { id: 'skin_lgH' },
    { id: 'skin_lgF' },
    { id: 'skin_custom1' },
    { id: 'skin_custom2' }
]

var limit_skin1 = 7

var menu_acc1 = [
    {},
    { id: 'acc_f1sale' },
    { id: 'acc_f1ari' },
    { id: 'acc_medlogo' },
    { id: 'acc_medgilet' },
    { id: 'acc_medgants' },
    { id: 'acc_medmatos' },
    { id: 'acc_LGHhaut' },
    { id: 'acc_LGHceinture' },
    { id: 'acc_LGHgilet' },
    { id: 'acc_LGFhaut' }
]

var limit_acc1 = 11

var menu_tool1 = [
    {},
    { id: 'tool_all' },
    { id: 'tool_crowbar' },
    { id: 'tool_hatchet' },
    { id: 'tool_flashlight' },
    { id: 'tool_molotov' },
    { id: 'tool_fireextinguisher' },
    { id: 'tool_flare' }
]

var limit_tool1 = 8

var menu_action1 = [
    {},
    { id: 'action_REMmarkeur' },
    { id: 'action_stabiliser' },
    { id: 'action_soigner' },
    { id: 'action_reanimer' },
    { id: 'action_saveV' },
    { id: 'action_gotoV' },
    { id: 'action_tpAllV' },
    { id: 'action_leaveAllV' },
    { id: 'action_opendoor' },
    { id: 'action_Newcone' },
    { id: 'action_Delcone' }
]

var limit_action1 = 12

var menu_tp1 = [
    {},
    { id: 'tp_caserne' },
    { id: 'tp_fbi' },
    { id: 'tp_heli' }
]

var limit_tp1 = 4

var menu_gps1 = [
    {},
    { id: 'gps_caserne' },
    { id: 'gps_hopital' },
    { id: 'gps_commisariat' },
    { id: 'gps_fbi' },
    { id: 'gps_depanneur' }
]

var limit_gps1 = 6

var menu_mission1 = [
    {},
    { id: 'mission_1' },
    { id: 'mission_2' },
    { id: 'mission_3' },
    { id: 'mission_4' },
    { id: 'mission_5' },
    { id: 'mission_6' },
    { id: 'mission_7' },
    { id: 'mission_8' },
    { id: 'mission_9' },
    { id: 'mission_10' }
]

var limit_mission1 = 11

var menu_mission2 = [
    {},
    { id: 'mission_inter' },
    { id: 'mission_on' },
    { id: 'mission_off' }
]

var limit_mission2 = 4




window.addEventListener("message", function(event){
    var action = event.data.action
    if(action == "open_garage"){
        document.getElementById("garage_menu_1").style.display = "block"
    }
    if(action == "close_garage"){
        document.getElementById("garage_menu_1").style.display = "none"
    }
    if(action == "play_bip"){
        document.getElementById("bip_audio").volume = 0.5;
        document.getElementById("bip_audio").play()
    }
    /*if(action == "modif_inter"){
        var html = "<h1>MENU INTER</h1>"
        //  inter = <ID>
        for (var i = 1; i < event.data.inters.length; i++) {
            html = html + "<div class='mbtn' id='inter_" + event.data.inters[i] + "'>Inter " + event.data.inters[i] + "</div>"
            
        }
        document.getElementById("inter_menu_1").innerHTML = html
    }*/
    if(action == "change_acc"){
        document.getElementById(event.data.id).innerHTML = event.data.text
    }
    if(action == "change_button"){
        if(event.data.menu == "menu_garage1"){
            for (var i = 1; i < limit_garage1; i++) {
                document.getElementById(menu_garage1[i].id).style.backgroundColor = "transparent"
                document.getElementById(menu_garage1[i].id).style.color = "white"
            }
            document.getElementById(menu_garage1[event.data.btn].id).style.backgroundColor = "white"
            document.getElementById(menu_garage1[event.data.btn].id).style.color = "black"
        }
        if(event.data.menu == "menu_job1"){
            for (var i = 1; i < limit_job1; i++) {
                document.getElementById(menu_job1[i].id).style.backgroundColor = "transparent"
                document.getElementById(menu_job1[i].id).style.color = "white"
            }
            document.getElementById(menu_job1[event.data.btn].id).style.backgroundColor = "white"
            document.getElementById(menu_job1[event.data.btn].id).style.color = "black"
        }
        if(event.data.menu == "menu_inter1"){
            for (var i = 1; i < limit_inter1; i++) {
                document.getElementById(menu_inter1[i].id).style.backgroundColor = "transparent"
                document.getElementById(menu_inter1[i].id).style.color = "white"
            }
            document.getElementById(menu_inter1[event.data.btn].id).style.backgroundColor = "white"
            document.getElementById(menu_inter1[event.data.btn].id).style.color = "black"
        }
        if(event.data.menu == "menu_skin1"){
            for (var i = 1; i < limit_skin1; i++) {
                document.getElementById(menu_skin1[i].id).style.backgroundColor = "transparent"
                document.getElementById(menu_skin1[i].id).style.color = "white"
            }
            document.getElementById(menu_skin1[event.data.btn].id).style.backgroundColor = "white"
            document.getElementById(menu_skin1[event.data.btn].id).style.color = "black"
        }
        if(event.data.menu == "menu_acc1"){
            for (var i = 1; i < limit_acc1; i++) {
                document.getElementById(menu_acc1[i].id).style.backgroundColor = "transparent"
                document.getElementById(menu_acc1[i].id).style.color = "white"
            }
            document.getElementById(menu_acc1[event.data.btn].id).style.backgroundColor = "white"
            document.getElementById(menu_acc1[event.data.btn].id).style.color = "black"
        }
        if(event.data.menu == "menu_tool1"){
            for (var i = 1; i < limit_tool1; i++) {
                document.getElementById(menu_tool1[i].id).style.backgroundColor = "transparent"
                document.getElementById(menu_tool1[i].id).style.color = "white"
            }
            document.getElementById(menu_tool1[event.data.btn].id).style.backgroundColor = "white"
            document.getElementById(menu_tool1[event.data.btn].id).style.color = "black"
        }
        if(event.data.menu == "menu_tp1"){
            for (var i = 1; i < limit_tp1; i++) {
                document.getElementById(menu_tp1[i].id).style.backgroundColor = "transparent"
                document.getElementById(menu_tp1[i].id).style.color = "white"
            }
            document.getElementById(menu_tp1[event.data.btn].id).style.backgroundColor = "white"
            document.getElementById(menu_tp1[event.data.btn].id).style.color = "black"
        }
        if(event.data.menu == "menu_gps1"){
            for (var i = 1; i < limit_gps1; i++) {
                document.getElementById(menu_gps1[i].id).style.backgroundColor = "transparent"
                document.getElementById(menu_gps1[i].id).style.color = "white"
            }
            document.getElementById(menu_gps1[event.data.btn].id).style.backgroundColor = "white"
            document.getElementById(menu_gps1[event.data.btn].id).style.color = "black"
        }
        if(event.data.menu == "menu_mission1"){
            for (var i = 1; i < limit_mission1; i++) {
                document.getElementById(menu_mission1[i].id).style.backgroundColor = "transparent"
                document.getElementById(menu_mission1[i].id).style.color = "white"
            }
            document.getElementById(menu_mission1[event.data.btn].id).style.backgroundColor = "white"
            document.getElementById(menu_mission1[event.data.btn].id).style.color = "black"
        }
        if(event.data.menu == "menu_mission2"){
            for (var i = 1; i < limit_mission2; i++) {
                document.getElementById(menu_mission2[i].id).style.backgroundColor = "transparent"
                document.getElementById(menu_mission2[i].id).style.color = "white"
            }
            document.getElementById(menu_mission2[event.data.btn].id).style.backgroundColor = "white"
            document.getElementById(menu_mission2[event.data.btn].id).style.color = "black"
        }
        if(event.data.menu == "menu_action1"){
            for (var i = 1; i < limit_action1; i++) {
                document.getElementById(menu_action1[i].id).style.backgroundColor = "transparent"
                document.getElementById(menu_action1[i].id).style.color = "white"
            }
            document.getElementById(menu_action1[event.data.btn].id).style.backgroundColor = "white"
            document.getElementById(menu_action1[event.data.btn].id).style.color = "black"
        }
    }


    if(action == "open_job_menu"){
        document.getElementById("job_menu_1").style.display = "block"
    }
    if(action == "close_job_menu"){
        document.getElementById("job_menu_1").style.display = "none"
    }

    if(action == "open_inter_menu"){
        document.getElementById("inter_menu_1").style.display = "block"
    }
    if(action == "close_inter_menu"){
        document.getElementById("inter_menu_1").style.display = "none"
    }

    if(action == "open_skin_menu"){
        document.getElementById("skin_menu_1").style.display = "block"
    }
    if(action == "close_skin_menu"){
        document.getElementById("skin_menu_1").style.display = "none"
    }

    if(action == "open_acc_menu"){
        document.getElementById("acc_menu_1").style.display = "block"
    }
    if(action == "close_acc_menu"){
        document.getElementById("acc_menu_1").style.display = "none"
    }

    if(action == "open_tool_menu"){
        document.getElementById("tool_menu_1").style.display = "block"
    }
    if(action == "close_tool_menu"){
        document.getElementById("tool_menu_1").style.display = "none"
    }

    if(action == "open_tp_menu"){
        document.getElementById("tp_menu_1").style.display = "block"
    }
    if(action == "close_tp_menu"){
        document.getElementById("tp_menu_1").style.display = "none"
    }

    if(action == "open_gps_menu"){
        document.getElementById("gps_menu_1").style.display = "block"
    }
    if(action == "close_gps_menu"){
        document.getElementById("gps_menu_1").style.display = "none"
    }

    if(action == "open_gps_menu"){
        document.getElementById("gps_menu_1").style.display = "block"
    }
    if(action == "close_gps_menu"){
        document.getElementById("gps_menu_1").style.display = "none"
    }

    if(action == "open_mission1_menu"){
        document.getElementById("mission_menu_1").style.display = "block"
    }
    if(action == "close_mission1_menu"){
        document.getElementById("mission_menu_1").style.display = "none"
    }

    if(action == "open_mission2_menu"){
        document.getElementById("mission_menu_2").style.display = "block"
    }
    if(action == "close_mission2_menu"){
        document.getElementById("mission_menu_2").style.display = "none"
    }

    if(action == "open_action_menu"){
        document.getElementById("action_menu_1").style.display = "block"
    }
    if(action == "close_action_menu"){
        document.getElementById("action_menu_1").style.display = "none"
    }
})