----------------------------------- MODIFIED by @loulou123546

RegisterServerEvent('entreprise:loadArmurerie')
AddEventHandler('entreprise:loadArmurerie', function(job)
  local _source = source
  local xPlayer  = ESX.GetPlayerFromId(_source)

  if xPlayer.job.name == job then
    MySQL.Async.fetchAll('SELECT * FROM `entreprise_weapons` WHERE `job` = @plate', {['@plate'] = job}, function(item_car)
          TriggerClientEvent('entreprise:displayArmurerie', _source, job, (item_car or {}))
    end)
  else
    TriggerClientEvent('esx:showNotification', _source, 'Vous ne travaillez pas ici')
  end
end)

RegisterServerEvent('entreprise:putArmurerie')
AddEventHandler('entreprise:putArmurerie', function(job, name)
  local _source = source
  local xPlayer  = ESX.GetPlayerFromId(_source)
  local play_wea = xPlayer.getLoadout()

    local haveIt = false
    for nb,value in pairs(play_wea) do
        if value.name == name then
        haveIt = value
        end
    end

    if haveIt == false then
        TriggerClientEvent('esx:showNotification', _source, 'Vous n\'avez pas cette arme')
    else
        xPlayer.removeWeapon(name)
        MySQL.Async.execute('UPDATE `entreprise_weapons` SET `dispo`= `dispo` + 1 WHERE `job` = @plate AND `name` = @a', {['@plate'] = job, ['@a'] = name})
    end
end)

RegisterServerEvent('entreprise:takeArmurerie')
AddEventHandler('entreprise:takeArmurerie', function(job, name)
  local _source = source
  local xPlayer  = ESX.GetPlayerFromId(_source)
  local play_wea = xPlayer.getLoadout()

    MySQL.Async.fetchAll("SELECT * FROM `entreprise_weapons` WHERE job = @a AND name = @b", {['@a'] = job, ['@b'] = name}, function(result1)
        if result1[1] ~= nil then
            local haveIt = false
            for nb,value in pairs(play_wea) do
                if value.name == name then
                    haveIt = value
                end
            end

            if haveIt == false then
                if result1[1].dispo >= 1 then
                    xPlayer.addWeapon(name, result1[1].ammo)
                    MySQL.Async.execute('UPDATE `entreprise_weapons` SET `dispo`= `dispo` - 1 WHERE `job` = @plate AND `name` = @a', {['@plate'] = job, ['@a'] = name})
                else
                    TriggerClientEvent('esx:showNotification', _source, 'Il n\'y a plus ce modèle d\'arme')
                end
            else
                TriggerClientEvent('esx:showNotification', _source, 'Vous avez deja cette arme')
            end
        else
            TriggerClientEvent('esx:showNotification', _source, 'Cette arme n\'est pas disponible pour le metier en question')
        end
    end)
end)