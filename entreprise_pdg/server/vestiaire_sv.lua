vestiaires = {}

----------------------------------- MODIFIED by @loulou123546


function getCarPoid_2 (steam)
  local poid = 0
  for k,v in pairs(vestiaires[steam].item  or {}) do
    poid = poid + ((v.ppi or 0) * (v.count or 1))
  end
  for k,v in pairs(vestiaires[steam].weapon or {}) do
    poid = poid + ((v.ppi or 0) * (v.count or 1))
  end
  return poid
end

RegisterServerEvent('entreprise:loadVestiaire')
AddEventHandler('entreprise:loadVestiaire', function(job)
  local _source = source
  local xPlayer  = ESX.GetPlayerFromId(_source)
  local car_i = {}
  local car_weap = {}
  local player_i = {}
  local steam = GetPlayerIdentifiers(_source)[1]


  if ESX ~= nil then
    TriggerClientEvent('esx:showNotification', _source, 'ESX : check')
    if ESX.Items ~= nil then
      local testtttt = 0
      for k,v in pairs(ESX.Items) do
        testtttt = testtttt + 1
      end
      TriggerClientEvent('esx:showNotification', _source, 'ESX.Items : check |' .. (#ESX.Items or 0) .. " | " .. testtttt)
      if ESX.Items['water'] ~= nil then
        TriggerClientEvent('esx:showNotification', _source, 'ESX.Items[\'water\'] : check')
        if ESX.Items['water'].ppi ~= nil then
          TriggerClientEvent('esx:showNotification', _source, 'ESX.Items[\'water\'].ppi : check | ' .. (ESX.Items['water'].ppi or "none"))
        end
      end
    end
  end



  if xPlayer.job.name == job then
  

    if vestiaires[steam] ~= nil then
      car_i = vestiaires[steam].item
      car_weap = vestiaires[steam].weapon

      local play_inv = xPlayer.getInventory()
      for nb,value in pairs(play_inv) do
          table.insert(player_i, {
            label = value.label .. " x" .. value.count .. " [" .. ((value.ppi / 10) * value.count) .. "kg]",
            count = value.count,
            name = value.label,
            type = "item",
            ppi = value.ppi,
            value = value.name
          })
      end

      TriggerClientEvent('entreprise:displayVestiaire', _source, job, car_i, car_weap, player_i)

    else
      MySQL.Async.fetchAll('SELECT * FROM `vestiaires` WHERE `identifier` = @plate', {['@plate'] = steam}, function(item_car)
        car_i = item_car
        for nb,value in pairs(car_i) do
          car_i[nb].ppi = ESX.Items[value.name].ppi or 0
          car_i[nb].label = ESX.Items[value.name].label or "|" .. value.name .. "|"
        end
        MySQL.Async.fetchAll('SELECT * FROM `vestiaires_inventory` WHERE `identifier` = @plate', {['@plate'] = steam}, function(data_car)
          if data_car[1] ~= nil then 
            car_weap = json.decode(data_car[1].weapons) or {}
            vestiaires[steam] = {
              item = car_i,
              weapon = car_weap
            }
          else
            car_weap = {}
            vestiaires[steam] = {
              item = car_i,
              weapon = car_weap
            }
            MySQL.Async.execute("INSERT INTO `vestiaires_inventory` (`identifier`,`weapons`) VALUES (@plate,'[]')", {['@plate'] = steam})
          end

          local play_inv = xPlayer.getInventory()
          for nb,value in pairs(play_inv) do
              table.insert(player_i, {
                label = value.label .. " x" .. value.count .. " [" .. ((value.ppi / 10) * value.count) .. "kg]",
                name = value.label,
                count = value.count,
                ppi = value.ppi,
                type = "item",
                value = value.name
              })
          end

          TriggerClientEvent('entreprise:displayVestiaire', _source, job, car_i, car_weap, player_i)
        end)
      end)
    end
  else
    TriggerClientEvent('esx:showNotification', _source, 'Vous ne travaillez pas ici')
  end
end)

RegisterServerEvent('entreprise:item_AddInVestiaire')
AddEventHandler('entreprise:item_AddInVestiaire', function(job, name, qty)
  local _source = source
  local xPlayer  = ESX.GetPlayerFromId(_source)
  local steam = GetPlayerIdentifiers(_source)[1]

  if qty >= 0 then

    if (xPlayer.getInventoryItem(name).count or 0) - qty >= 0 then

      if (getCarPoid_2(steam) + ((ESX.Items[name].ppi or 0) * qty)) <= 100 then

        local act_item = {}
        local act_nb = 0
        for nb,value in pairs(vestiaires[steam].item) do
          if value.name == name then
            act_item = value
            act_nb = nb
          end
        end
        if act_nb == 0 then
          MySQL.Async.execute("INSERT INTO `vestiaires` (`identifier`,`name`,`count`) VALUES (@a,@b,@c)", {['@a'] = steam,['@b'] = name,['@c'] = qty})
          table.insert(vestiaires[steam].item, {name = name, label = (ESX.Items[name].label or "|" .. name .. "|"), count = qty, identifier = steam, ppi = (ESX.Items[name].ppi or 0)})
          xPlayer.removeInventoryItem(name, qty)
        else
          vestiaires[steam].item[act_nb].count = vestiaires[steam].item[act_nb].count + qty
          MySQL.Async.execute('UPDATE `vestiaires` SET `count`= `count` + @qty WHERE `identifier` = @plate AND `name` = @item', {['@plate'] = steam, ['@qty'] = qty, ['@item'] = name})
          xPlayer.removeInventoryItem(name, qty)
        end

      else
        TriggerClientEvent('esx:showNotification', _source, 'Vous n\'avez pas assez de place dans le coffre')
      end
    
    else
      TriggerClientEvent('esx:showNotification', _source, 'Vous n\'avez pas assez d\'item sur vous')
    end
  else
    qty = 0 - qty
    local act_item = {notexist = true}
    local act_nb = 0
    for nb,value in pairs(vestiaires[steam].item) do
      if value.name == name then
        act_item = value
        act_nb = nb
      end
    end

    if act_nb == 0 then
      TriggerClientEvent('esx:showNotification', _source, 'ERREUR : l\'item que vous chercher est introuvable, retentez')
    else

      if act_item.count - qty >= 0 then

        if xPlayer.getInvPoid() + (act_item.ppi * qty) <= 100 then

          vestiaires[steam].item[act_nb].count = vestiaires[steam].item[act_nb].count - qty
          MySQL.Async.execute('UPDATE `vestiaires` SET `count`= `count` - @qty WHERE `job` = @plate AND `name` = @item', {['@plate'] = job, ['@qty'] = qty, ['@item'] = name})
          xPlayer.addInventoryItem(name, qty)

        else
          TriggerClientEvent('esx:showNotification', _source, 'Vous n\'avez pas assez de place sur vous')
        end
      else
        TriggerClientEvent('esx:showNotification', _source, 'Vous n\'avez pas assez d\'item dans le coffre')
      end
    end
  end
end)


RegisterServerEvent('entreprise:weapon_AddInVestiaire')
AddEventHandler('entreprise:weapon_AddInVestiaire', function(job, name, label, ammo, ppi, qty)
  local _source = source
  local xPlayer  = ESX.GetPlayerFromId(_source)
  local play_wea = xPlayer.getLoadout()
  local steam = GetPlayerIdentifiers(_source)[1]

  if qty >= 0 then

    local haveIt = false
    for nb,value in pairs(play_wea) do
      if value.name == name then
        haveIt = value
      end
    end

    if haveIt == false then
      TriggerClientEvent('esx:showNotification', _source, 'Vous n\'avez pas l\'arme : ' .. label)
    else

      if vestiaires[steam] ~= nil then

        local ChaveIt = false
        for nb,value in pairs(vestiaires[steam].weapon) do
          if value.name == name then
            ChaveIt = value
          end
        end

        if (getCarPoid_2(plate) + (ppi or 0)) <= 100 then

          if ChaveIt == false then
            table.insert(vestiaires[steam].weapon, {
              name = name,
              label = label,
              ammo = ammo,
              ppi = ppi,
              count = 1
            })
            xPlayer.removeWeapon(name)
            MySQL.Async.execute('UPDATE `vestiaires_inventory` SET `weapons`= @wea WHERE `identifier` = @plate', {['@plate'] = steam, ['@wea'] = json.encode(vestiaires[steam].weapon)})
          else
            xPlayer.removeWeapon(name)
            for nb,value in pairs(vestiaires[steam].weapon) do
              if value.name == name then
                if ChaveIt.ammo < ammo then
                  vestiaires[steam].weapon[nb].ammo = ammo
                end
                vestiaires[steam].weapon[nb].count = vestiaires[steam].weapon[nb].count + 1
              end
            end
            MySQL.Async.execute('UPDATE `vestiaires_inventory` SET `weapons`= @wea WHERE `identifier` = @plate', {['@plate'] = steam, ['@wea'] = json.encode(vestiaires[steam].weapon)})
          end

        else
          TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas assez de place dans le vestiaire")
        end

      else
        TriggerClientEvent('esx:showNotification', _source, "ERREUR : opération annulé suite à un bug, réessaye")
      end

    end

  else
    qty = 0 - qty

    local haveIt = false
    for nb,value in pairs(play_wea) do
      if value.name == name then
        haveIt = value
      end
    end

    if haveIt == false then

      if vestiaires[steam] ~= nil then

        local ChaveIt = false
        for nb,value in pairs(vestiaires[steam].weapon) do
          if value.name == name then
            ChaveIt = value
          end
        end

        if ChaveIt == false then
          TriggerClientEvent('esx:showNotification', _source, "Il n'y a pas cette arme dans le vestiaire")
        else
          if xPlayer.getInvPoid() + ppi <= 100 then
            for nb,value in pairs(vestiaires[steam].weapon) do
              if value.name == name then
                if value.count > 1 then
                  vestiaires[steam].weapon[nb].count = vestiaires[steam].weapon[nb].count - 1
                else
                  vestiaires[steam].weapon[nb].ammo = 0
                  vestiaires[steam].weapon[nb].count = 0
                  vestiaires[steam].weapon[nb] = nil
                end
              end
            end
            xPlayer.addWeapon(name, ammo)
            MySQL.Async.execute('UPDATE `vestiaires_inventory` SET `weapons`= @wea WHERE `identifier` = @plate', {['@plate'] = steam, ['@wea'] = json.encode(vestiaires[steam].weapon)})
          else
            TriggerClientEvent('esx:showNotification', _source, "Tu n'a pas assez de place sur toi")
          end
        end

      else
        TriggerClientEvent('esx:showNotification', _source, "ERREUR : opération annulé suite à un bug, réessaye")
      end

    else
      TriggerClientEvent('esx:showNotification', _source, 'Vous avez deja l\'arme : ' .. label)
    end
  end
end)