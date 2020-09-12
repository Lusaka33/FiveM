-- ESX Mode
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Variables
--local arrayWeight = Config.

-- Get Appart
function GetProperty(name)

  for i=1, #Config.Appartement, 1 do
    if Config.Appartement[i].name == name then
      return Config.Appartement[i]
    end
  end
end

function SetPropertyOwned(name, price, rented, owner)

  MySQL.Async.execute(
    'INSERT INTO user_appartement (name, price, rented, owner) VALUES (@name, @price, @rented, @owner)',
    {
      ['@name']   = name,
      ['@price']  = price,
      ['@rented'] = (rented and 1 or 0),
      ['@owner']  = owner
    },
    function(rowsChanged)

      local xPlayers = ESX.GetPlayers()

      for i=1, #xPlayers, 1 do

        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if xPlayer.identifier == owner then

          TriggerClientEvent('esx_appartement:setPropertyOwned', xPlayer.source, name, true)

          MySQL.Async.execute(
            'INSERT INTO apart_key (`identifier`,`name`,`level`) VALUES (@identifier, @name, @level)',
            {
              ['@identifier'] = xPlayer.identifier,
              ['@name'] = name,
              ['@level'] = 3
            }
          )

          if rented then

            TriggerClientEvent('esx:showNotification', xPlayer.source, _U('rented_for') .. price)
          else

            TriggerClientEvent('esx:showNotification', xPlayer.source, _U('purchased_for') .. price)
          end

          break
        end
      end
    end
  )
end

function RemoveOwnedProperty(name, owner)

  MySQL.Async.execute(
    'DELETE FROM owned_properties WHERE name = @name AND owner = @owner',
    {
      ['@name']  = name,
      ['@owner'] = owner
    },
    function(rowsChanged)

      local xPlayers = ESX.GetPlayers()

      for i=1, #xPlayers, 1 do

        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if xPlayer.identifier == owner then
          TriggerClientEvent('esx_property:setPropertyOwned', xPlayer.source, name, false)
          TriggerClientEvent('esx:showNotification', xPlayer.source, _U('made_property'))
          break
        end
      end
    end
  )
end

AddEventHandler('onMySQLReady', function ()

  MySQL.Async.fetchAll('SELECT * FROM appartement', {}, function(appartement)

    for i=1, #appartement, 1 do

      local entering  = nil
      local exit      = nil
      local inside    = nil
      local outside   = nil
      local isSingle  = nil
      local isRoom    = nil
      local isGateway = nil
      local roomMenu  = nil

      if appartement[i].entering ~= nil then
        entering = json.decode(appartement[i].entering)
      end

      if appartement[i].exit ~= nil then
        exit = json.decode(appartement[i].exit)
      end

      if appartement[i].inside ~= nil then
        inside = json.decode(appartement[i].inside)
      end

      if appartement[i].outside ~= nil then
        outside = json.decode(appartement[i].outside)
      end

      if appartement[i].is_single == 0 then
        isSingle = false
      else
        isSingle = true
      end

      if appartement[i].is_room == 0 then
        isRoom = false
      else
        isRoom = true
      end

      if appartement[i].is_gateway == 0 then
        isGateway = false
      else
        isGateway = true
      end

      if appartement[i].room_menu ~= nil then
        roomMenu = json.decode(appartement[i].room_menu)
      end

      table.insert(Config.Appartement, {
        name      = appartement[i].name,
        label     = appartement[i].label,
        entering  = entering,
        exit      = exit,
        inside    = inside,
        outside   = outside,
        ipls      = json.decode(appartement[i].ipls),
        gateway   = appartement[i].gateway,
        isSingle  = isSingle,
        isRoom    = isRoom,
        isGateway = isGateway,
        roomMenu  = roomMenu,
        price     = appartement[i].price
      })
    end
  end)
end)

AddEventHandler('esx_ownedproperty:getOwnedProperties', function(cb)

  MySQL.Async.fetchAll(
    'SELECT * FROM user_appartement',
    {},
    function(result)

      local appartement = {}

      for i=1, #result, 1 do

        table.insert(appartement, {
          id     = result[i].id,
          name   = result[i].name,
          price  = result[i].price,
          rented = (rented == 1 and true or false),
          owner  = result[i].owner,
        })
      end

      cb(appartement)
    end
  )
end)

AddEventHandler('esx_appartement:setPropertyOwned', function(name, price, rented, owner)
  SetPropertyOwned(name, price, rented, owner)
end)

AddEventHandler('esx_property:removeOwnedProperty', function(name, owner)

  RemoveOwnedProperty(name, owner)
end)

RegisterServerEvent('esx_appartement:rentProperty')
AddEventHandler('esx_appartement:rentProperty', function(propertyName)

  local xPlayer  = ESX.GetPlayerFromId(source)
  local property = GetProperty(propertyName)

  MySQL.Async.execute(
    'INSERT INTO apart_key (`identifier`,`name`,`level`) VALUES (@identifier, @name, @level)',
    {
      ['@identifier'] = xPlayer.identifier,
      ['@name'] = name,
      ['@level'] = 3
    }
  )
  --update_keys_of(source)
  SetPropertyOwned(propertyName, property.price / 150, true, xPlayer.identifier)
end)

RegisterServerEvent('esx_appartement:buyProperty')
AddEventHandler('esx_appartement:buyProperty', function(propertyName)

  local xPlayer  = ESX.GetPlayerFromId(source)
  local property = GetProperty(propertyName)
  MySQL.Async.fetchAll(
    'SELECT * FROM apart_key WHERE name = @name AND level = 3',
    {
      ['@name'] = name
    },
    function (result2)
    if result2[1] then

      TriggerClientEvent('esx:showNotification', source, 'Appartement déjà acheter')
    elseif property.price <= xPlayer.get('money') then

      MySQL.Async.execute(
        'INSERT INTO apart_key (`identifier`,`name`,`level`) VALUES (@identifier, @name, @level)',
        {
          ['@identifier'] = xPlayer.identifier,
          ['@name'] = name,
          ['@level'] = 3
        }
      )
      --update_keys_of(source)
      xPlayer.removeMoney(property.price)
      SetPropertyOwned(propertyName, property.price, false, xPlayer.identifier)
    else
      TriggerClientEvent('esx:showNotification', source, _U('not_enough'))
    end
  end)
end)

RegisterServerEvent('esx_appartement:removeOwnedProperty')
AddEventHandler('esx_appartement:removeOwnedProperty', function(propertyName)

  local xPlayer = ESX.GetPlayerFromId(source)

  MySQL.Async.execute(
    'DELETE from apart_key WHERE name = @name',
    {
      ['@name'] = name
    }
  )
  --xPlayer.addMoney(property.price)
  --RemoveOwnedProperty(propertyName, property.price / 50, xPlayer.identifier)
  TriggerClientEvent('esx:showNotification', source, 'L\'appartement à bien était revendu')
  --update_keys_of(source)
end)

AddEventHandler('esx_property:removeOwnedPropertyIdentifier', function(propertyName, identifier)
  RemoveOwnedProperty(propertyName, identifier)
end)

RegisterServerEvent('esx_appartement:saveLastProperty')
AddEventHandler('esx_appartement:saveLastProperty', function(property)

  local xPlayer = ESX.GetPlayerFromId(source)

  MySQL.Async.execute(
    'UPDATE users SET last_property = @last_property WHERE identifier = @identifier',
    {
      ['@last_property'] = property,
      ['@identifier']    = xPlayer.identifier
    }
  )
end)

RegisterServerEvent('esx_appartement:deleteLastProperty')
AddEventHandler('esx_appartement:deleteLastProperty', function()
  local xPlayer = ESX.GetPlayerFromId(source)

  MySQL.Async.execute(
    'UPDATE users SET last_property = NULL WHERE identifier = @identifier',
    {
      ['@identifier']    = xPlayer.identifier
    }
  )
end)

ESX.RegisterServerCallback('esx_appartement:getAppartement', function(source, cb)
  cb(Config.Appartement)
end)

ESX.RegisterServerCallback('esx_appartement:getOwnedAppartement', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)

  MySQL.Async.fetchAll(
    'SELECT * FROM user_appartement WHERE owner = @owner',
    {
      ['@owner'] = xPlayer.identifier
    },
    function(ownedAppartement)

      local appartement = {}

      for i=1, #ownedAppartement, 1 do
        table.insert(appartement, ownedAppartement[i].name)
      end

      cb(appartement)
    end
  )
end)

-- Inventory / Coffre
RegisterServerEvent('esx_appartement:getItem')
AddEventHandler('esx_appartement:getItem', function(owner, type, item, count)

  local _source      = source
  local xPlayer      = ESX.GetPlayerFromId(_source)
  local xPlayerOwner = ESX.GetPlayerFromIdentifier(owner)

  if type == 'item_standard' then

    TriggerEvent('esx_addoninventory:getInventory', 'appartement', xPlayerOwner.identifier, function(inventory)

      local roomItemCount = inventory.getItem(item).count

      if roomItemCount >= count then
        inventory.removeItem(item, count)
        xPlayer.addInventoryItem(item, count)
      else
        TriggerClientEvent('esx:showNotification', _source, _U('invalid_quantity'))
      end
    end)
  end

  if type == 'item_account' then

    TriggerEvent('esx_addonaccount:getAccount', 'appartement_' .. item, xPlayerOwner.identifier, function(account)

      local roomAccountMoney = account.money

      if roomAccountMoney >= count then
        account.removeMoney(count)
        xPlayer.addAccountMoney(item, count)
      else
        TriggerClientEvent('esx:showNotification', _source, _U('amount_invalid'))
      end
    end)
  end

  if type == 'item_weapon' then

    TriggerEvent('esx_datastore:getDataStore', 'appartement', xPlayerOwner.identifier, function(store)

      local storeWeapons = store.get('weapons')

      if storeWeapons == nil then
        storeWeapons = {}
      end

      local weaponName   = nil
      local ammo         = nil

      for i=1, #storeWeapons, 1 do
        if storeWeapons[i].name == item then

          weaponName = storeWeapons[i].name
          ammo       = storeWeapons[i].ammo

          table.remove(storeWeapons, i)

          break
        end
      end

      store.set('weapons', storeWeapons)

      xPlayer.addWeapon(weaponName, ammo)
    end)
  end
end)

RegisterServerEvent('esx_appartement:putItem')
AddEventHandler('esx_appartement:putItem', function(owner, type, item, count)

  local _source      = source
  local xPlayer      = ESX.GetPlayerFromId(_source)
  local xPlayerOwner = ESX.GetPlayerFromIdentifier(owner)

  if type == 'item_standard' then

    local playerItemCount = xPlayer.getInventoryItem(item).count

    if playerItemCount >= count then

      xPlayer.removeInventoryItem(item, count)

      TriggerEvent('esx_addoninventory:getInventory', 'appartement', xPlayerOwner.identifier, function(inventory)
        inventory.addItem(item, count)
      end)
    else
      TriggerClientEvent('esx:showNotification', _source, _U('invalid_quantity'))
    end
  end

  if type == 'item_account' then

    local playerAccountMoney = xPlayer.getAccount(item).money

    if playerAccountMoney >= count then

      xPlayer.removeAccountMoney(item, count)

      TriggerEvent('esx_addonaccount:getAccount', 'appartement_' .. item, xPlayerOwner.identifier, function(account)
        account.addMoney(count)
      end)
    else
      TriggerClientEvent('esx:showNotification', _source, _U('amount_invalid'))
    end
  end

  if type == 'item_weapon' then

    TriggerEvent('esx_datastore:getDataStore', 'appartement', xPlayerOwner.identifier, function(store)

      local storeWeapons = store.get('weapons')

      if storeWeapons == nil then
        storeWeapons = {}
      end

      table.insert(storeWeapons, {
        name = item,
        ammo = count
      })

      store.set('weapons', storeWeapons)

      xPlayer.removeWeapon(item)
    end)
  end
end)

ESX.RegisterServerCallback('esx_appartement:getLastProperty', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)

  MySQL.Async.fetchAll(
    'SELECT * FROM users WHERE identifier = @identifier',
    {
      ['@identifier'] = xPlayer.identifier
    },
    function(users)
      cb(users[1].last_property)
    end
  )
end)

ESX.RegisterServerCallback('esx_appartement:getPropertyInventory', function(source, cb, owner)

  local xPlayer    = ESX.GetPlayerFromIdentifier(owner)
  local blackMoney = 0
  local items      = {}
  local weapons    = {}

  TriggerEvent('esx_addonaccount:getAccount', 'property_black_money', xPlayer.identifier, function(account)
    blackMoney = account.money
  end)

  TriggerEvent('esx_addoninventory:getInventory', 'appartement', xPlayer.identifier, function(inventory)
    items = inventory.items
  end)

  TriggerEvent('esx_datastore:getDataStore', 'appartement', xPlayer.identifier, function(store)

    local storeWeapons = store.get('weapons')

    if storeWeapons ~= nil then
      weapons = storeWeapons
    end
  end)

  cb({
    blackMoney = blackMoney,
    items      = items,
    weapons    = weapons
  })
end)

ESX.RegisterServerCallback('esx_appartement:getPlayerInventory', function(source, cb)

  local xPlayer    = ESX.GetPlayerFromId(source)
  local blackMoney = xPlayer.getAccount('black_money').money
  local items      = xPlayer.inventory

  cb({
    blackMoney = blackMoney,
    items      = items
  })
end)

-- Dressing
ESX.RegisterServerCallback('esx_appartement:getPlayerDressing', function(source, cb)

  local xPlayer  = ESX.GetPlayerFromId(source)
  local dressing = {}

  TriggerEvent('esx_datastore:getDataStore', 'appartement', xPlayer.identifier, function(store)

    local storeDressing = store.get('dressing')

    if storeDressing ~= nil then
      dressing = storeDressing
    end
  end)

  cb(dressing)
end)

-- Keys
RegisterServerEvent('esx_appartement:getApartKeys')
AddEventHandler('esx_appartement:getApartKeys', function(name)

  local source = source

  MySQL.Async.fetchAll(
    'SELECT * FROM apart_key WHERE name = @name',
    {
      ['@name'] = name
    },
    function (result)

      local Keys = {
      [name] = {}
    }

    for k, item in pairs(result) do
      Keys[name][item.username] = { ['level'] = item.level, ['pseudo'] = item.pseudo}
    end

    TriggerClientEvent('esx_appartement:getAppartementKeys', source, Keys)
  end)
end)

RegisterServerEvent('esx_appartement:createKey')
AddEventHandler('esx_appartement:createKey', function(name, id, level)

  local source = source

  if id >= 1 then

    local player = GetPlayerIdentifiers(source)[1]

    MySQL.Async.fetchAll(
      'SELECT * FROM `users` WHERE identifier = @identifier',
      {
        ['@identifier'] = xPlayer.identifier
      },
      function (result)

        if result[1] then

          MySQL.Async.execute(
            'INSERT INTO apart_key (`identifier`,`name`,`level`) VALUES (@identifier, @name, @level)',
            {
              ['@identifier'] = xPlayer.identifier,
              ['@name'] = name,
              ['@level'] = level
            }
          )

          --update_keys_of(id)
          TriggerClientEvent('esx:showNotification', id, 'Vous avez recu les clé pour votre bien immobilier')
          TriggerClientEvent('esx:showNotification', source, 'Les clés ont etait dupliquer')
        end
      end
    )
  end
end)

RegisterServerEvent('esx_appartement:removeKey')
AddEventHandler('esx_appartement:removeKey', function(name, identifier)

  MySQL.Async.execute(
    'DELETE FROM apart_key WHERE name = @name AND identifier = @identifier',
    {
      ['@name'] = name,
      ['@identifier'] = xPlayer.identifier
    },
    function(data)
    end
  )
end)

-- Ring
RegisterServerEvent('esx_appartement:canRing')
AddEventHandler('esx_appartement:canRing', function(name)

  if rings[apart] == true then

    TriggerClientEvent('esx:showNotification', source, 'Ding-Dong : entrez c\'est ouvert !')
    TriggerClientEvent('esx_appartement:ringAllowed', source)
  else
    MySQL.Async.fetchAll(
      'SELECT * FROM apart_key WHERE name = @name',
      {
        ['@name'] = name
      },
      function (result)
        if result[1] then

          local isConnected = false
          local player = GetPlayers()
          local identifiers = GetPlayerIdentifiers(item)

          if identifiers[1] == item2.username then

            isConnected = true
            TriggerClientEvent('esx:showNotification', item, 'Ding-Dong : Quelqu\'un sonne au ' .. appartement)
          end
          elseif isConnected == true then

            TriggerClientEvent('esx:showNotification', source, 'Ding-Dong : le propriétaire est prévenu')
          else

            TriggerClientEvent('esx:showNotification', source, 'Ding-Dong : le propriétaire n\'est pas disponible')
          end

          TriggerClientEvent('esx:showNotification', source, 'Il ne semble pas y avoir de propriétaire ici')
        end
    )
  end
end)

RegisterServerEvent('esx_appartement:setRing')
AddEventHandler('esx_appartement:setRing', function(appartement, value)

  rings[appartement] = value

  if value == true then

    TriggerClientEvent('esx:showNotification', source, 'Porte ouverte pour 10 seconde')
  else

    TriggerClientEvent('esx:showNotification', source, 'Porte verrouiller')
  end
end)

-- Acces coffre LSPD / Sheriff
RegisterServerEvent('esx_appartement:tryBreak')
AddEventHandler('esx_appartement:tryBreak', function(appartement)

  local source = source
  local xPlayer = ESX.GetPlayerFromId(source)

  MySQL.Async.fetchAll(
    'SELECT * FROM users WHERE identifier = @identifier AND job = @job',
    {
      ['@identifier'] = xPlayer.identifier,
      ['@job']        = xPlayer.job
    },
    function (result)
      local job = false

      if job == true then
        TriggerClientEvent('esx:showNotification', source, 'Vous pouvez casser la porte !!')
      else
        job = false
        TriggerClientEvent('esx:showNotification', source, 'Tu n\'a pas autoriser a faire ça !!')
      end
    end
  )
end)

--[[function openBreakCoffre(appart, b)

  local source = b
  local Hitems = {}
  local money = 0
  local dirtymoney = 0

  MySQL.Async.fetchAll(
    'SELECT * FROM `apart_inventory` WHERE `house` = @name',
    {
      ['@name'] = appart
    },
    function(item_car)

      Hitems = item_car

      for nb,value in pairs(Hitems) do
        Hitems[nb].ppi = ESX.Items[value.item].ppi or 0
      end

      MySQL.Async.fetchAll(
        'SELECT * FROM user_appartement WHERE name = @name',
        {
          ['@name'] = appart
        },
        function (result)
          if result[1] then
            money = result[1].money
            dirtymoney = result[1].dirtymoney
          end
          TriggerClientEvent'(esx_appartement:fouillezCoffre', source, appart, Hitems, money, dirtymoney)
          end
        end
      )
    end
  )
end

RegisterServerEvent('esx_appartement:ClearCoffre')
AddEventHandler('esx_appartement:ClearCoffre', function(apart)

  local source = source
  local xPlayer = ESX.GetPlayerFromId(source)

  MySQL.Async.fetchAll(
    'SELECT * FROM users WHERE identifier = @identifier',
    {
      ['@identifier'] = xPlayer.identifier
    },
    function (result)
      if result[1] then

        local f = true

        if result[1].job == 'police' then

          if result[1].grade >= 5 then
            MySQL.Async.execute(
              'DELETE FROM apart_inventory WHERE house = @name',
              {
                ['@name'] = apart
              }
            )

            MySQL.Async.execute(
              'UPDATE user_appartement SET `dirtymoney`=0,`money`=0 WHERE name = @name',
              {
                ['@name'] = apart
              },function(data)
              end
            )

            f = false
          end
        end

        if result[1].job == 'sheriff' then
          if result[1].grade >= 5 then
            MySQL.Async.execute('DELETE FROM apart_inventory WHERE house = @name',
              {
                ['@name'] = apart
              }
            )

            MySQL.Async.execute(
              'UPDATE user_appartement SET `dirtymoney`=0,`money`=0 WHERE name = @name',
              {
                ['@name'] = apart
              },
              function(data)
              end
            )

            f = false
          end
        end

        if f == true then
          TriggerClientEvent('esx:showNotification', source, 'Tu n\'a pas les droits pour faire ça')
        else
          TriggerClientEvent('esx:showNotification', source, 'Les marchandise on etait brulé et l'argent détruit')
        end
      end
    end
  )
end)]]

-- Rent
function PayRent(d, h, m)

  MySQL.Async.fetchAll(
    'SELECT * FROM users',
    {},
    function(_users)

      local prevMoney = {}
      local newMoney  = {}

      for i=1, #_users, 1 do
        prevMoney[_users[i].identifier] = _users[i].money
        newMoney[_users[i].identifier]  = _users[i].money
      end

      MySQL.Async.fetchAll(
        'SELECT * FROM user_appartement WHERE rented = 1',
        {},
        function(result)

          local xPlayers = ESX.GetPlayers()

          for i=1, #result, 1 do

            local foundPlayer = false
            local xPlayer     = nil

            for j=1, #xPlayers, 1 do

              local xPlayer2 = ESX.GetPlayerFromId(xPlayers[j])

              if xPlayer2.identifier == result[i].owner then
                foundPlayer = true
                xPlayer     = xPlayer2
              end
            end

            if foundPlayer then

              xPlayer.removeMoney(result[i].price)
              TriggerClientEvent('esx:showNotification', xPlayer.source, _U('paid_rent') .. result[i].price)
            else
              newMoney[result[i].owner] = newMoney[result[i].owner] - result[i].price
            end

            TriggerEvent('esx_addonaccount:getSharedAccount', 'society_realestateagent', function(account)
              account.addMoney(result[i].price)
            end)
          end

          for k,v in pairs(prevMoney) do
            if v ~= newMoney[k] then

              MySQL.Async.execute(
                'UPDATE users SET money = @money WHERE identifier = @identifier',
                {
                  ['@money']      = newMoney[k],
                  ['@identifier'] = k
                }
              )
            end
          end
        end
      )
    end
  )
end

TriggerEvent('cron:runAt', 05, 0, PayRent)
