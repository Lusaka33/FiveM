ESX = nil
IsBlanching = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('entreprise:showPDG')
AddEventHandler('entreprise:showPDG', function(datas)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pdg_principal',
        {
            title    = 'Bureau - PDG',
            elements = {
                {label = 'Coffres', value = 'coffre'},
                {label = 'Employés', value = 'employer'},
                {label = 'Candidatures', value = 'candidature'},
                {label = 'Post-it', value = 'post_it'},
                {label = 'Armurerie', value = 'weapons'}
            }
        },
        function(data, menu)
            menu.close()
            if data.current.value == 'coffre' then
                menu_coffre(datas)
            end
            if data.current.value == 'employer' then
                menu_employer(datas)
            end
            if data.current.value == 'candidature' then
                menu_candidature(datas)
            end
            if data.current.value == 'post_it' then
                menu_post_it(datas)
            end
            if data.current.value == 'weapons' then
                menu_armurerie(datas)
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end)

RegisterNetEvent('entreprise:showsouschef')
AddEventHandler('entreprise:showsouschef', function(datas)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pdg_principal',
        {
            title    = 'Bureau - PDG',
            elements = {
                {label = 'Coffres', value = 'coffre'},
                {label = 'Employés', value = 'employer'},
                {label = 'Candidatures', value = 'candidature'},
                {label = 'Post-it', value = 'post_it'}
            }
        },
        function(data, menu)
            menu.close()
            if data.current.value == 'coffre' then
                menu_coffre_2(datas)
            end
            if data.current.value == 'employer' then
                menu_employer(datas)
            end
            if data.current.value == 'candidature' then
                menu_candidature(datas)
            end
            if data.current.value == 'post_it' then
                menu_post_it(datas)
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end)


RegisterNetEvent('entreprise:showEmployer')
AddEventHandler('entreprise:showEmployer', function(datas)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pdg_principal',
        {
            title    = 'Bureau - PDG',
            elements = {
                {label = 'Déposer de l\'argent', value = 'coffre'},
                {label = 'Post-it', value = 'post_it'}
            }
        },
        function(data, menu)
            menu.close()
            if data.current.value == 'coffre' then
                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 180)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0);
                    Wait(0);
                end
                if (GetOnscreenKeyboardResult()) then
                    TriggerServerEvent('entreprise:deposerPropre', datas.general.name, (tonumber(GetOnscreenKeyboardResult()) or 0))
                end
            end
            if data.current.value == 'post_it' then
                menu_post_it(datas)
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end)

RegisterNetEvent('entreprise:showVisiteur')
AddEventHandler('entreprise:showVisiteur', function(inc)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pdg_principal',
        {
            title    = 'Bureau - PDG',
            elements = {
                {label = 'Faire un don', value = 'coffre'},
                {label = 'Déposer une lettre', value = 'post_it'},
                {label = 'Déposer une candidature', value = 'candid'}
            }
        },
        function(data, menu)
            menu.close()
            if data.current.value == 'coffre' then
                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 180)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0);
                    Wait(0);
                end
                if (GetOnscreenKeyboardResult()) then
                    TriggerServerEvent('entreprise:deposerPropre', inc, (tonumber(GetOnscreenKeyboardResult()) or 0))
                end
            end
            if data.current.value == 'post_it' then
                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 180)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0);
                    Wait(0);
                end
                if (GetOnscreenKeyboardResult()) then
                    TriggerServerEvent('entreprise:addPostit', inc, (GetOnscreenKeyboardResult() or "nothing"))
                end
            end
            if data.current.value == 'candid' then
                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "Votre motivation ?", "", "", "", 180)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0);
                    Wait(0);
                end
                if (GetOnscreenKeyboardResult()) then
                    local mot = GetOnscreenKeyboardResult() or "__vide__"
                    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "Votre parcours professionel ?", "", "", "", 180)
                    while (UpdateOnscreenKeyboard() == 0) do
                        DisableAllControlActions(0);
                        Wait(0);
                    end
                    if (GetOnscreenKeyboardResult()) then
                        TriggerServerEvent('entreprise:addCandid', inc, mot, (GetOnscreenKeyboardResult() or "__vide__"))
                    end
                end
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end)



function menu_coffre (datas)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pdg_coffre',
        {
            title    = "Logiciel de comptabilité",
            elements = {
                {label = 'Argent propre : ' .. datas.general.propre .. ' $', value = 'no'},
                {label = 'Déposer Argent propre', value = 'depositpropre'},
                {label = 'Retirer Argent propre', value = 'retirerpropre'},
                {label = 'Argent sale : ' .. datas.general.sale .. ' $', value = 'no'},
                {label = 'Déposer Argent sale', value = 'depositsale'},
                {label = 'Retirer Argent sale', value = 'retirersale'},
                {label = 'Blanchir', value = 'blanchir'}
            }
        },
        function(data, menu)
            if data.current.value == 'depositpropre' then
                menu.close()
                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 180)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0);
                    Wait(0);
                end
                if (GetOnscreenKeyboardResult()) then
                    TriggerServerEvent('entreprise:deposerPropre', datas.general.name, (tonumber(GetOnscreenKeyboardResult()) or 0))
                end
            end
            if data.current.value == 'retirerpropre' then
                menu.close()
                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 180)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0);
                    Wait(0);
                end
                if (GetOnscreenKeyboardResult()) then
                    TriggerServerEvent('entreprise:retirerPropre', datas.general.name, (tonumber(GetOnscreenKeyboardResult()) or 0))
                end
            end
            if data.current.value == 'depositsale' then
                menu.close()
                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 180)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0);
                    Wait(0);
                end
                if (GetOnscreenKeyboardResult()) then
                    TriggerServerEvent('entreprise:deposerSale', datas.general.name, (tonumber(GetOnscreenKeyboardResult()) or 0))
                end
            end
            if data.current.value == 'retirersale' then
                menu.close()
                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 180)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0);
                    Wait(0);
                end
                if (GetOnscreenKeyboardResult()) then
                    TriggerServerEvent('entreprise:retirerSale', datas.general.name, (tonumber(GetOnscreenKeyboardResult()) or 0))
                end
            end
            if data.current.value == 'blanchir' then
                menu.close()
                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 180)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0);
                    Wait(0);
                end
                if (GetOnscreenKeyboardResult()) then
                    Citizen.CreateThread(function()
                        if IsBlanching == false then
                            local somme = tonumber(GetOnscreenKeyboardResult()) or 0
                            local temps = somme * 60
                            if temps < 60000 then
                                temps = 60000
                            end
                            IsBlanching = true
                            ESX.ShowNotification("~g~Lester travaille dessus, il aura finit dans " .. temps / 1000 .. " secondes ( " .. temps / 60000 .. " minutes )")
                            Wait(temps)
                            IsBlanching = false
                            ESX.ShowNotification("~g~Lester à finit de blanchir")
                            TriggerServerEvent('entreprise:blanchir', datas.general.name, somme)
                        else
                            ESX.ShowNotification("~r~Lester est déja en train de blanchir")
                        end
                    end)
                end
            end
        end,
        function(data, menu)
            menu.close()
            TriggerEvent('entreprise:showPDG', datas)
        end
    )
end

function menu_coffre_2 (datas)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pdg_coffre',
        {
            title    = "Logiciel de comptabilité",
            elements = {
                {label = 'Argent propre : ' .. datas.general.propre .. ' $', value = 'no'},
                {label = 'Déposer Argent propre', value = 'depositpropre'},
                {label = 'Retirer Argent propre', value = 'retirerpropre'}
            }
        },
        function(data, menu)
            if data.current.value == 'depositpropre' then
                menu.close()
                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 180)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0);
                    Wait(0);
                end
                if (GetOnscreenKeyboardResult()) then
                    TriggerServerEvent('entreprise:deposerPropre', datas.general.name, (tonumber(GetOnscreenKeyboardResult()) or 0))
                end
            end
            if data.current.value == 'retirerpropre' then
                menu.close()
                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 180)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0);
                    Wait(0);
                end
                if (GetOnscreenKeyboardResult()) then
                    TriggerServerEvent('entreprise:retirerPropre', datas.general.name, (tonumber(GetOnscreenKeyboardResult()) or 0))
                end
            end
        end,
        function(data, menu)
            menu.close()
            TriggerEvent('entreprise:showPDG', datas)
        end
    )
end

function menu_employer (datas)
    ESX.UI.Menu.CloseAll()
    local els = {
        {label = "Embaucher un joueur [ID]", value = "recrut"}
    }
    for k,v in pairs(datas.employers) do
        table.insert(els, {label = "[" .. (datas.grades[v.job_grade].label or "inconnu") .. "] " .. v.prenom .. " " .. v.nom .. " : " .. v.phone_number, value = v})
    end
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pdg_employer',
        {
            title    = 'Liste des employés',
            elements = els
        },
        function(data, menu)
            menu.close()
            if data.current.value == "recrut" then
                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 180)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0);
                    Wait(0);
                end
                if (GetOnscreenKeyboardResult()) then
                    TriggerServerEvent('entreprise:recruter', datas.general.name, (tonumber(GetOnscreenKeyboardResult()) or 0))
                end
            else
                menu_employer_opt(datas, data.current.value)
            end
        end,
        function(data, menu)
            menu.close()
            TriggerEvent('entreprise:showPDG', datas)
        end
    )
end


function menu_employer_opt (datas, user)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pdg_employer_2',
        {
            title    = 'Fiche du personnel',
            elements = {
                {label = "prenom : " .. user.prenom, value = 'no'},
                {label = "nom : " .. user.nom, value = 'no'},
                {label = "grade : " .. (datas.grades[user.job_grade].label or "inconnu") .. " [" .. (user.job_grade or "unknow") .. "]", value = 'no'},
                {label = "télephone : " .. user.phone_number, value = 'no'},
                {label = "grade supérieur", value = 'grdsup'},
                {label = "grade inférieur", value = 'grdinf'},
                {label = "VIRER", value = 'rem'}
            }
        },
        function(data, menu)
            if data.current.value == 'grdsup' then
                menu.close()
                TriggerServerEvent('entreprise:setGrade', datas.general.name, user.identifier, user.job_grade + 1)
            end
            if data.current.value == 'grdinf' then
                menu.close()
                TriggerServerEvent('entreprise:setGrade', datas.general.name, user.identifier, user.job_grade - 1)
            end
            if data.current.value == 'rem' then
                menu.close()
                TriggerServerEvent('entreprise:virer', datas.general.name, user.identifier)
            end
        end,
        function(data, menu)
            menu.close()
            menu_employer(datas)
        end
    )
end


function menu_candidature (datas)
    ESX.UI.Menu.CloseAll()
    local els = {}
    for k,v in pairs(datas.candids) do
        table.insert(els, {label = "[" .. v.id .. "] " .. v.prenom .. " " .. v.nom, value = v})
    end
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pdg_candid',
        {
            title    = 'Pole emploi - candidatures',
            elements = els
        },
        function(data, menu)
            menu.close()
            menu_candid_opt(datas, data.current.value)
        end,
        function(data, menu)
            menu.close()
            TriggerEvent('entreprise:showPDG', datas)
        end
    )
end

function menu_candid_opt (datas, candid)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pdg_employer_2',
        {
            title    = 'Candidature n° ' .. candid.id,
            elements = {
                {label = "prenom : " .. candid.prenom, value = 'no'},
                {label = "nom : " .. candid.nom, value = 'no'},
                {label = "télephone : " .. candid.telephone, value = 'no'},
                {label = "métier actuel : " .. candid.metier, value = 'no'},
                {label = "Voir motivation", value = 'seeM'},
                {label = "Voir parcours pro", value = 'seeP'},
                {label = "Supprimer", value = 'rem'}
            }
        },
        function(data, menu)
            if data.current.value == 'seeM' then
                menu.close()
                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", candid.motivation or "", "", "", "", 180)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0);
                    Wait(0);
                end
                if (GetOnscreenKeyboardResult()) then
                end
            end
            if data.current.value == 'seeP' then
                menu.close()
                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", candid.parcours or "", "", "", "", 180)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0);
                    Wait(0);
                end
                if (GetOnscreenKeyboardResult()) then
                end
            end
            if data.current.value == 'rem' then
                menu.close()
                TriggerServerEvent('entreprise:remCandid', datas.general.name, candid.id)
            end
        end,
        function(data, menu)
            menu.close()
            menu_candidature(datas)
        end
    )
end

function menu_post_it (datas)
    ESX.UI.Menu.CloseAll()
    local els = {
        {label = "Ajouter un post-it", value = "add"}
    }
    for k,v in pairs(datas.post_it) do
        table.insert(els, {label = "[" .. v.id .. "] " .. v.writer, value = v})
    end
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pdg_post_it',
        {
            title    = 'Tableau - post-it',
            elements = els
        },
        function(data, menu)
            menu.close()
            if data.current.value == "add" then
                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 180)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0);
                    Wait(0);
                end
                if (GetOnscreenKeyboardResult()) then
                    TriggerServerEvent('entreprise:addPostit', datas.general.name, (GetOnscreenKeyboardResult() or "nothing"))
                end
            else
                menu_post_it_opt(datas, data.current.value)
            end
        end,
        function(data, menu)
            menu.close()
            TriggerEvent('entreprise:showPDG', datas)
        end
    )
end

function menu_post_it_opt (datas, candid)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pdg_employer_2',
        {
            title    = 'Post-it n° ' .. candid.id,
            elements = {
                {label = "de : " .. candid.writer, value = 'no'},
                {label = "Voir message", value = 'see'},
                {label = "Supprimer", value = 'rem'}
            }
        },
        function(data, menu)
            if data.current.value == 'see' then
                menu.close()
                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", candid.content or "", "", "", "", 180)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0);
                    Wait(0);
                end
                if (GetOnscreenKeyboardResult()) then
                end
            end
            if data.current.value == 'rem' then
                menu.close()
                TriggerServerEvent('entreprise:remPostit', datas.general.name, candid.id)
            end
        end,
        function(data, menu)
            menu.close()
            menu_post_it(datas)
        end
    )
end

function menu_armurerie (datas)
    ESX.UI.Menu.CloseAll()
    local els = {}
    for k,v in pairs(datas.armurerie) do
        local label = ESX.GetWeaponLabel(v.name) or v.name
        v.label = label
        table.insert(els, {label = label .. " " .. v.total .. "/" .. v.limit .. " (dispo: " .. v.dispo .. ") [" .. v.price .. "$]", value = v})
    end
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pdg_weap',
        {
            title    = 'Achetez des armes',
            elements = els
        },
        function(data, menu)
            menu.close()
            Citizen.CreateThread(function()
                ESX.ShowNotification("~g~Vous avez commandez : " .. data.current.value.label .. " x1 avec " .. data.current.value.ammo .. " munitions, elle arrivera dans 10 minutes")
                Wait(10 * 60 * 1000)
                ESX.ShowNotification("~g~Votre commande est arrivé  (récapitulatif : " .. data.current.value.label .. " x1 avec " .. data.current.value.ammo .. " munitions")
                TriggerServerEvent('entreprise:buyWeapon', datas.general.name, data.current.value.name)
            end)
        end,
        function(data, menu)
            menu.close()
            TriggerEvent('entreprise:showPDG', datas)
        end
    )
end

--------------- LOOP
function GetDistance (x1,y1,x2,y2)
    return math.abs(x1 - x2) + math.abs(y1 - y2)
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local coords = GetEntityCoords(GetPlayerPed(-1))
        for k,v in pairs(Entreprises) do
            if GetDistance(coords['x'], coords['y'], v.bureau.x, v.bureau.y) <= 10 then
                --DrawMarker(-1, v.bureau.x, v.bureau.y, v.bureau.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.9, 1.9, 1.1, 255, 87, 37, 100, false, true, 2, false, false, false, false)
                DrawMarker(1, v.bureau.x, v.bureau.y, v.bureau.z, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 255, 87, 34, 200, 0, 0, 0, 0)
                if GetDistance(coords['x'], coords['y'], v.bureau.x, v.bureau.y) <= 2 then
                    SetTextComponentFormat('STRING')
                    AddTextComponentString("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le bureau")
                    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                    if IsControlJustReleased(0, 38) then
                        TriggerServerEvent('entreprise:Bureau', k)
                    end
                end
            end
            if GetDistance(coords['x'], coords['y'], v.bureau2.x, v.bureau2.y) <= 10 then
                --DrawMarker(-1, v.bureau2.x, v.bureau2.y, v.bureau2.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.9, 1.9, 1.9, 255, 87, 37, 100, false, true, 2, false, false, false, false)
                DrawMarker(1, v.bureau2.x, v.bureau2.y, v.bureau2.z, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 255, 87, 34, 200, 0, 0, 0, 0)
                if GetDistance(coords['x'], coords['y'], v.bureau2.x, v.bureau2.y) <= 2 then
                    SetTextComponentFormat('STRING')
                    AddTextComponentString("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le bureau")
                    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                    if IsControlJustReleased(0, 38) then
                        TriggerServerEvent('entreprise:Bureau', k)
                    end
                end
            end
            if GetDistance(coords['x'], coords['y'], v.armurerie.x, v.armurerie.y) <= 10 then
                DrawMarker(1, v.armurerie.x, v.armurerie.y, v.armurerie.z, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 255, 87, 34, 200, 0, 0, 0, 0)
                --DrawMarker(-1, v.armurerie.x, v.armurerie.y, v.armurerie.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.9, 1.9, 1.9, 255, 87, 37, 100, false, true, 2, false, false, false, false)
                if GetDistance(coords['x'], coords['y'], v.armurerie.x, v.armurerie.y) <= 2 then
                    SetTextComponentFormat('STRING')
                    AddTextComponentString("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir l'armurerie")
                    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                    if IsControlJustReleased(0, 38) then
                        ESX.TriggerServerCallback('esx_service:isInService', function(toogle)
                            if toogle == true then
                                TriggerServerEvent('entreprise:loadArmurerie', k)
                            else
                                ESX.ShowNotification("Tu n'est pas en service, ou tu n'a pas le bon métier")
                            end
                        end, k)
                    end
                end
            end
            if GetDistance(coords['x'], coords['y'], v.coffre.x, v.coffre.y) <= 10 then
                DrawMarker(1, v.coffre.x, v.coffre.y, v.coffre.z, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 255, 87, 34, 200, 0, 0, 0, 0)
                --DrawMarker(-1, v.coffre.x, v.coffre.y, v.coffre.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.9, 1.9, 1.9, 255, 87, 37, 100, false, true, 2, false, false, false, false)
                if GetDistance(coords['x'], coords['y'], v.coffre.x, v.coffre.y) <= 2 then
                    SetTextComponentFormat('STRING')
                    AddTextComponentString("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le coffre de l'entreprise")
                    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                    if IsControlJustReleased(0, 38) then
                        ESX.TriggerServerCallback('esx_service:isInService', function(toogle)
                            if toogle == true then
                                TriggerServerEvent('entreprise:loadCoffre', k)
                            else
                                ESX.ShowNotification("Tu n'est pas en service, ou tu n'a pas le bon métier")
                            end
                        end, k)
                    end
                end
            end
            if GetDistance(coords['x'], coords['y'], v.vestiaire.x, v.vestiaire.y) <= 10 then
                DrawMarker(1, v.vestiaire.x, v.vestiaire.y, v.vestiaire.z, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 255, 87, 34, 200, 0, 0, 0, 0)
                --DrawMarker(-1, v.vestiaire.x, v.vestiaire.y, v.vestiaire.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.9, 1.9, 1.9, 255, 87, 37, 100, false, true, 2, false, false, false, false)
                if GetDistance(coords['x'], coords['y'], v.vestiaire.x, v.vestiaire.y) <= 2 then
                    SetTextComponentFormat('STRING')
                    AddTextComponentString("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir votre vestiaire")
                    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                    if IsControlJustReleased(0, 38) then
                        ESX.TriggerServerCallback('esx_service:isInService', function(toogle)
                            if toogle == true then
                                TriggerServerEvent('entreprise:loadVestiaire', k)
                            else
                                ESX.ShowNotification("Tu n'est pas en service, ou tu n'a pas le bon métier")
                            end
                        end, k)
                    end
                end
            end
        end
    end
end)
