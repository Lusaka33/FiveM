ESX = nil
local PlayerData = {}

Citizen.CreateThread(function()
    while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

local job_position = {
    service = { x = 1208.800537, y = -1481.0589599, z = 34.8595},
    bureau = { x = 1193, y = -1474, z = 35 },
    garage1 = {x = 1200.693603, y = -1492.809692, z = 34.69257},
    garagespawn1 = {x = tonumber("1198.006"), y = tonumber("-1496.005"), z = tonumber("35.2")},
    helispawn1 = {x = tonumber("1180.14"), y = tonumber("-1474.65"), z = tonumber("40.7")},
    garage2 = {x = -1197, y = -1809, z = 4},
    garagespawn2 = {x = tonumber("-1190.01"), y = tonumber("-1808.01"), z = tonumber("4.1")},
    helispawn2 = {x = tonumber("-1210.01"), y = tonumber("-1799.01"), z = tonumber("4.1")}
}
local grades = {
    {id = 1, name = 'formation', abr = 'Frm'},
    {id = 2, name = 'stagiaire', abr = 'Stag'},
    {id = 3, name = 'sapeur', abr = 'Sap'},
    {id = 4, name = 'caporal', abr = 'Cap'},
    {id = 5, name = 'lieutenant', abr = 'Ltn'},
    {id = 6, name = 'chef', abr = 'Chef'}
}

local Appels = {}
local mycall = 0

RegisterNetEvent("LSFD:createBlip")
AddEventHandler("LSFD:createBlip", function(type, x, y, z)
	local blip = AddBlipForCoord(x, y, z)
	SetBlipSprite(blip, type)
	SetBlipScale(blip, 1.001)
	SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, 17)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Caserne de pompier")
    EndTextCommandSetBlipName(blip)
end)

local plate = "CALL 911"
RegisterNetEvent('plate:setPlate')
AddEventHandler('plate:setPlate', function(a)--N3MTV
    plate = "LSFD" .. a
end)

local in_service = false
local my_grade = ""
local missionData = {
    { active = false }, -- 1  OK
    { active = false }, -- 2
    { active = false }, -- 3  OK
    { active = false }, -- 4
    { active = false }, -- 5
    { active = false }, -- 6
    { active = false }, -- 7
    { active = false }, -- 8
    { active = false }, -- 9
    { active = false }, -- 10
    { active = false }
}

local acc_data = {
    F1sale = false,
    F1ari = false,
    MEDlogo = true,
    MEDgilet = false,
    MEDgants = false,
    MEDmatos = false,
    LGHhaut = false,
    LGHceinture = true,
    LGHgilet = false,
    LGFhaut = false
}

local patient_actuel = nil
AddEventHandler('dispatch:SendToJobID', function(a)
    patient_actuel = a
end)

RegisterNetEvent('LSFD:updatecall')
AddEventHandler('LSFD:updatecall', function(list)
    Appels = list
    if mycall > 0 then
        local isExist = false
        for nb,value in pairs(Appels) do
            if value.id == mycall then
                isExist = true
            end
        end
        if isExist == false then
            ESX.ShowNotification("L'appel a était annulé / terminé")
            mycall = 0
            patient_actuel = nil
        end
    end
end)

RegisterNetEvent('LSFD:newcall')
AddEventHandler('LSFD:newcall', function(toogle)
    if in_service == true then
        ESX.ShowNotification('18 : Nouvel Appel !')
        SendNUIMessage({ action = "play_bip" })
    end
end)

-------------- LOOP --------------

Citizen.CreateThread(function()

    TriggerEvent('LSFD:createBlip', 436, 1196.1, -1478.1, 35.1)

    while true do
        Wait(0)

        if IsControlJustPressed(0, 38) then
            press_actionkey()
        elseif IsControlJustPressed(0, 166) then
            press_menukey()
        end

        if IsNearService() then
            DrawMarker(1,tonumber('1208.800537'), tonumber('-1481.0589599'), tonumber('33.8'), 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 255, 50, 50, 200, 0, 0, 0, 0)
            MSG_down("Appuyer sur ~r~E~s~ pour prendre / quitter votre service", 10)
        end

        if IsNearBureau() then
            DrawMarker(1,tonumber('1193.1'), tonumber('-1474.1'), tonumber('33.8'), 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 255, 50, 50, 200, 0, 0, 0, 0)
            MSG_down("Appuyer sur ~r~E~s~ pour acceder au bureau", 10)
        end

        if IsNearGarage() then
            if in_service == true then
                DrawMarker(1,tonumber('1200.693603'), tonumber('-1496.005'), tonumber('33.7'), 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 255, 50, 50, 200, 0, 0, 0, 0)
                MSG_down("Appuyer sur ~r~E~s~ pour ouvrir le garage", 10)
            end
        end

        if IsNearGarage2() then
            if in_service == true then
                DrawMarker(1,tonumber('-1197.1'), tonumber('-1809.1'), tonumber('3.5'), 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 255, 50, 50, 200, 0, 0, 0, 0)
                MSG_down("Appuyer sur ~r~E~s~ pour ouvrir le garage", 10)
            end
        end
    end
end)

-------------- KEYBOARD --------------

function press_actionkey()
    if IsNearService() then
        if in_service == true then
            --TriggerEvent('chatMessage', "", {255,255,255}, "^2Vous avez fini votre service (10-18)")
            Citizen.CreateThread(function()
                local model = GetHashKey("mp_m_freemode_01")

                RequestModel(model)
                while not HasModelLoaded(model) do
                    RequestModel(model)
                    Citizen.Wait(0)
                end

                SetPlayerModel(PlayerId(), model)
                SetEntityHealth(GetPlayerPed(-1), 200)
                TriggerEvent('dispatch:service_unit', false)
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                    TriggerEvent('skinchanger:loadSkin', skin)
                end)
            end)
            in_service = false
        else
            ESX.TriggerServerCallback('esx_service:enableService', function(toogle, nb)
                if toogle == true then
                  ESX.ShowNotification("Vous êtes maintenant en service avec " .. nb .. " collègue(s)")
                  in_service = true

                    TriggerEvent('dispatch:service_unit', true)
                    my_grade = PlayerData.job.grade_name
                    --GenerateGaragePompier(my_grade)
                    --GenerateGarageLifeGuard(my_grade)
                    Citizen.CreateThread(function()
                        SetPedComponentVariation(GetPlayerPed(-1), 4, 9, 8, 2) -- pantalon
                        SetPedComponentVariation(GetPlayerPed(-1), 11, 26, 3, 2) -- chemise
                        SetPedComponentVariation(GetPlayerPed(-1), 3, 30, 0, 2) -- gants
                        SetPedComponentVariation(GetPlayerPed(-1), 6, 25, 0, 2) -- chaussure
                        SetEntityHealth(GetPlayerPed(-1), 200)
                        --SetModelAsNoLongerNeeded(model)
                        GiveWeaponToPed(GetPlayerPed(PlayerId()), GetHashKey("weapon_molotov"), 1000000, false)
                        GiveWeaponToPed(GetPlayerPed(PlayerId()), GetHashKey("weapon_hatchet"), 1000000, false)
                        GiveWeaponToPed(GetPlayerPed(PlayerId()), GetHashKey("weapon_crowbar"), 1000000, false)
                        GiveWeaponToPed(GetPlayerPed(PlayerId()), GetHashKey("weapon_flashlight"), 1000000, false)
                        GiveWeaponToPed(GetPlayerPed(PlayerId()), GetHashKey("weapon_fireextinguisher"), 1000000, false)
                        GiveWeaponToPed(GetPlayerPed(PlayerId()), GetHashKey("weapon_flare"), 1000000, false)
                        GiveWeaponToPed(GetPlayerPed(PlayerId()), GetHashKey("GADGET_PARACHUTE"), 1, false)
                        SetPedInfiniteAmmo(GetPlayerPed(PlayerId()), true, GetHashKey("weapon_fireextinguisher"))
                    end)

                else
                  in_service = false
                  ESX.ShowNotification("Vous ne travaillez pas ici")
                end

            end, 'pompier')
        end
    end
    if IsNearGarage() == true then
        if in_service == true then
            GenerateGaragePompier(PlayerData.job.grade_name)
        end
    end
    if IsNearGarage2() == true then
        if in_service == true then
            GenerateGarageLifeGuard(PlayerData.job.grade_name)
        end
    end
    if IsNearBureau() then
        RequestPDGinfo()
    end
end

function GenerateGaragePompier(grd)
    local vhc = {
        {label = 'Suprimer le véhicule', value = "deleteCar"}
    }
    if grd == 'formation' then
        vhc = {
            {label = 'Suprimer le véhicule', value = "deleteCar"},
            {label = '4*4 Lifeguard', value = 'lguard', fifisay = "~o~Fifi : ~w~Pin Pon, PIN PON !"}
        }
    elseif grd == 'stagiaire' then
        vhc = {
            {label = 'Suprimer le véhicule', value = "deleteCar"},
            {label = 'FPT', value = 'firetruk', fifisay = "~o~Fifi : ~w~Calme toi, y a pas le feu au lac"},
            {label = 'VSAV', value = 'ambulance', fifisay = "~o~Fifi : ~w~Fait y gaffe, je viens de le réparer"},
            {label = '4*4 Lifeguard', value = 'lguard', fifisay = "~o~Fifi : ~w~Pin Pon, PIN PON !"}
        }
    elseif grd == 'sapeur' then
        vhc = {
            {label = 'Suprimer le véhicule', value = "deleteCar"},
            {label = 'FPT', value = 'firetruk', fifisay = "~o~Fifi : ~w~Calme toi, y a pas le feu au lac"},
            {label = 'VSAV', value = 'ambulance', fifisay = "~o~Fifi : ~w~Fait y gaffe, je viens de le réparer"},
            {label = 'Dragon', value = "supervolito", fifisay = "~o~Fifi : ~w~Arrete de jouer avec, sa coute cher ce truc"},
            {label = 'Camion Technique', value = 'rallytruck', fifisay = "~o~Fifi : ~w~Putain je l'ai pas vu dehors depuis les années 2000 !"},
            {label = '4*4 Lifeguard', value = 'lguard', fifisay = "~o~Fifi : ~w~Pin Pon, PIN PON !"}
        }
    elseif grd == 'caporal' then
        vhc = {
            {label = 'Suprimer le véhicule', value = "deleteCar"},
            {label = 'VL', value = 'fbi2', fifisay = "~o~Fifi : ~w~Si c'est le chef qui le dit, alors pas de soucis"},
            {label = 'FPT', value = 'firetruk', fifisay = "~o~Fifi : ~w~Calme toi, y a pas le feu au lac"},
            {label = 'VSAV', value = 'ambulance', fifisay = "~o~Fifi : ~w~Fait y gaffe, je viens de le réparer"},
            {label = 'Dragon', value = "supervolito", fifisay = "~o~Fifi : ~w~Arrete de jouer avec, sa coute cher ce truc"},
            {label = 'CargoBob', value = "cargobob2", fifisay = "~o~Jery : ~w~Fifi je t'encule il est a moi !"},
            {label = 'Camion Technique', value = 'rallytruck', fifisay = "~o~Fifi : ~w~Putain je l'ai pas vu dehors depuis les années 2000 !"},
            {label = '4*4 Lifeguard', value = 'lguard', fifisay = "~o~Fifi : ~w~Pin Pon, PIN PON !"}
        }
    elseif grd == 'lieutenant' then
        vhc = {
            {label = 'Suprimer le véhicule', value = "deleteCar"},
            {label = 'VL', value = 'fbi2', fifisay = "~o~Fifi : ~w~Si c'est le chef qui le dit, alors pas de soucis"},
            {label = 'FPT', value = 'firetruk', fifisay = "~o~Fifi : ~w~Calme toi, y a pas le feu au lac"},
            {label = 'VSAV', value = 'ambulance', fifisay = "~o~Fifi : ~w~Fait y gaffe, je viens de le réparer"},
            {label = 'Dragon', value = "supervolito", fifisay = "~o~Fifi : ~w~Arrete de jouer avec, sa coute cher ce truc"},
            {label = 'CargoBob', value = "cargobob2", fifisay = "~o~Jery : ~w~Fifi je t'encule il est a moi !"},
            {label = 'Camion Technique', value = 'rallytruck', fifisay = "~o~Fifi : ~w~Putain je l'ai pas vu dehors depuis les années 2000 !"},
            {label = '4*4 Lifeguard', value = 'lguard', fifisay = "~o~Fifi : ~w~Pin Pon, PIN PON !"}
        }
    elseif grd == 'chef' then
        vhc = {
            {label = 'Suprimer le véhicule', value = "deleteCar"},
            {label = 'VL', value = 'fbi2', fifisay = "~o~Fifi : ~w~Si c'est le chef qui le dit, alors pas de soucis"},
            {label = 'FPT', value = 'firetruk', fifisay = "~o~Fifi : ~w~Calme toi, y a pas le feu au lac"},
            {label = 'VSAV', value = 'ambulance', fifisay = "~o~Fifi : ~w~Fait y gaffe, je viens de le réparer"},
            {label = 'Dragon', value = "supervolito", fifisay = "~o~Fifi : ~w~Arrete de jouer avec, sa coute cher ce truc"},
            {label = 'CargoBob', value = "cargobob2", fifisay = "~o~Jery : ~w~Fifi je t'encule il est a moi !"},
            {label = 'Camion Technique', value = 'rallytruck', fifisay = "~o~Fifi : ~w~Putain je l'ai pas vu dehors depuis les années 2000 !"},
            {label = '4*4 Lifeguard', value = 'lguard', fifisay = "~o~Fifi : ~w~Pin Pon, PIN PON !"}
        }
    end


    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pompier_garage1',
        {
        title    = "Garage pompier",
        align    = 'top-left',
        elements = vhc,
        },
        function(data, menu)
            menu.close()

            if data.current.value == 'deleteCar' then
                DoAction('delcar')
            elseif data.current.value == 'supervolito' then
                SpawnJobHeli(data.current.value, data.current.fifisay)
            elseif data.current.value == 'cargobob2' then
                SpawnJobHeli(data.current.value, data.current.fifisay)
            else
                SpawnJobCar(data.current.value, data.current.fifisay)
            end

        end,
        function(data, menu)
            menu.close()
        end
    )
end


function GenerateGarageLifeGuard(grd)
    local vhc = {
        {label = 'Suprimer le véhicule', value = "deleteCar"}
    }
    if grd == 'formation' then
        vhc = {
            {label = 'Suprimer le véhicule', value = "deleteCar"},
            {label = '4*4 Lifeguard', value = 'lguard'}
        }
    elseif grd == 'stagiaire' then
        vhc = {
            {label = 'Suprimer le véhicule', value = "deleteCar"},
            {label = 'VSAV', value = 'ambulance'},
            {label = '4*4 Lifeguard', value = 'lguard'}
        }
    elseif grd == 'sapeur' then
        vhc = {
            {label = 'Suprimer le véhicule', value = "deleteCar"},
            {label = 'VSAV', value = 'ambulance'},
            {label = 'Dragon', value = "supervolito"},
            {label = '4*4 Lifeguard', value = 'lguard'},
            {label = 'quad Lifeguard', value = 'blazer2'}
        }
    elseif grd == 'caporal' then
        vhc = {
            {label = 'Suprimer le véhicule', value = "deleteCar"},
            {label = 'VSAV', value = 'ambulance'},
            {label = 'Dragon', value = "supervolito"},
            {label = '4*4 Lifeguard', value = 'lguard'},
            {label = 'quad Lifeguard', value = 'blazer2'}
        }
    elseif grd == 'lieutenant' then
        vhc = {
            {label = 'Suprimer le véhicule', value = "deleteCar"},
            {label = 'VSAV', value = 'ambulance'},
            {label = 'Dragon', value = "supervolito"},
            {label = '4*4 Lifeguard', value = 'lguard'},
            {label = 'quad Lifeguard', value = 'blazer2'}
        }
    elseif grd == 'chef' then
        vhc = {
            {label = 'Suprimer le véhicule', value = "deleteCar"},
            {label = 'VSAV', value = 'ambulance'},
            {label = 'Dragon', value = "supervolito"},
            {label = '4*4 Lifeguard', value = 'lguard'},
            {label = 'quad Lifeguard', value = 'blazer2'}
        }
    end


    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pompier_garage1',
        {
        title    = "Garage LifeGuard",
        align    = 'top-left',
        elements = vhc,
        },
        function(data, menu)
            menu.close()

            if data.current.value == 'deleteCar' then
                DoAction('delcar')
            elseif data.current.value == 'supervolito' then
                SpawnJobHeli2(data.current.value)
            else
                SpawnJobCar2(data.current.value)
            end

        end,
        function(data, menu)
            menu.close()
        end
    )
end


function press_menukey()
    if in_service == true then
        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'pompier_principal',
            {
            title    = "Pompier",
            align    = 'top-left',
            elements = {
                --{label = "Dispatch 911", value = 'openDispatch'},
                {label = "Intervention", value = 'openInter'},
                {label = "Tenues", value = 'pompier_tenue'},
                {label = "Accessoires", value = 'pompier_acc'},
                {label = "Secourisme", value = 'pompier_secour'},
                {label = "Accident / Treuil", value = 'pompier_inc'},
                {label = "Objets", value = 'pompier_obj'},
            },
            },
            function(data1, menu1)
                menu1.close()

                --if data1.current.value == 'openDispatch' then
                --    TriggerServerEvent('dispatch:openUnit')
                --end

                if data.current.value == 'openInter' then
                    local els = {}
                    if mycall > 0 then
                        table.insert(els, {label = "Finir Mon appel", value = "close"})
                        table.insert(els, {label = "Mode : sans intervention", value = "passez"})
                    end
                    for nb,value in pairs(Appels) do
                        local mc = GetEntityCoords(GetPlayerPed(-1), 1)
                        local distance = GetDistance(value.posX, value.posY, mc["x"], mc["y"])
                        if value.id == mycall then
                            table.insert(els, {label = "ACTUEL (" .. value.id .. ") : " .. value.raison .. " à " .. math.floor(distance) .. "m", rs = value.raison, value = value.id, x = value.posX, y = value.posY})
                        else
                            table.insert(els, {label = "(" .. value.id .. ") : " .. value.raison .. " à " .. math.floor(distance) .. "m", rs = value.raison, value = value.id, x = value.posX, y = value.posY})
                        end
                    end
                    table.insert(els, {label = "retour", value = "retour"})

                    ESX.UI.Menu.Open(
                        'default', GetCurrentResourceName(), 'pompier_inter',
                        {
                        title    = "Interventions",
                        align    = 'top-left',
                        elements = els,
                        },
                        function(data, menu)
                            menu.close()

                            if data.current.value == 'retour' then
                                press_menukey()
                            elseif data.current.value == 'close' then
                                TriggerServerEvent('LSFD:endcall', mycall)
                                TriggerServerEvent('LSFD:sendNotif', mycall, "Votre appel à été transmi avec succès")
                                mycall = 0
                                patient_actuel = nil
                                press_menukey()
                            elseif data.current.value == 'passez' then
                                TriggerServerEvent('LSFD:sendNotif', mycall, "Le pompier à du faire demi-tour, il va potentiellement être remplacé par un collègue")
                                mycall = 0
                                patient_actuel = nil
                                press_menukey()
                            else
                                TriggerServerEvent('LSFD:sendNotif', data.current.value, "Les pompiers sont en route, veuillez patienter.")
                                mycall = data2.current.value
                                patient_actuel = mycall
                                SetNewWaypoint(data.current.x, data.current.y)
                                press_menukey()
                            end
                        end,
                        function(data, menu)
                            menu.close()
                            press_menukey()
                        end
                    )
                end

                if data1.current.value == 'pompier_tenue' then
                    ESX.UI.Menu.Open(
                        'default', GetCurrentResourceName(), 'pompier_tenue',
                        {
                        title    = "Tenues",
                        align    = 'top-left',
                        elements = {
                            {label = "Tenue de feu", value = 'S_M_Y_Fireman_01'},
                            {label = "Tenue paramedic", value = 'S_M_M_Paramedic_01'},
                            {label = "Tenue lifeguard (H)", value = 'S_M_Y_BayWatch_01'},
                            {label = "Tenue lifeguard (F)", value = 'S_F_Y_Baywatch_01'},
                            {label = "Tenue détente (1/2)", value = 'CUSTOM_01'},
                            {label = "Tenue détente (2/2)", value = 'CUSTOM_02'},
                            {label = "Tenue Garde-Cote", value = 's_m_y_uscg_01'},
                            {label = "Tenue GRIMP", value = 'hc_gunman'},
                            {label = "Casque 1", value = '_1'},
                            {label = "Casque 2", value = '_2'},
                            {label = "Casque 3", value = '_3'},
                            {label = "Casque 4", value = '_4'},
                            {label = "retour", value = 'retour'},
                        },
                        },
                        function(data, menu)
                            menu.close()

                            if data.current.value == 'retour' then
                                press_menukey()
                            elseif data.current.value == '_1' then
                                GivePedHelmet(GetPlayerPed(-1), true, 16384, 1)
                            elseif data.current.value == '_2' then
                                GivePedHelmet(GetPlayerPed(-1), true, 16384, 0)
                            elseif data.current.value == '_3' then
                                GivePedHelmet(GetPlayerPed(-1), true, 1, 16384)
                            elseif data.current.value == '_4' then
                                GivePedHelmet(GetPlayerPed(-1), true, 0, 16384)
                            else
                                --loadSkin(data.current.value)
                                Citizen.CreateThread(function()
                                    if data.current.value == "CUSTOM_01" then
                                        Citizen.CreateThread(function()
                                            local model = GetHashKey("mp_m_freemode_01")

                                            RequestModel(model)
                                            while not HasModelLoaded(model) do
                                                RequestModel(model)
                                                Citizen.Wait(0)
                                            end

                                            SetPlayerModel(PlayerId(), model)
                                            SetEntityHealth(GetPlayerPed(-1), 200)
                                            Wait(250)
                                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                                                TriggerEvent('skinchanger:loadSkin', skin)
                                            end)
                                        end)
                                    elseif data.current.value == "CUSTOM_02" then
                                        SetPedComponentVariation(GetPlayerPed(-1), 4, 9, 8, 2) -- pantalon
                                        SetPedComponentVariation(GetPlayerPed(-1), 11, 26, 3, 2) -- chemise
                                        SetPedComponentVariation(GetPlayerPed(-1), 3, 30, 0, 2) -- gants
                                        SetPedComponentVariation(GetPlayerPed(-1), 6, 25, 0, 2) -- chaussure
                                    else
                                        local model = GetHashKey(data.current.value)

                                        RequestModel(model)
                                        while not HasModelLoaded(model) do
                                            RequestModel(model)
                                            Citizen.Wait(0)
                                        end

                                        SetPlayerModel(PlayerId(), model)
                                        SetEntityHealth(GetPlayerPed(-1), 200)
                                        if data.current.value == "hc_gunman" then
                                            SetPedComponentVariation(GetPlayerPed(-1), 0, 4, 0, 2) -- visage
                                            SetPedComponentVariation(GetPlayerPed(-1), 2, 2, 0, 2) -- cagoule
                                            SetPedComponentVariation(GetPlayerPed(-1), 3, 3, 0, 2) -- haut
                                            SetPedComponentVariation(GetPlayerPed(-1), 4, 3, 0, 2) -- chaussure
                                        end
                                    end
                                    acc_data = {
                                        F1sale = false,
                                        F1ari = false,
                                        MEDlogo = true,
                                        MEDgilet = false,
                                        MEDgants = false,
                                        MEDmatos = false,
                                        LGHhaut = false,
                                        LGHceinture = true,
                                        LGHgilet = false,
                                        LGFhaut = false
                                    }
                                    GiveWeaponToPed(GetPlayerPed(PlayerId()), GetHashKey("weapon_crowbar"), 1000000, false)
                                    GiveWeaponToPed(GetPlayerPed(PlayerId()), GetHashKey("weapon_hatchet"), 1000000, false)
                                    GiveWeaponToPed(GetPlayerPed(PlayerId()), GetHashKey("weapon_flashlight"), 1000000, false)
                                    GiveWeaponToPed(GetPlayerPed(PlayerId()), GetHashKey("weapon_molotov"), 1000000, false)
                                    GiveWeaponToPed(GetPlayerPed(PlayerId()), GetHashKey("weapon_fireextinguisher"), 1000000, false)
                                    GiveWeaponToPed(GetPlayerPed(PlayerId()), GetHashKey("weapon_flare"), 1000000, false)
                                    GiveWeaponToPed(GetPlayerPed(PlayerId()), GetHashKey("GADGET_PARACHUTE"), 1, false)
                                    SetPedInfiniteAmmo(GetPlayerPed(PlayerId()), true, GetHashKey("weapon_fireextinguisher"))
                                end)
                            end

                        end,
                        function(data, menu)
                            menu.close()
                        end
                    )
                end

                if data1.current.value == 'pompier_acc' then
                    ESX.UI.Menu.Open(
                        'default', GetCurrentResourceName(), 'pompier_acc',
                        {
                        title    = "Accessoires",
                        align    = 'top-left',
                        elements = {
                            {label = 'F1 : tenue sale', value = "F1sale"},
                            {label = 'F1 : ARI', value = "F1ari"},
                            {label = 'MEDIC : logo', value = "MEDlogo"},
                            {label = 'MEDIC : gilet', value = "MEDgilet"},
                            {label = 'MEDIC : gants', value = "MEDgants"},
                            {label = 'MEDIC : stétoscope', value = "MEDmatos"},
                            {label = 'LG H : T-shirt', value = "LGHhaut"},
                            {label = 'LG H : ceinture', value = "LGHceinture"},
                            {label = 'LG H : gilet de sauvetage', value = "LGHgilet"},
                            {label = 'LG F : T-shirt', value = "LGFhaut"},
                            {label = "retour", value = 'retour'},
                        },
                        },
                        function(data, menu)
                            menu.close()

                            if data.current.value == 'retour' then
                                press_menukey()
                            else
                                LoadAcc(data.current.value)
                            end

                        end,
                        function(data, menu)
                            menu.close()
                        end
                    )
                end

                if data1.current.value == 'pompier_secour' then
                    ESX.UI.Menu.Open(
                        'default', GetCurrentResourceName(), 'pompier_secour',
                        {
                        title    = "Secourisme",
                        align    = 'top-left',
                        elements = {
                            {label = 'Soigner la victime', value = "soigner"},
                            {label = 'Réanimer la victime (10m)', value = "reanimer"},
                            {label = 'Réanimer de force', value = "reanimer2"},
                            {label = 'Réanimer et TP (noyade)', value = "reanimer3"},
                            {label = 'camisole : monter de force', value = "tpAllV"},
                            {label = 'camisole : sortir de force',value = "leaveAllV"},
                            {label = "fermer", value = 'fermer'},
                        },
                        },
                        function(data, menu)

                            if data.current.value == 'fermer' then
                                menu.close()
                            else
                                DoAction(data.current.value)
                            end

                        end,
                        function(data, menu)
                            menu.close()
                        end
                    )
                end

                if data1.current.value == 'pompier_inc' then
                    ESX.UI.Menu.Open(
                        'default', GetCurrentResourceName(), 'pompier_inc',
                        {
                        title    = "Accident / Treuil",
                        align    = 'top-left',
                        elements = {
                            {label = 'Attacher le treuil', value = "saveV"},
                            {label = 'Remonter le treuil', value = "gotoV"},
                            {label = 'Faire monter everyone (25m)', value = "tpAllV"},
                            {label = 'Faire sortir everyone', value = "leaveAllV"},
                            {label = 'Désincarcérer', value = "opendoor"},
                            {label = 'repair (HRP)', value = "repair"},
                            {label = 'Supprimer le véhicule (HRP)', value = "delcar"},
                            {label = "fermer", value = 'fermer'},
                        },
                        },
                        function(data, menu)

                            if data.current.value == 'fermer' then
                                menu.close()
                            else
                                DoAction(data.current.value)
                            end

                        end,
                        function(data, menu)
                            menu.close()
                        end
                    )
                end

                if data1.current.value == 'pompier_obj' then
                    ESX.UI.Menu.Open(
                        'default', GetCurrentResourceName(), 'pompier_obj',
                        {
                        title    = "Objets",
                        align    = 'top-left',
                        elements = {
                            {label = 'placer : cone', add = true, value = "prop_roadcone02a"},
                            {label = 'supprimer : cone', add = false, value = "prop_roadcone02a"},
                            {label = 'placer : Stopped Vhc', add = true, value = "prop_consign_02a"},
                            {label = 'supprimer : Stopped Vhc', add = false, value = "prop_consign_02a"},
                            {label = 'placer : barriere', add = true, value = "prop_mp_arrow_barrier_01"},
                            {label = 'supprimer : barriere', add = false, value = "prop_mp_arrow_barrier_01"},
                            {label = 'placer : tente blanche', add = true, value = "prop_parasol_02"},
                            {label = 'supprimer : tente blanche', add = false, value = "prop_parasol_02"},
                            {label = 'placer : brancard', add = true, value = "prop_patio_lounger1b"},
                            {label = 'supprimer : brancard', add = false, value = "prop_patio_lounger1b"},
                            {label = "fermer", value = 'fermer'},
                        },
                        },
                        function(data, menu)

                            if data.current.value == 'fermer' then
                                menu.close()
                            else
                                if data.current.add == true then
                                    POMPIER_placeCone(data.current.value)
                                else
                                    POMPIER_removeCone(data.current.value)
                                end
                            end

                        end,
                        function(data, menu)
                            menu.close()
                        end
                    )
                end

            end,
            function(data, menu)
                menu.close()
            end
        )
    end
end

function press_PDGkey()
    if in_service == true then
        RequestPDGinfo()
    end
end

-------------- FUNCTIONNALITY --------------

-- Check if player is in a vehicle
function IsInVehicle()
  local ply = GetPlayerPed(-1)
  if IsPedSittingInAnyVehicle(ply) then
    return true
  else
    return false
  end
end

function MSG_down(text, time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time, 1)
end

-- Check if player is near the service point
function IsNearService()
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 1)
    local distance = GetDistance(job_position.service.x, job_position.service.y, plyCoords["x"], plyCoords["y"])
    if(distance <= 3) then
        return true
    else
        return false
    end
end

function IsNearBureau()
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 1)
    local distance = GetDistance(job_position.bureau.x, job_position.bureau.y, plyCoords["x"], plyCoords["y"])
    if(distance <= 3) then
        return true
    else
        return false
    end
end

-- Check if player is near of garage
function IsNearGarage()
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 1)
    local distance = GetDistance(job_position.garage1.x, job_position.garage1.y,  plyCoords["x"], plyCoords["y"])
    if(distance <= 10) then
        return true
    else
        return false
    end
end
function IsNearGarage2()
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 1)
    local distance = GetDistance(job_position.garage2.x, job_position.garage2.y,  plyCoords["x"], plyCoords["y"])
    if(distance <= 10) then
        return true
    else
        return false
    end
end

-- Check if player is near another player
function IsNearPlayer(player)
  local ply = GetPlayerPed(-1)
  local plyCoords = GetEntityCoords(ply, 1)
  local ply2 = GetPlayerPed(GetPlayerFromServerId(player))
  local ply2Coords = GetEntityCoords(ply2, 1)
  local distance = GetDistance(ply2Coords["x"], ply2Coords["y"], plyCoords["x"], plyCoords["y"])
  if(distance <= 50) then
    return true
  else
    return false
  end
end

function GetPlayers()
	local players = {}

	for i = 0, 31 do
		if NetworkIsPlayerActive(i) then
			table.insert(players, i)
		end
	end

	return players
end

function GetClosestPlayer()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = GetPlayerPed(-1)
	local plyCoords = GetEntityCoords(ply, 1)

	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = GetDistance(targetCoords["x"], targetCoords["y"], plyCoords["x"], plyCoords["y"])
			if(closestDistance == -1 or closestDistance > distance) then
                if distance > 1.0 then
				    closestPlayer = value
				    closestDistance = distance
                end
			end
		end
	end

	return closestPlayer, closestDistance
end


function GetDistance (x1,y1,x2,y2)
    return math.abs(x1 - x2) + math.abs(y1 - y2)
end

function SpawnJobCar (name, fifisay)
    local vehi = GetClosestVehicle(job_position.garagespawn1.x, job_position.garagespawn1.y, job_position.garagespawn1.z, tonumber('5.0'), 0, 70)
    if vehi == 0 then
        local car = GetHashKey(name)
        RequestModel(car)
        while not HasModelLoaded(car) do
                Citizen.Wait(0)
        end
        workcar = CreateVehicle(car, job_position.garagespawn1.x, job_position.garagespawn1.y, job_position.garagespawn1.z, 180.0, true, false)
        SetVehicleMod(workcar, 11, 2)
        SetVehicleMod(workcar, 12, 2)
        SetVehicleMod(workcar, 13, 2)
        SetVehicleNumberPlateText(workcar, plate)
        if name == "fbi2" then
            SetVehicleColours(workcar, 39, 12)
        end
        if name == "ambulance" then
            SetVehicleLivery(workcar, 1)
        end
        if name == "benson" then
            SetVehicleLivery(workcar, 1)
        end
        if name == "BALLER4" then
            SetVehicleColours(workcar, 39, 12)
        end
        if name == "BALLER6" then
            SetVehicleColours(workcar, 39, 12)
        end
        if name == "rallytruck" then
            SetVehicleColours(workcar, 39, 12)
        end
        SetVehicleOnGroundProperly(workcar)
        SetVehicleHasBeenOwnedByPlayer(workcar,true)
        local netid = NetworkGetNetworkIdFromEntity(workcar)
        SetNetworkIdCanMigrate(netid, true)
        --NetworkRegisterEntityAsNetworked(VehToNet(workcar))
        SetEntityInvincible(workcar, false)
        SetEntityAsMissionEntity(workcar, true, true)

        MSG_down(fifisay, 2000)
        return workcar
    else
        MSG_down("~r~Zone de spawn encombrée", 5000)
    end
end

function SpawnJobCar2 (name)
    local vehi = GetClosestVehicle(job_position.garagespawn2.x, job_position.garagespawn2.y, job_position.garagespawn2.z, tonumber('5.0'), 0, 70)
    if vehi == 0 then
        local car = GetHashKey(name)
        RequestModel(car)
        while not HasModelLoaded(car) do
                Citizen.Wait(0)
        end
        workcar = CreateVehicle(car, job_position.garagespawn2.x, job_position.garagespawn2.y, job_position.garagespawn2.z, 180.0, true, false)
        SetVehicleMod(workcar, 11, 2)
        SetVehicleMod(workcar, 12, 2)
        SetVehicleMod(workcar, 13, 2)
        SetVehicleNumberPlateText(workcar, plate)
        if name == "fbi2" then
            SetVehicleColours(workcar, 39, 12)
        end
        if name == "ambulance" then
            SetVehicleLivery(workcar, 1)
        end
        if name == "benson" then
            SetVehicleLivery(workcar, 1)
        end
        if name == "BALLER4" then
            SetVehicleColours(workcar, 39, 12)
        end
        if name == "BALLER6" then
            SetVehicleColours(workcar, 39, 12)
        end
        SetVehicleOnGroundProperly(workcar)
        SetVehicleHasBeenOwnedByPlayer(workcar,true)
        local netid = NetworkGetNetworkIdFromEntity(workcar)
        SetNetworkIdCanMigrate(netid, true)
        --NetworkRegisterEntityAsNetworked(VehToNet(workcar))
        SetEntityInvincible(workcar, false)
        SetEntityAsMissionEntity(workcar, true, true)

        return workcar
    else
        MSG_down("~r~Zone de spawn encombrée", 5000)
    end
end

function deleteJobCar()
    Citizen.CreateThread(function()
        DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1), false))
    end)
end

function SpawnMISSIONCar (name, x, y, z, dir, params)
	local car = GetHashKey(name)
    --local vehi = GetClosestVehicle(x, y, z, tonumber('5.0'), 0, 70)
    --if vehi == 0 then
        RequestModel(car)
        while not HasModelLoaded(car) do
                Citizen.Wait(0)
        end
        workcar = CreateVehicle(car, x, y, z, dir, true, false)
        if params.customMotor == true then
            SetVehicleMod(workcar, 11, 2)
            SetVehicleMod(workcar, 12, 2)
            SetVehicleMod(workcar, 13, 2)
        end
        if params.customPlate == true then
            SetVehicleNumberPlateText(workcar, params.plate)
        else
            SetVehicleNumberPlateText(workcar, "INTERDIT")
        end
        if params.colors == true then
            SetVehicleColours(workcar, params.color1, params.color2)
        end
        if params.haveLivery == true then
            SetVehicleLivery(workcar, params.livery)
        end
        SetVehicleOnGroundProperly(workcar)
        if params.nodelete == true then
            SetVehicleHasBeenOwnedByPlayer(workcar,true)
            local netid = NetworkGetNetworkIdFromEntity(workcar)
            SetNetworkIdCanMigrate(netid, true)
            NetworkRegisterEntityAsNetworked(VehToNet(workcar))
            SetEntityInvincible(workcar, false)
            SetEntityAsMissionEntity(workcar, true, true)
        end

        return workcar
    --else
        --MSG_down("~r~Zone de spawn encombrée", 5000)
    --end
end


function SpawnJobHeli (name, fifisay)
    local vehi = GetClosestVehicle(job_position.helispawn1.x, job_position.helispawn1.y, job_position.helispawn1.z, tonumber('5.0'), 0, 70)
    if vehi == 0 then
        local car = GetHashKey(name)
        RequestModel(car)
        while not HasModelLoaded(car) do
                Citizen.Wait(0)
        end
        workcar = CreateVehicle(car, job_position.helispawn1.x, job_position.helispawn1.y, job_position.helispawn1.z, 00.0, true, false)
        SetVehicleMod(workcar, 11, 2)
        SetVehicleMod(workcar, 12, 2)
        SetVehicleMod(workcar, 13, 2)
        SetVehicleNumberPlateText(workcar, plate)
        if name == "polmav" then
            SetVehicleLivery(workcar, 1)
        end
        if name == "frogger" then
            SetVehicleColours(workcar, 39, 42)
        end
        if name == "buzzard2" then
            SetVehicleColours(workcar, 39, 42)
        end
        SetVehicleOnGroundProperly(workcar)
        SetVehicleHasBeenOwnedByPlayer(workcar,true)
        local netid = NetworkGetNetworkIdFromEntity(workcar)
        SetNetworkIdCanMigrate(netid, true)
        --NetworkRegisterEntityAsNetworked(VehToNet(workcar))
        SetEntityInvincible(workcar, false)
        SetEntityAsMissionEntity(workcar, true, true)

        MSG_down(fifisay, 2000)
        return workcar
    else
        MSG_down("~r~Zone de spawn encombrée", 5000)
    end
end

function SpawnJobHeli2 (name)
    local vehi = GetClosestVehicle(job_position.helispawn2.x, job_position.helispawn2.y, job_position.helispawn2.z, tonumber('5.0'), 0, 70)
    if vehi == 0 then
        local car = GetHashKey(name)
        RequestModel(car)
        while not HasModelLoaded(car) do
                Citizen.Wait(0)
        end
        workcar = CreateVehicle(car, job_position.helispawn2.x, job_position.helispawn2.y, job_position.helispawn2.z, 00.0, true, false)
        SetVehicleMod(workcar, 11, 2)
        SetVehicleMod(workcar, 12, 2)
        SetVehicleMod(workcar, 13, 2)
        SetVehicleNumberPlateText(workcar, plate)
        if name == "polmav" then
            SetVehicleLivery(workcar, 1)
        end
        if name == "frogger" then
            SetVehicleColours(workcar, 39, 42)
        end
        if name == "buzzard2" then
            SetVehicleColours(workcar, 39, 42)
        end
        SetVehicleOnGroundProperly(workcar)
        SetVehicleHasBeenOwnedByPlayer(workcar,true)
        local netid = NetworkGetNetworkIdFromEntity(workcar)
        SetNetworkIdCanMigrate(netid, true)
        --NetworkRegisterEntityAsNetworked(VehToNet(workcar))
        SetEntityInvincible(workcar, false)
        SetEntityAsMissionEntity(workcar, true, true)

        return workcar
    else
        MSG_down("~r~Zone de spawn encombrée", 5000)
    end
end

function POMPIER_placeCone(hash)
    local mePed = GetPlayerPed(-1)
    local pos = GetOffsetFromEntityInWorldCoords(mePed, 0.0, 0.2, 0.0)
      local h = GetEntityHeading(mePed)
      local BarrierAng = GetEntityRotation(GetPlayerPed(-1))
      --if hash == "prop_consign_02a" then
        local object = CreateObject(hash, pos.x + tonumber('0.7'), pos.y + tonumber('0.7'), pos.z - tonumber('1.3'), GetEntityHeading(mePed), true, false)
      local id = NetworkGetNetworkIdFromEntity(object)
      SetNetworkIdCanMigrate(id, true)
      PlaceObjectOnGroundProperly(object)
      SetEntityRotation(object, BarrierAng.x, BarrierAng.y, BarrierAng.z)
      SetEntityDynamic(object , true)
      SetEntityInvincible(object , true)
      SetEntityCanBeDamaged(object , false)
      SetEntityHealth(object , 1000)
      SetEntityHasGravity(object , true)
      SetEntityAsMissionEntity(object, true, true)
      SetEntityLoadCollisionFlag(object , true)
      SetEntityRecordsCollisions(object , true)
      --[[else
        local object = CreateObject(hash, pos.x + tonumber('0.7'), pos.y + tonumber('0.7'), pos.z - tonumber('1.5'), GetEntityHeading(mePed), true, false)
        local id = NetworkGetNetworkIdFromEntity(object)
        SetNetworkIdCanMigrate(id, true)
        SetEntityRotation(object, BarrierAng.x, BarrierAng.y, BarrierAng.z)
        PlaceObjectOnGroundProperly(object)
        SetEntityDynamic(object , true)
        SetEntityInvincible(object , true)
        SetEntityCanBeDamaged(object , false)
        SetEntityHealth(object , 1000)
        SetEntityHasGravity(object , true)
        SetEntityAsMissionEntity(object, true, true)
        SetEntityLoadCollisionFlag(object , true)
        SetEntityRecordsCollisions(object , true)
      end]]
  end

  function POMPIER_removeCone(hash)
    local mePed = GetPlayerPed(-1)
    local pos = GetOffsetFromEntityInWorldCoords(mePed, 0.0, 0.2, 0.0)
    local cone = GetClosestObjectOfType( pos.x, pos.y, pos.z, 2.0, GetHashKey(hash), false, false, false)
    if cone ~= 0 then
      -- ... /!\
      NetworkRequestControlOfEntity(cone)
      Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(cone))
      Citizen.InvokeNative(0x539E0AE3E6634B9F, Citizen.PointerValueIntInitialized(cone))
      DeleteObject(cone)
      SetEntityCoords(cone, -2000.0, -2000.0, -2000.0)
    end
  end

function LoadSkin (hash)
    Citizen.CreateThread(function()
        if hash == "CUSTOM_01" then
            Citizen.CreateThread(function()
                local model = GetHashKey("mp_m_freemode_01")

                RequestModel(model)
                while not HasModelLoaded(model) do
                    RequestModel(model)
                    Citizen.Wait(0)
                end

                SetPlayerModel(PlayerId(), model)
                SetEntityHealth(GetPlayerPed(-1), 200)
                Wait(250)
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                    TriggerEvent('skinchanger:loadSkin', skin)
                end)
            end)
        elseif hash == "CUSTOM_02" then
            SetPedComponentVariation(GetPlayerPed(-1), 4, 9, 8, 2) -- pantalon
            SetPedComponentVariation(GetPlayerPed(-1), 11, 26, 3, 2) -- chemise
            SetPedComponentVariation(GetPlayerPed(-1), 3, 30, 0, 2) -- gants
            SetPedComponentVariation(GetPlayerPed(-1), 6, 25, 0, 2) -- chaussure
        else
            local model = GetHashKey(hash)

            RequestModel(model)
            while not HasModelLoaded(model) do
                RequestModel(model)
                Citizen.Wait(0)
            end

            SetPlayerModel(PlayerId(), model)
            SetEntityHealth(GetPlayerPed(-1), 200)
            if hash == "hc_gunman" then
                SetPedComponentVariation(GetPlayerPed(-1), 0, 4, 0, 2) -- visage
                SetPedComponentVariation(GetPlayerPed(-1), 2, 2, 0, 2) -- cagoule
                SetPedComponentVariation(GetPlayerPed(-1), 3, 3, 0, 2) -- haut
                SetPedComponentVariation(GetPlayerPed(-1), 4, 3, 0, 2) -- chaussure
            end
            --SetModelAsNoLongerNeeded(model)
            -- TEST DES TENUES MODIFIER
            --if hash == "S_M_Y_Fireman_01" then
                -- WORK FINE    SetPedComponentVariation(GetPlayerPed(-1), 8, 1, 0, 0)
                --GivePedHelmet(GetPlayerPed(-1), 1, 16384, 1)
            --end
        end
        acc_data = {
            F1sale = false,
            F1ari = false,
            MEDlogo = true,
            MEDgilet = false,
            MEDgants = false,
            MEDmatos = false,
            LGHhaut = false,
            LGHceinture = true,
            LGHgilet = false,
            LGFhaut = false
        }
        GiveWeaponToPed(GetPlayerPed(PlayerId()), GetHashKey("weapon_crowbar"), 1000000, false)
        GiveWeaponToPed(GetPlayerPed(PlayerId()), GetHashKey("weapon_hatchet"), 1000000, false)
        GiveWeaponToPed(GetPlayerPed(PlayerId()), GetHashKey("weapon_flashlight"), 1000000, false)
        GiveWeaponToPed(GetPlayerPed(PlayerId()), GetHashKey("weapon_molotov"), 1000000, false)
        GiveWeaponToPed(GetPlayerPed(PlayerId()), GetHashKey("weapon_fireextinguisher"), 1000000, false)
        GiveWeaponToPed(GetPlayerPed(PlayerId()), GetHashKey("weapon_flare"), 1000000, false)
        GiveWeaponToPed(GetPlayerPed(PlayerId()), GetHashKey("GADGET_PARACHUTE"), 1, false)
        SetPedInfiniteAmmo(GetPlayerPed(PlayerId()), true, GetHashKey("weapon_fireextinguisher"))
    end)
end

function LoadAcc (acc)
    if acc == "F1sale" then
        if acc_data.F1sale == true then
            acc_data.F1sale = false
            SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2) -- haut propre
            SetPedComponentVariation(GetPlayerPed(-1), 4, 0, 0, 2) -- bas propre
        else
            acc_data.F1sale = true
            SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 1, 2) -- haut sale
            SetPedComponentVariation(GetPlayerPed(-1), 4, 0, 1, 2) -- bas propre
        end
    end
    if acc == "F1ari" then
        if acc_data.F1ari == true then
            acc_data.F1ari = false
            SetPedComponentVariation(GetPlayerPed(-1), 8, 0, 0, 0) -- sans ARI
        else
            acc_data.F1ari = true
            SetPedComponentVariation(GetPlayerPed(-1), 8, 1, 0, 0) -- avec ARI
        end
    end
    if acc == "MEDlogo" then
        if acc_data.MEDlogo == true then
            acc_data.MEDlogo = false
            SetPedComponentVariation(GetPlayerPed(-1), 10, 1, 0, 0) -- sans logo
        else
            acc_data.MEDlogo = true
            SetPedComponentVariation(GetPlayerPed(-1), 10, 0, 0, 0) -- avec logo
        end
    end
    if acc == "MEDgilet" then
        if acc_data.MEDgilet == true then
            acc_data.MEDgilet = false
            SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 0) -- sans gilet
        else
            acc_data.MEDgilet = true
            SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 0) -- avec gilet
        end
    end
    if acc == "MEDgants" then
        if acc_data.MEDgants == true then
            acc_data.MEDgants = false
            SetPedComponentVariation(GetPlayerPed(-1), 5, 0, 0, 0) -- sans gants
        else
            acc_data.MEDgants = true
            SetPedComponentVariation(GetPlayerPed(-1), 5, 1, 0, 0) -- avec gants
        end
    end
    if acc == "MEDmatos" then
        if acc_data.MEDmatos == true then
            acc_data.MEDmatos = false
            SetPedComponentVariation(GetPlayerPed(-1), 8, 0, 0, 0) -- sans matos
        else
            acc_data.MEDmatos = true
            SetPedComponentVariation(GetPlayerPed(-1), 8, 1, 0, 0) -- avec matos
        end
    end
    if acc == "LGHhaut" then
        if acc_data.LGHhaut == true then
            acc_data.LGHhaut = false
            SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 0) -- sans t-shirt
            SetPedComponentVariation(GetPlayerPed(-1), 10, 1, 0, 0) -- sans logo
        else
            acc_data.LGHhaut = true
            SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 2, 0) -- avec t-shirt
            SetPedComponentVariation(GetPlayerPed(-1), 10, 0, 0, 0) -- avec logo
        end
    end
    if acc == "LGHceinture" then
        if acc_data.LGHceinture == true then
            acc_data.LGHceinture = false
            SetPedComponentVariation(GetPlayerPed(-1), 8, 1, 0, 0) -- sans ceinture
        else
            acc_data.LGHceinture = true
            SetPedComponentVariation(GetPlayerPed(-1), 8, 0, 0, 0) -- avec ceinture
        end
    end
    if acc == "LGHgilet" then
        if acc_data.LGHgilet == true then
            acc_data.LGHgilet = false
            SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 0, 0) -- sans gilet
        else
            acc_data.LGHgilet = true
            SetPedComponentVariation(GetPlayerPed(-1), 9, 1, 0, 0) -- avec gilet
        end
    end
    if acc == "LGFhaut" then
        if acc_data.LGFhaut == true then
            acc_data.LGFhaut = false
            SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 0) -- sans t-shirt
            SetPedComponentVariation(GetPlayerPed(-1), 4, 0, 0, 0) -- sans short
            SetPedComponentVariation(GetPlayerPed(-1), 10, 0, 0, 0) -- logo pour maillot
        else
            acc_data.LGFhaut = true
            SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 0) -- avec t-shirt
            SetPedComponentVariation(GetPlayerPed(-1), 4, 1, 1, 0) -- avec short jaune
            SetPedComponentVariation(GetPlayerPed(-1), 10, 1, 0, 0) -- logo pour t-shirt
        end
    end
end


RegisterNetEvent("LSFD:setGPS")
AddEventHandler("LSFD:setGPS", function(nx, ny)
    SetNewWaypoint(nx, ny)
end)

function LoadTool (hash)
    if hash == "ALL" then
        GiveWeaponToPed(GetPlayerPed(PlayerId()), GetHashKey("weapon_crowbar"), 1000000, false)
        GiveWeaponToPed(GetPlayerPed(PlayerId()), GetHashKey("weapon_hatchet"), 1000000, false)
        GiveWeaponToPed(GetPlayerPed(PlayerId()), GetHashKey("weapon_flashlight"), 1000000, false)
        GiveWeaponToPed(GetPlayerPed(PlayerId()), GetHashKey("weapon_molotov"), 1000000, false)
        GiveWeaponToPed(GetPlayerPed(PlayerId()), GetHashKey("weapon_fireextinguisher"), 1000000, false)
        GiveWeaponToPed(GetPlayerPed(PlayerId()), GetHashKey("weapon_flare"), 1000000, false)
        SetPedInfiniteAmmo(GetPlayerPed(PlayerId()), true, GetHashKey("weapon_fireextinguisher"))
        GiveWeaponToPed(GetPlayerPed(PlayerId()), GetHashKey("GADGET_PARACHUTE"), 1, false)
    else
        GiveWeaponToPed(GetPlayerPed(PlayerId()), GetHashKey(hash), 1000000, false)
        if hash == "weapon_fireextinguisher" then
            SetPedInfiniteAmmo(GetPlayerPed(PlayerId()), true, GetHashKey("weapon_fireextinguisher"))
        end
    end
end

local lasthelico = false

function DoAction (name)
    if name == "stabiliser" then
        local pos = GetEntityCoords(GetPlayerPed(-1), 1)
        TriggerServerEvent('LSMC_stabiliser_victime', pos['x'], pos['y'])
        TriggerEvent('chatMessage', "", {255,255,255}, "^2LSMC : Victime stabilisé !")
    end
    if name == "soigner" then
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer == -1 or closestDistance > 3.0 then
            ESX.ShowNotification("Pas de joueur proche")
        else
            local playerPed = GetPlayerPed(-1)
            Citizen.CreateThread(function()
                ESX.ShowNotification("soin en cours ...")
                TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
                Wait(10000)
                ClearPedTasks(playerPed)
                TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
                ESX.ShowNotification("victime soignée")
            end)
        end
    end
    if name == "reanimer" then
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer == -1 or closestDistance > 10.0 then
            ESX.ShowNotification("personne à 10m")
        else
            local closestPlayerPed = GetPlayerPed(closestPlayer)
            local health = GetEntityHealth(closestPlayerPed)
            if health == 0 then
                local playerPed = GetPlayerPed(-1)
                Citizen.CreateThread(function()
                    ESX.ShowNotification("aucun pouls, je pose le défibrillateur")
                    TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
                    Wait(5000)
                    ESX.ShowNotification("attention, je vais choquer")
                    Wait(3000)
                    ClearPedTasks(playerPed)
                    if GetEntityHealth(closestPlayerPed) == 0 then
                        TriggerServerEvent('esx_ambulancejob:revive', GetPlayerServerId(closestPlayer))
                        ESX.ShowNotification("1, 2, 3 CHOC")
                    else
                        ESX.ShowNotification("erreur inconnu")
                    end
                end)
            else
                ESX.ShowNotification("pas inconcient")
            end
        end
    end
    if name == "reanimer2" then
        Citizen.CreateThread(function()
            TaskStartScenarioInPlace(GetPlayerPed(-1), 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
            Citizen.Wait(8000)
            ClearPedTasks(GetPlayerPed(-1));
            --TriggerEvent('chatMessage', "", {255,255,255}, "x : " .. pos.x .. " | y : " .. pos.y)
            TriggerServerEvent('LSFD:reanimation2', patient_actuel)
        end)
    end
    if name == "reanimer3" then
        Citizen.CreateThread(function()
            --TriggerEvent('chatMessage', "", {255,255,255}, "x : " .. pos.x .. " | y : " .. pos.y)
            TriggerServerEvent('LSFD:reanimation2', patient_actuel)
            Citizen.Wait(200)
            TriggerServerEvent('LSFD_downtreuil3', patient_actuel)
        end)
    end
    if name == "accroupir" then
        Citizen.CreateThread(function()
            TaskStartScenarioInPlace(GetPlayerPed(-1), 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
        end)
    end
    if name == "saveV" then
        lasthelico = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        MSG_down("~o~Pilote : ~g~Treuil attaché", 2000)
    end
    if name == "gotoV" then
        if IsVehicleSeatFree(lasthelico, 1) then
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), lasthelico, 1)
        elseif IsVehicleSeatFree(lasthelico, 2) then
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), lasthelico, 2)
        else
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), lasthelico, -2)
        end
    end
    if name == "tpAllV" then
        local pos = GetEntityCoords(GetPlayerPed(-1), 1)
		TriggerServerEvent('LSFD_helitreuil', PlayerId(), pos['x'], pos['y'])
        MSG_down("~o~Pilote : ~g~10-4 je vous remonte", 2000)
    end
    if name == "leaveAllV" then
		TriggerServerEvent('LSFD_downtreuil', PlayerId())
        MSG_down("~o~Pilote : ~g~10-4 je vous sort", 2000)
    end
    if name == "delcar" then
        deleteJobCar()
    end
    if name == "repair" then
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        SetVehicleBodyHealth(vehicle, 1000.0)
        SetVehicleEngineHealth(vehicle, 1000.0)
        SetEntityHealth(vehicle,1000)
        SetVehiclePetrolTankHealth(vehicle,1000.0)
        SetVehicleEngineOn(vehicle, 0, 0, 0)
        SetVehicleBodyHealth(vehicle, 1000.0)
        SetVehicleFixed(vehicle)
        SetVehicleEngineTorqueMultiplier(vehicle,1.0)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleUndriveable(vehicle, false)
    end
    if name == "opendoor" then
        Citizen.CreateThread(function()
            MSG_down("~o~Fifi : ~g~Ok je touvre ça", 2000)
            local LastPosX, LastPosY, LastPosZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
            local vehi = GetClosestVehicle(LastPosX, LastPosY, LastPosZ, tonumber('5.0'), 0, 0)
            SetEntityAsMissionEntity(vehi, true, true)
            SetVehicleHasBeenOwnedByPlayer(vehi,true)
            TriggerServerEvent('LSFD_downtreuil3', LastPosX, LastPosY, LastPosZ)
            TaskEveryoneLeaveVehicle(vehi)
            for index,value in ipairs({-1,0,1,2,3,4,5,6,7,8,9,10}) do
                if IsVehicleSeatFree(vehi, value) then
                    -- no
                else
                    TaskLeaveVehicle(GetPedInVehicleSeat(vehi, value), vehi, 16)
                end
            end
            Wait(100)

            SetVehicleDoorOpen(vehi, 0, 0, 0)
            SetVehicleDoorOpen(vehi, 1, 0, 0)
            SetVehicleDoorOpen(vehi, 2, 0, 0)
            SetVehicleDoorOpen(vehi, 3, 0, 0)
            SetVehicleDoorOpen(vehi, 4, 0, 0)
            SetVehicleDoorOpen(vehi, 5, 0, 0)
            SetVehicleDoorOpen(vehi, 6, 0, 0)
            SetVehicleDoorOpen(vehi, 7, 0, 0)

        end)
    end
end



RegisterNetEvent('LSFD_helitreuil2')

AddEventHandler('LSFD_helitreuil2', function(ID, x, y)
    Citizen.CreateThread(function()
        local pos2 = GetEntityCoords(GetPlayerPed(-1), 1)
        if GetDistance(x, y, pos2['x'], pos2['y']) <= 25 then
            local helico = GetVehiclePedIsIn(GetPlayerPed(ID), false)
            if GetVehiclePedIsIn(GetPlayerPed(-1), false) == helico then
            else
                Wait(math.random(10, 999))
                if IsVehicleSeatFree(helico, 1) then
                    TaskWarpPedIntoVehicle(GetPlayerPed(-1), helico, 1)
                elseif IsVehicleSeatFree(helico, 2) then
                    TaskWarpPedIntoVehicle(GetPlayerPed(-1), helico, 2)
                else
                    TaskWarpPedIntoVehicle(GetPlayerPed(-1), helico, -2)
                end
            end
        end
    end)
end)

RegisterNetEvent('LSFD_helitreuil4')

AddEventHandler('LSFD_helitreuil4', function(ID)
    Citizen.CreateThread(function()
        local helico = GetVehiclePedIsIn(GetPlayerPed(ID), false)
        if GetVehiclePedIsIn(GetPlayerPed(-1), false) == helico then
        else
            if IsVehicleSeatFree(helico, 1) then
                TaskWarpPedIntoVehicle(GetPlayerPed(-1), helico, 1)
            elseif IsVehicleSeatFree(helico, 2) then
                TaskWarpPedIntoVehicle(GetPlayerPed(-1), helico, 2)
            else
                TaskWarpPedIntoVehicle(GetPlayerPed(-1), helico, -2)
            end
        end
    end)
end)

RegisterNetEvent('LSFD_downtreuil2')

AddEventHandler('LSFD_downtreuil2', function(ID)
    Citizen.CreateThread(function()
        if ID == PlayerId() then
        else
            local helico = GetVehiclePedIsIn(GetPlayerPed(ID), false)
            if GetVehiclePedIsIn(GetPlayerPed(-1), false) == helico then
                TaskLeaveVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
            end
        end
    end)
end)

RegisterNetEvent('LSFD_downtreuil4')

AddEventHandler('LSFD_downtreuil4', function(a, b, c)
    Citizen.CreateThread(function()
        local helico = GetClosestVehicle(a, b, c, tonumber('5.0'), 0, 0)
        if GetVehiclePedIsIn(GetPlayerPed(-1), false) == helico then
            TaskLeaveVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 16)
        end
    end)
end)


---------------- MISSION ---------N3MTV
function Lauch_Mission(menu_data)
    --TriggerServerEvent("LSFD:newCall", "Mission auto : " .. menu_data.text, menu_data.x, menu_data.y)
    TriggerServerEvent('dispatch:addInter', menu_data.text or "", "Ceci est un entrainement pompier, merci de n'envoyer que des pompiers sauf contre-indication", "pompier", {x = menu_data.x, y = menu_data.y, z = 50})
end


function Start_Mission (id)
    if id == 1 then
        -- feux sur le stade hippique
        missionData[1].active = true
        Citizen.CreateThread(function()
            while missionData[1].active == true do
                Wait(10000) -- toutes les 10 sec
                StartScriptFire(tonumber("1149.1"), tonumber("125.1"), tonumber("82.1"), 20, false)
            end
        end)
    elseif id == 2 then

    elseif id == 3 then
        -- feux dans la maison de lester
        missionData[3].active = true
        Citizen.CreateThread(function()
            while missionData[3].active == true do
                Wait(10000) -- toutes les 10 sec
                StartScriptFire(tonumber("1274.08"), tonumber("-1711.43"), tonumber("54.01"), 20, false)
                StartScriptFire(tonumber("1269.42"), tonumber("-1710.12"), tonumber("54.01"), 20, false)
            end
        end)

    elseif id == 4 then
        -- feux sur le stade de foot
        missionData[4].active = true
        Citizen.CreateThread(function()
            while missionData[4].active == true do
                Wait(10000) -- toutes les 10 sec
                StartScriptFire(tonumber("772.79"), tonumber("-233.97"), tonumber("65.9"), 20, false)
            end
        end)

    elseif id == 5 then
        -- feux sur un parking
        missionData[5].active = true
        Citizen.CreateThread(function()
            while missionData[5].active == true do
                Wait(10000) -- toutes les 10 sec
                StartScriptFire(tonumber("704.92"), tonumber("-288.91"), tonumber("59.01"), 20, false)
            end
        end)

    elseif id == 6 then
        -- feux sur le terain de tennis
        missionData[6].active = true
        Citizen.CreateThread(function()
            while missionData[6].active == true do
                Wait(10000) -- toutes les 10 sec
                StartScriptFire(tonumber("477.34"), tonumber("-245.52"), tonumber("53.2"), 20, false)
            end
        end)

    elseif id == 7 then
        -- feux dans la maison de lester
        missionData[7].active = true
        Citizen.CreateThread(function()
            while missionData[7].active == true do
                Wait(10000) -- toutes les 10 sec
                StartScriptFire(tonumber("205.73"), tonumber("-719.96"), tonumber("46.8"), 20, false)
            end
        end)

    elseif id == 8 then
        -- feux dans la maison de lester
        missionData[8].active = true
        Citizen.CreateThread(function()
            while missionData[8].active == true do
                Wait(10000) -- toutes les 10 sec
                StartScriptFire(tonumber("-90.94"), tonumber("-2366.12"), tonumber("14.2"), 20, false)
            end
        end)

    elseif id == 9 then
        -- feux dans la maison de lester
        missionData[9].active = true
        Citizen.CreateThread(function()
            while missionData[9].active == true do
                Wait(10000) -- toutes les 10 sec
                StartScriptFire(tonumber("550.14"), tonumber("-1848.61"), tonumber("25.01"), 20, false)
            end
        end)

    elseif id == 10 then
        -- feux dans la maison de lester
        missionData[10].active = true
        Citizen.CreateThread(function()
            while missionData[10].active == true do
                Wait(10000) -- toutes les 10 sec
                StartScriptFire(tonumber("866.08"), tonumber("-905.82"), tonumber("25.72"), 20, false)
            end
        end)
    end
end


function End_Mission (id)
    if id == 1 then
        -- feux sur le stade hippique
        missionData[1].active = false
    elseif id == 2 then

    elseif id == 3 then
        -- feux dans la maison de lester
        missionData[3].active = false

    elseif id == 4 then
        -- feux dans la maison de lester
        missionData[4].active = false

    elseif id == 5 then
        -- feux dans la maison de lester
        missionData[5].active = false

    elseif id == 6 then
        -- feux dans la maison de lester
        missionData[6].active = false

    elseif id == 7 then
        -- feux dans la maison de lester
        missionData[7].active = false

    elseif id == 8 then
        -- feux dans la maison de lester
        missionData[8].active = false

    elseif id == 9 then
        -- feux dans la maison de lester
        missionData[9].active = false

    elseif id == 10 then
        -- feux dans la maison de lester
        missionData[10].active = false
    end
end



--[[ MISSION SCRIPT

StartScriptFire(tonumber("x"), tonumber("y"), tonumber("z"), 20, false)

AddExplosion(tonumber("x"), tonumber("y"), tonumber("z"), "EXPLOSION_CAR", tonumber('damagescale'), true, true, tonumber('0.0'))

ExplodeVehicle(vehicle, true, true)

Citizen.CreateThread(function()
    local car1 = SpawnMISSIONCar(hashname, x, y, z, dir, params)
end)


https://runtime.fivem.net/doc/reference.html#_0xE2A2AA2F659D77A7
https://runtime.fivem.net/doc/reference.html#_0x0FA6E4B75F302400


   END   ]]

RegisterNetEvent('LSFD:isNearRea')
AddEventHandler('LSFD:isNearRea', function(x, y)
    local pos = GetEntityCoords(GetPlayerPed(-1), 1)
    local dist = GetDistance(pos.x, pos.y, x, y)
    if dist < 2 then
        TriggerEvent('esx_ambulancejob:revive')
    end
end)
