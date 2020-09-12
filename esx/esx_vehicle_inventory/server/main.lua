ESX = nil

CARS = {}

local maxCapacity = {
  [0] = { ["size"] = 400, ['cash'] = 15000, ['sale'] = 12500}, --Compact
  [1] = { ["size"] = 500, ['cash'] = 20000, ['sale'] = 17500}, --Sedan
  [2] = { ["size"] = 1000, ['cash'] = 30000, ['sale'] = 25000}, --SUV
  [3] = { ["size"] = 250, ['cash'] = 12500, ['sale'] = 10000}, --Coupes
  [4] = { ["size"] = 450, ['cash'] = 17500, ['sale'] = 15000}, --Muscle
  [5] = { ["size"] = 200, ['cash'] = 10000, ['sale'] = 7500}, --Sports Classics
  [6] = { ["size"] = 200, ['cash'] = 10000, ['sale'] = 7500}, --Sports
  [7] = { ["size"] = 150, ['cash'] = 7500, ['sale'] = 5000}, --Super
  [8] = { ["size"] = 50, ['cash'] = 2500, ['sale'] = 1500}, --Motorcycles
  [9] = { ["size"] = 600, ['cash'] = 25000, ['sale'] = 22500}, --Off-road
  [10] = { ["size"] = 2000, ['cash'] = 60000, ['sale'] = 55000}, --Industrial
  [11] = { ["size"] = 1500, ['cash'] = 55000, ['sale'] = 50000}, --Utility
  [12] = { ["size"] = 2000, ['cash'] = 60000, ['sale'] = 55000}, --Vans
  [13] = { ["size"] = 10, ['cash'] = 100, ['sale'] = 50}, --Cycles
  [14] = { ["size"] = 1000, ['cash'] = 45000, ['sale'] = 40000}, --Boats
  [15] = { ["size"] = 1500, ['cash'] = 55000, ['sale'] = 50000}, --Helicopters
  [16] = { ["size"] = 2500, ['cash'] = 75000, ['sale'] = 70000}, --Planes
  [17] = { ["size"] = 500, ['cash'] = 20000, ['sale'] = 17500}, --Service
  [18] = { ["size"] = 1000, ['cash'] = 30000, ['sale'] = 25000}, --Emergency
  [19] = { ["size"] = 1000, ['cash'] = 30000, ['sale'] = 25000}, --Military
  [20] = { ["size"] = 2500, ['cash'] = 75000, ['sale'] = 70000}, --Commercial
  [21] = { ["size"] = 5000, ['cash'] = 150000, ['sale'] = 135000}, --Trains
}

local itemspoid = {
  ['Joint'] = { ["size"] = 4},
  ['water'] = { ["size"] = 6.50},
},

TriggerEvent('esx:getSharedObject', function(obj)
  ESX = obj
end)


RegisterServerEvent('esx_truck_inventory:getInventory')
AddEventHandler('esx_truck_inventory:getInventory', function(plate)
  local inventory_ = {}
  local _source = source
  MySQL.Async.fetchAll(
    'SELECT * FROM `truck_inventory` WHERE `plate` = @plate',
    {
      ['@plate'] = plate
    },
    function(inventory)
      if inventory ~= nil and #inventory > 0 then
        for i=1, #inventory, 1 do
          table.insert(inventory_, {
            name      = inventory[i].item,
            label      = inventory[i].name,
            count     = inventory[i].count
          })
        end
      end

    local xPlayer  = ESX.GetPlayerFromId(_source)
    TriggerClientEvent('esx_truck_inventory:getInventoryLoaded', xPlayer.source, inventory_)
    end)
end)

RegisterServerEvent('esx_truck_inventory:removeInventoryItem')
AddEventHandler('esx_truck_inventory:removeInventoryItem', function(plate, item, count)
  local _source = source
  if xPlayer.getInvPoid() + (itemspoid[name].size * count) <= 100 then
    MySQL.Async.fetchAll(
      'UPDATE `truck_inventory` SET `count`= `count` - @qty WHERE `plate` = @plate AND `item`= @item',
      {
        ['@plate'] = plate,
        ['@qty'] = count,
        ['@item'] = item
      },
      function(result)
        local xPlayer  = ESX.GetPlayerFromId(_source)
        if xPlayer ~= nil then
          xPlayer.addInventoryItem(item, count)
        end
      end)
  else
    TriggerClientEvent('esx:showNotification', _source, 'Vous n\'avez pas assez de place dans votre inventaire')
  end
end)

RegisterServerEvent('esx_truck_inventory:addInventoryItem')
AddEventHandler('esx_truck_inventory:addInventoryItem', function(type, model, plate, item, count, name)
  local _source = source
  MySQL.Async.fetchAll(
    'INSERT INTO truck_inventory (item,count,plate,name) VALUES (@item,@qty,@plate,@name) ON DUPLICATE KEY UPDATE count=count+ @qty',
    {
      ['@plate'] = plate,
      ['@qty'] = count,
      ['@item'] = item,
      ['@name'] = name,
    },
    function(result)
      local xPlayer  = ESX.GetPlayerFromId(_source)
      xPlayer.removeInventoryItem(item, count)
    end)
end)

function getCarPoid (plate)
  local poid = 0
  for k,v in pairs(CARS[plate].car_i) do
    poid = poid + ((v.ppi or 0) * (v.count or 1))
  end
  for k,v in pairs(CARS[plate].car_d.weapon) do
    poid = poid + ((v.ppi or 0) * (v.count or 1))
  end
  return poid
end

RegisterServerEvent('esx_truck_inventory:loadInventory')
AddEventHandler('esx_truck_inventory:loadInventory', function(plate, model)
  local _source = source
  local xPlayer  = ESX.GetPlayerFromId(_source)
  local car_i = {}
  local car_d = {
    cash = 0,
    sale = 0,
    weapon = {}
  }
  local player_i = {}
  local player_d = {
    cash = 0,
    sale = 0,
    weapon = {}
  }


  if CARS[plate] ~= nil then
    car_i = CARS[plate].car_i
    car_d = CARS[plate].car_d

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

    player_d = {
      cash = xPlayer.getMoney() or 0,
      sale = xPlayer.getAccount('black_money').money or 0,
      weapon = {}
    }

    TriggerClientEvent('esx_truck_inventory:displayMenu', _source, car_i, car_d, player_i, player_d, maxCapacity[model].size, maxCapacity[model].cash, maxCapacity[model].sale)

  else
    MySQL.Async.fetchAll('SELECT * FROM `truck_inventory` WHERE `plate` = @plate', {['@plate'] = plate}, function(item_car)
      car_i = item_car
      for nb,value in pairs(car_i) do
        car_i[nb].ppi = itemspoid[value.item].size
      end
      MySQL.Async.fetchAll('SELECT * FROM `truck_data` WHERE `plate` = @plate', {['@plate'] = plate}, function(data_car)
        if data_car[1] ~= nil then
          car_d = {
            cash = data_car[1].money or 0,
            sale = data_car[1].black or 0,
            weapon = json.decode(data_car[1].weapons) or {}
          }
          CARS[plate] = {
            car_i = car_i,
            car_d = car_d
          }
        else
          car_d = {
            cash = 0,
            sale = 0,
            weapon = {}
          }
          CARS[plate] = {
            car_i = car_i,
            car_d = car_d
          }
          MySQL.Async.execute("INSERT INTO `truck_data` (`money`,`black`,`plate`,`weapons`) VALUES (0,0,@plate,'{}')", {['@plate'] = plate})
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

        player_d = {
          cash = xPlayer.getMoney() or 0,
          sale = xPlayer.getAccount('black_money').money or 0,
          weapon = {}
        }

        TriggerClientEvent('esx_truck_inventory:displayMenu', _source, car_i, car_d, player_i, player_d, maxCapacity[model].size, maxCapacity[model].cash, maxCapacity[model].sale)
      end)
    end)
  end
end)

RegisterServerEvent('esx_truck_inventory:cash_AddInCoffre')
AddEventHandler('esx_truck_inventory:cash_AddInCoffre', function(plate, model, money)
  local _source = source
  local xPlayer  = ESX.GetPlayerFromId(_source)

  if money >= 0 then

    if xPlayer.getMoney() - money >= 0 then

      if (CARS[plate].car_d.cash + money) <= maxCapacity[model].cash then
        CARS[plate].car_d.cash =  CARS[plate].car_d.cash + money
        xPlayer.removeMoney(money)

        MySQL.Async.execute('UPDATE `truck_data` SET `money`= `money` + @qty WHERE `plate` = @plate', {['@plate'] = plate, ['@qty'] = money})
      else
        TriggerClientEvent('esx:showNotification', _source, "Pas assez de place dans le véhicule (max : " .. maxCapacity[model].cash .. ")")
      end
    else
      TriggerClientEvent('esx:showNotification', _source, 'Vous n\'avez pas assez d\'argent')
    end
  else
    money = 0 - money
    if CARS[plate].car_d.cash - money >= 0 then

      CARS[plate].car_d.cash =  CARS[plate].car_d.cash - money
      xPlayer.addMoney(money)

      MySQL.Async.execute('UPDATE `truck_data` SET `money`= `money` - @qty WHERE `plate` = @plate', {['@plate'] = plate, ['@qty'] = money})
    else
      TriggerClientEvent('esx:showNotification', _source, 'Il n\'y a pas assez d\'argent dans le coffre')
    end
  end
end)

RegisterServerEvent('esx_truck_inventory:sale_AddInCoffre')
AddEventHandler('esx_truck_inventory:sale_AddInCoffre', function(plate, model, money)
  local _source = source
  local xPlayer  = ESX.GetPlayerFromId(_source)

  if money >= 0 then

    if xPlayer.getAccount('black_money').money - money >= 0 then

      if (CARS[plate].car_d.sale + money) <= maxCapacity[model].sale then
        CARS[plate].car_d.sale =  CARS[plate].car_d.sale + money
        xPlayer.removeAccountMoney('black_money', money)

        MySQL.Async.execute('UPDATE `truck_data` SET `black`= `black` + @qty WHERE `plate` = @plate', {['@plate'] = plate, ['@qty'] = money})
      else
        TriggerClientEvent('esx:showNotification', _source, "Pas assez de place dans le véhicule (max : " .. maxCapacity[model].sale .. ")")
      end
    else
      TriggerClientEvent('esx:showNotification', _source, 'Vous n\'avez pas assez d\'argent sale')
    end
  else
    money = 0 - money
    if CARS[plate].car_d.sale - money >= 0 then

      CARS[plate].car_d.sale =  CARS[plate].car_d.sale - money
      xPlayer.addAccountMoney('black_money', money)

      MySQL.Async.execute('UPDATE `truck_data` SET `black`= `black` - @qty WHERE `plate` = @plate', {['@plate'] = plate, ['@qty'] = money})
    else
      TriggerClientEvent('esx:showNotification', _source, 'Il n\'y a pas assez d\'argent sale dans le coffre')
    end
  end
end)


RegisterServerEvent('esx_truck_inventory:item_AddInCoffre')
AddEventHandler('esx_truck_inventory:item_AddInCoffre', function(plate, model, name, label, qty)
  local _source = source
  local xPlayer  = ESX.GetPlayerFromId(_source)


  if qty >= 0 then

    if (xPlayer.getInventoryItem(name).count - qty) >= 0 then

      if (getCarPoid(plate) + (itemspoid[name].size * qty)) <= maxCapacity[model].size then

        local act_item = {notexist = false}
        local act_nb = 0
        for nb,value in pairs(CARS[plate].car_i) do
          if value.item == name then
            act_item = value
            act_nb = nb
          end
        end
        if act_nb == 0 then
          MySQL.Async.execute("INSERT INTO `truck_inventory` (`item`,`name`,`plate`,`count` ) VALUES (@item,@name,@plate,@qty)", {['@plate'] = plate,['@item'] = name,['@name'] = label,['@qty'] = qty})
          table.insert(CARS[plate].car_i, {item = name, name = label, count = qty, plate = plate})
          xPlayer.removeInventoryItem(name, qty)
        else
          CARS[plate].car_i[act_nb].count = CARS[plate].car_i[act_nb].count + qty
          MySQL.Async.execute('UPDATE `truck_inventory` SET `count`= `count` + @qty WHERE `plate` = @plate AND `item` = @item', {['@plate'] = plate, ['@qty'] = qty, ['@item'] = name})
          xPlayer.removeInventoryItem(name, qty)
        end
      else
        TriggerClientEvent('esx:showNotification', _source, 'Vous n\'avez pas assez de place dans le coffre')
      end
    else
      TriggerClientEvent('esx:showNotification', _source, 'Vous n\'avez pas assez de : ' .. label)
    end
  else
    qty = 0 - qty
    local act_item = {notexist = true}
    local act_nb = 0
    for nb,value in pairs(CARS[plate].car_i) do
      if value.item == name then
        act_item = value
        act_nb = nb
      end
    end

    if act_nb == 0 then
      TriggerClientEvent('esx:showNotification', _source, 'ERREUR : l\'item que vous chercher est introuvable, retentez')
    else

      if act_item.count - qty >= 0 then

        if xPlayer.getInvPoid() + (itemspoid[name].size * qty) <= 100 then

          CARS[plate].car_i[act_nb].count = CARS[plate].car_i[act_nb].count - qty
          MySQL.Async.execute('UPDATE `truck_inventory` SET `count`= `count` - @qty WHERE `plate` = @plate AND `item` = @item', {['@plate'] = plate, ['@qty'] = qty, ['@item'] = name})
          xPlayer.addInventoryItem(name, qty)
        else
          TriggerClientEvent('esx:showNotification', _source, 'Vous n\'avez pas assez de place sur vous')
        end
      else
        TriggerClientEvent('esx:showNotification', _source, 'Vous n\'avez pas assez de ' .. label .. ' dans le coffre')
      end
    end
  end
end)

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

      if CARS[plate] ~= nil then
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
end)
