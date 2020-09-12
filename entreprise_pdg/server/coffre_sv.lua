coffre_entreprise = {}


----------------------------------- MODIFIED by @loulou123546


function getCarPoid (job)
  local poid = 0
  for k,v in pairs(coffre_entreprise[job]) do
    poid = poid + ((ESX.Items[v.name].ppi or 0) * v.count)
  end
  return poid
end

RegisterServerEvent('entreprise:loadCoffre')
AddEventHandler('entreprise:loadCoffre', function(job)
  local _source = source
  local xPlayer  = ESX.GetPlayerFromId(_source)
  if xPlayer.job.name == job then
    local car_i = {}
    local player_i = {}


    if coffre_entreprise[job] ~= nil then
      car_i = coffre_entreprise[job]

      local play_inv = xPlayer.getInventory()
      for nb,value in pairs(play_inv) do
          table.insert(player_i, {
            label = value.label .. " x" .. value.count .. " [" .. ((value.ppi / 10) * value.count) .. "kg]",
            count = value.count,
            name = value.label,
            ppi = value.ppi,
            value = value.name
          })
      end

      TriggerClientEvent('entreprise:displayCoffre', _source, job, car_i, player_i)

    else
      MySQL.Async.fetchAll('SELECT * FROM `entreprise_inventory` WHERE `job` = @plate', {['@plate'] = job}, function(item_car)
        car_i = item_car
        for nb,value in pairs(car_i) do
          car_i[nb].ppi = ESX.Items[value.name].ppi or 0
          car_i[nb].label = ESX.Items[value.name].label or "|" .. value.name .. "|"
        end
        coffre_entreprise[job] = car_i

        local play_inv = xPlayer.getInventory()
        for nb,value in pairs(play_inv) do
            table.insert(player_i, {
              label = value.label .. " x" .. value.count .. " [" .. ((value.ppi / 10) * value.count) .. "kg]",
              name = value.label,
              count = value.count,
              ppi = value.ppi,
              value = value.name
            })
        end
        TriggerClientEvent('entreprise:displayCoffre', _source, job, car_i, player_i)
      end)
    end
  else
    TriggerClientEvent('esx:showNotification', source, "Tu n'a pas accées à ça !")
  end
end)


RegisterServerEvent('entreprise:addItemCoffre')
AddEventHandler('entreprise:addItemCoffre', function(job, name, qty)
  local _source = source
  local xPlayer  = ESX.GetPlayerFromId(_source)

  if qty >= 0 then

    if (xPlayer.getInventoryItem(name).count or 0) - qty >= 0 then

      if (getCarPoid(job) + ((ESX.Items[name].ppi or 0) * qty)) <= 2500 then

        local act_item = {}
        local act_nb = 0
        for nb,value in pairs(coffre_entreprise[job]) do
          if value.name == name then
            act_item = value
            act_nb = nb
          end
        end
        if act_nb == 0 then
          MySQL.Async.execute("INSERT INTO `entreprise_inventory` (`job`,`name`,`count`) VALUES (@a,@b,@c)", {['@a'] = job,['@b'] = name,['@c'] = qty})
          table.insert(coffre_entreprise[job], {name = name, label = (ESX.Items[name].label or "|" .. name .. "|"), count = qty, job = job, ppi = (ESX.Items[name].ppi or 0)})
          xPlayer.removeInventoryItem(name, qty)
        else
          coffre_entreprise[job][act_nb].count = coffre_entreprise[job][act_nb].count + qty
          MySQL.Async.execute('UPDATE `entreprise_inventory` SET `count`= `count` + @qty WHERE `job` = @plate AND `name` = @item', {['@plate'] = job, ['@qty'] = qty, ['@item'] = name})
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
    for nb,value in pairs(coffre_entreprise[job]) do
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

          coffre_entreprise[job][act_nb].count = coffre_entreprise[job][act_nb].count - qty
          MySQL.Async.execute('UPDATE `entreprise_inventory` SET `count`= `count` - @qty WHERE `job` = @plate AND `name` = @item', {['@plate'] = job, ['@qty'] = qty, ['@item'] = name})
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

--[[
RegisterServerEvent('esx_truck_inventory:weapon_AddInCoffre')
AddEventHandler('esx_truck_inventory:weapon_AddInCoffre', function(plate, model, name, label, ammo, ppi, qty)
  local _source = source
  local xPlayer  = ESX.GetPlayerFromId(_source)
  local play_wea = xPlayer.getLoadout()

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

      if CARS[plate].car_d ~= nil then

        local ChaveIt = false
        for nb,value in pairs(CARS[plate].car_d.weapon) do
          if value.name == name then
            ChaveIt = value
          end
        end

        if (getCarPoid(plate) + (ppi or 0)) <= maxCapacity[model].size then

          if ChaveIt == false then
            table.insert(CARS[plate].car_d.weapon, {
              name = name,
              label = label,
              ammo = ammo,
              ppi = ppi,
              count = 1
            })
            xPlayer.removeWeapon(name)
            MySQL.Async.execute('UPDATE `truck_data` SET `weapons`= @wea WHERE `plate` = @plate', {['@plate'] = plate, ['@wea'] = json.encode(CARS[plate].car_d.weapon)})
          else
            xPlayer.removeWeapon(name)
            for nb,value in pairs(CARS[plate].car_d.weapon) do
              if value.name == name then
                if ChaveIt.ammo < ammo then
                  CARS[plate].car_d.weapon[nb].ammo = ammo
                end
                CARS[plate].car_d.weapon[nb].count = CARS[plate].car_d.weapon[nb].count + 1
              end
            end
            MySQL.Async.execute('UPDATE `truck_data` SET `weapons`= @wea WHERE `plate` = @plate', {['@plate'] = plate, ['@wea'] = json.encode(CARS[plate].car_d.weapon)})
          end

        else
          TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas assez de place dans le coffre")
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

      if CARS[plate].car_d ~= nil then

        local ChaveIt = false
        for nb,value in pairs(CARS[plate].car_d.weapon) do
          if value.name == name then
            ChaveIt = value
          end
        end

        if ChaveIt == false then
          TriggerClientEvent('esx:showNotification', _source, "Il n'y a pas cette arme dans le coffre")
        else
          if xPlayer.getInvPoid() + ppi <= 100 then
            for nb,value in pairs(CARS[plate].car_d.weapon) do
              if value.name == name then
                if value.count > 1 then
                  CARS[plate].car_d.weapon[nb].count = CARS[plate].car_d.weapon[nb].count - 1
                else
                  CARS[plate].car_d.weapon[nb].ammo = 0
                  CARS[plate].car_d.weapon[nb].count = 0
                  CARS[plate].car_d.weapon[nb] = nil
                end
              end
            end
            xPlayer.addWeapon(name, ammo)
            MySQL.Async.execute('UPDATE `truck_data` SET `weapons`= @wea WHERE `plate` = @plate', {['@plate'] = plate, ['@wea'] = json.encode(CARS[plate].car_d.weapon)})
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
end)]]