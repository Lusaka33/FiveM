ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('entreprise:Bureau')
AddEventHandler('entreprise:Bureau', function(inc)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == inc then
        TriggerClientEvent('esx:showNotification', source, "tu est flic : chargement")
        if Entreprises[inc].Sdata ~= nil then
            TriggerClientEvent('esx:showNotification', source, "chargement depuis local")
            if xPlayer.job.grade_name == Entreprises[inc].Sdata.general.grade_pdg then
                TriggerClientEvent('esx:showNotification', source, "mode : patron")
                TriggerClientEvent('entreprise:showPDG', source, Entreprises[inc].Sdata)
            elseif xPlayer.job.grade_name == Entreprises[inc].Sdata.general.grade_souschef then
                TriggerClientEvent('esx:showNotification', source, "mode : sous chef")
                TriggerClientEvent('entreprise:showsouschef', source, Entreprises[inc].Sdata)
            else
                TriggerClientEvent('esx:showNotification', source, "mode : employer")
                TriggerClientEvent('entreprise:showEmployer', source, Entreprises[inc].Sdata)
            end
        else
            TriggerClientEvent('esx:showNotification', source, "chargement depuis MySQL")
            MySQL.Async.fetchAll("SELECT * FROM entreprises WHERE job = @a", {['@a'] = inc}, function(result1)
                local entreprises_data = result1 or {}
                MySQL.Async.fetchAll("SELECT * FROM candidatures WHERE job = @a", {['@a'] = inc}, function(result2)
                    local candid_data = result2 or {}
                    MySQL.Async.fetchAll("SELECT * FROM post_it WHERE job = @a", {['@a'] = inc}, function(result3)
                        local postit_data = result3 or {}
                        MySQL.Async.fetchAll("SELECT * FROM users WHERE job = @a", {['@a'] = inc}, function(result4)
                            local employe_data = result4 or {}
                            MySQL.Async.fetchAll("SELECT * FROM entreprise_weapons WHERE job = @a", {['@a'] = inc}, function(result5)
                                local weapon_data = result5 or {}
                                MySQL.Async.fetchAll("SELECT * FROM entreprise_inventory WHERE job = @a", {['@a'] = inc}, function(result6)
                                    local inventory_data = result6 or {}
                                    MySQL.Async.fetchAll("SELECT * FROM `job_grades` WHERE `job_name` = @job_name", {['@job_name'] = inc}, function(result7)
                                        local grade_data = result7 or {}
                                        local list_grades = {}
                                        for k,v in pairs(grade_data) do
                                            list_grades[v.grade] = v
                                        end
                                        Entreprises[inc].Sdata = {
                                            me = {
                                                grade_label = xPlayer.job.grade_label,
                                                grade_int = xPlayer.job.grade
                                            },
                                            general = {
                                                name = inc,
                                                propre = entreprises_data[1].propre or 0,
                                                sale = entreprises_data[1].sale or 0,
                                                grade_pdg = entreprises_data[1].grade_pdg or 'boss',
                                                grade_souschef = entreprises_data[1].grade_souschef or 'boss',
                                                salaires = json.decode(entreprises_data[1].salaire) or {}
                                            },
                                            candids = candid_data or {},
                                            post_it = postit_data or {},
                                            employers = employe_data or {},
                                            armurerie = weapon_data or {},
                                            coffre = inventory_data or {},
                                            grades = list_grades or {}
                                        }
                                        if xPlayer.job.grade_name == Entreprises[inc].Sdata.general.grade_pdg then
                                            TriggerClientEvent('esx:showNotification', source, "mode : patron")
                                            TriggerClientEvent('entreprise:showPDG', source, Entreprises[inc].Sdata)
                                        elseif xPlayer.job.grade_name == Entreprises[inc].Sdata.general.grade_souschef then
                                            TriggerClientEvent('esx:showNotification', source, "mode : sous chef")
                                            TriggerClientEvent('entreprise:showsouschef', source, Entreprises[inc].Sdata)
                                        else
                                            TriggerClientEvent('esx:showNotification', source, "mode : employer")
                                            TriggerClientEvent('entreprise:showEmployer', source, Entreprises[inc].Sdata)
                                        end
                                    end)
                                end)
                            end)
                        end)
                    end)
                end)
            end)
        end
    else
        TriggerClientEvent('esx:showNotification', source, "tu n'est pas flic : mode visiteur")
        TriggerClientEvent('entreprise:showVisiteur', source, inc)
    end
end)