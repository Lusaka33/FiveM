RegisterServerEvent('LSFD_helitreuil')

AddEventHandler('LSFD_helitreuil', function(ID, x, y)
    TriggerClientEvent('LSFD_helitreuil2', -1, ID, x, y)
end)


RegisterServerEvent('LSFD_helitreuil3')

AddEventHandler('LSFD_helitreuil3', function(ID)
    TriggerClientEvent('LSFD_helitreuil4', ID, source)
end)

RegisterServerEvent('LSFD_downtreuil')

AddEventHandler('LSFD_downtreuil', function(ID)
    TriggerClientEvent('LSFD_downtreuil2', -1, ID)
end)

RegisterServerEvent('LSFD_downtreuil3')

AddEventHandler('LSFD_downtreuil3', function(a, b, c)
    TriggerClientEvent('LSFD_downtreuil4', -1, a, b, c)
end)


local APPELS = {}

RegisterServerEvent('phone:call')
AddEventHandler('phone:call', function(service, raison, x, y, z)
    if service == "pompier" then
        if raison == "Annuler l'appel" then
            APPELS[source] = nil
            TriggerClientEvent('esx:showNotification', source, "18 : Votre appel à était supprimé")
        else
            APPELS[source] = {
                id = source,
                raison = raison,
                posX = x,
                posY = y,
                posZ = z
            }
            TriggerClientEvent('LSFD:newcall', -1, true)
            TriggerClientEvent('esx:showNotification', source, "18 : Votre appel à était enregistré, restez sur place jusqu'a l'arrivé des secours")
        end
    end
    local temp = {}
    for nb,value in pairs(APPELS) do
        if value ~= nil then
            table.insert(temp, value)
        end
    end
    TriggerClientEvent('LSFD:updatecall', -1, temp)
end)

RegisterServerEvent('LSFD:endcall')
AddEventHandler('LSFD:endcall', function(id)
    APPELS[id] = nil
    local temp = {}
    for nb,value in pairs(APPELS) do
        if value ~= nil then
            table.insert(temp, value)
        end
    end
    TriggerClientEvent('LSFD:updatecall', -1, temp)
end)

RegisterServerEvent('LSFD:sendNotif')
AddEventHandler('LSFD:sendNotif', function(id, msg)
    TriggerClientEvent('esx:showNotification', id, msg)
end)

------------------------ GESTION DES SERVICES / GRADES
--[[local grades = {
    {id = 1, name = 'formation', abr = 'Frm'},
    {id = 2, name = 'stagiaire', abr = 'Stag'},
    {id = 3, name = 'sapeur', abr = 'Sap'},
    {id = 4, name = 'caporal', abr = 'Cap'},
    {id = 5, name = 'lieutenant', abr = 'Ltn'},
    {id = 6, name = 'chef', abr = 'Chef'}
}


RegisterServerEvent('requestLSFDtakeService')
AddEventHandler('requestLSFDtakeService', function()
    local mysource = source
    local identifiers = GetPlayerIdentifiers(mysource)
    local steamid = identifiers[1]
    MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @mysteam AND job = 'pompier'", {['@mysteam'] = steamid}, function(result)
        if result[1] then
            TriggerClientEvent('validTakeLSFDservice', mysource, true, result[1].job_grade or 1)
            --if grades[result[1].grade] then
            --    TriggerClientEvent('radio_LSFDautoname', mysource, "^1(" .. grades[result[1].grade].abr .. " " .. result[1].prenom .. ")")
            --else
            --    TriggerClientEvent('radio_LSFDautoname', mysource, "^1(LSFD " .. result[1].prenom .. ")")
            --end
        else
            TriggerClientEvent('validTakeLSFDservice', mysource, false, 0)
        end
    end)
end)]]

RegisterServerEvent('LSFD:reanimation')
AddEventHandler('LSFD:reanimation', function(x, y)
    TriggerClientEvent('LSFD:isNearRea', -1, x, y)
end)

RegisterServerEvent('LSFD:reanimation2')
AddEventHandler('LSFD:reanimation2', function(id)
    TriggerEvent('esx_ambulancejob:revive', id)
end)