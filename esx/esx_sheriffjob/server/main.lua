ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_service:activateService', 'sheriff')
TriggerEvent('esx_society:registerSociety', 'sheriff', 'sheriff', 'society_sheriff', 'society_sheriff', 'society_sheriff', {type = 'public'})

--Phone
local APPELS = {}

RegisterServerEvent('phone:call')
AddEventHandler('phone:call', function(service, raison, x, y, z)
    if service == "sheriff" then
        if raison == "Annuler l'appel" then
          if APPELS[source] ~= nil then
            if APPELS[source].raison == "Auto_braquage" then
            else
              APPELS[source] = nil
              TriggerClientEvent('esx:showNotification', source, "17 : Votre appel à était supprimé")
            end
          end
        elseif raison == "Auto_braquage" then
          APPELS[source] = {
            id = source,
            raison = raison,
            posX = x,
            posY = y,
            posZ = z
          }
          TriggerClientEvent('sheriff:newcall', -1, true)
        else
            if APPELS[source] ~= nil then
                if APPELS[source].raison == "Auto_braquage" then
                    TriggerClientEvent('esx:showNotification', source, "KARMA : Vous venez de commettre un braquage, vous n'allez appeler le sheriff ?!")
                else
                    APPELS[source] = {
                        id = source,
                        raison = raison,
                        posX = x,
                        posY = y,
                        posZ = z
                    }
                    TriggerClientEvent('sheriff:newcall', -1, true)
                    TriggerClientEvent('esx:showNotification', source, "17 : Votre appel à était enregistré, restez sur place jusqu'à l'arrivé de le sheriff")
                end
            else
                APPELS[source] = {
                    id = source,
                    raison = raison,
                    posX = x,
                    posY = y,
                    posZ = z
                }
                TriggerClientEvent('sheriff:newcall', -1, true)
                TriggerClientEvent('esx:showNotification', source, "17 : Votre appel à était enregistré, restez sur place jusqu'a l'arrivé de le sheriff")
            end
        end
    end
    local temp = {}
    for nb,value in pairs(APPELS) do
        if value ~= nil then
            table.insert(temp, value)
        end
    end
    TriggerClientEvent('sheriff:updatecall', -1, temp)
end)


RegisterServerEvent('sheriff:endcall')
AddEventHandler('sheriff:endcall', function(id)
    APPELS[id] = nil
    local temp = {}
    for nb,value in pairs(APPELS) do
        if value ~= nil then
            table.insert(temp, value)
        end
    end
    TriggerClientEvent('sheriff:updatecall', -1, temp)
end)

RegisterServerEvent('sheriff:sendNotif')
AddEventHandler('sheriff:sendNotif', function(id, msg)
    TriggerClientEvent('esx:showNotification', id, msg)
end)

-- License
function ShowPermis(source,identifier)
  local _source = source
  local licenses = MySQL.Sync.fetchAll("SELECT * FROM user_licenses where `owner`= @owner",{['@owner'] = identifier})

  for i=1, #licenses, 1 do

    if(licenses[i].type =="weapon")then
     TriggerClientEvent('esx:showNotification',_source,"Permis de port d'arme")
    end
    if(licenses[i].type =="dmv")then
      TriggerClientEvent('esx:showNotification',_source,"Code de la route")
    end
    if(licenses[i].type =="drive")then
      TriggerClientEvent('esx:showNotification',_source,"Permis de conduire")
    end
    if(licenses[i].type =="drive_bike")then
     TriggerClientEvent('esx:showNotification',_source,"Permis moto")
    end
    if(licenses[i].type =="drive_truck")then
      TriggerClientEvent('esx:showNotification',_source,"Permis camion")
    end
  end
end

RegisterServerEvent('esx_sheriffjob:license_see')
AddEventHandler('esx_sheriffjob:license_see', function(target)

  local sourceXPlayer = ESX.GetPlayerFromId(source)
  local targetXPlayer = ESX.GetPlayerFromId(target)

  local identifier = GetPlayerIdentifiers(target)[1]

  TriggerClientEvent('esx:showNotification', sourceXPlayer.source, '~b~'..targetXPlayer.name)
  ShowPermis(source,identifier)
end)

function deleteLicense(owner, license)
  MySQL.Sync.execute("DELETE FROM user_licenses WHERE `owner` = @owner AND `type` = @license", {
    ['@owner'] = owner,
    ['@license'] = license,
    })
  -- print('Permis suppr - '..owner)
  -- print('Permis suppr - '..license)
end

RegisterServerEvent('esx_sheriffjob:deletelicense')
AddEventHandler('esx_sheriffjob:deletelicense', function(target, license)
  local text = ""
  local sourceXPlayer = ESX.GetPlayerFromId(source)
  local targetXPlayer = ESX.GetPlayerFromId(target)

  if(license =="weapon")then
    text= "Permis de port d'arme"
  end
  if(license =="dmv")then
    text = "Code de la route"
  end
  if(license =="drive")then
    text= "Permis de conduire"
  end
  if(license =="drive_bike")then
    text= "Permis moto"
  end
  if(license =="drive_truck")then
    text="Permis camion"
  end

  TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous avez ~r~supprimé ~w~ : '..text..' de ~b~'..targetXPlayer.name )
  TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~r~' .. sourceXPlayer.name .. ' vous a retiré : '.. text)

  local identifier = GetPlayerIdentifiers(target)[1]

  deleteLicense(identifier,license)
end)

RegisterServerEvent('esx_sheriffjob:giveWeapon')
AddEventHandler('esx_sheriffjob:giveWeapon', function(weapon, ammo)
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addWeapon(weapon, ammo)
end)

RegisterServerEvent('esx_sheriffjob:confiscatePlayerItem')
AddEventHandler('esx_sheriffjob:confiscatePlayerItem', function(target, itemType, itemName, amount)

  local sourceXPlayer = ESX.GetPlayerFromId(source)
  local targetXPlayer = ESX.GetPlayerFromId(target)

  if itemType == 'item_standard' then

    local label = sourceXPlayer.getInventoryItem(itemName).label
    local playerItemCount = targetXPlayer.getInventoryItem(itemName).count

    if playerItemCount <= amount then
      targetXPlayer.removeInventoryItem(itemName, amount)
      sourceXPlayer.addInventoryItem(itemName, amount)
    else
      TriggerClientEvent('esx:showNotification', _source, _U('invalid_quantity'))
    end

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confinv') .. amount .. ' ' .. label .. _U('from') .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. targetXPlayer.name .. _U('confinv') .. amount .. ' ' .. label )
  end

  if itemType == 'item_account' then

    targetXPlayer.removeAccountMoney(itemName, amount)
    sourceXPlayer.addAccountMoney(itemName, amount)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confdm') .. amount .. _U('from') .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. targetXPlayer.name .. _U('confdm') .. amount)
  end

  if itemType == 'item_weapon' then

    targetXPlayer.removeWeapon(itemName)
    sourceXPlayer.addWeapon(itemName, amount)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confweapon') .. ESX.GetWeaponLabel(itemName) .. _U('from') .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. targetXPlayer.name .. _U('confweapon') .. ESX.GetWeaponLabel(itemName))
  end
end)

RegisterServerEvent('esx_sheriffjob:handcuff')
AddEventHandler('esx_sheriffjob:handcuff', function(target)
  TriggerClientEvent('esx_sheriffjob:handcuff', target)
end)

RegisterServerEvent('esx_sheriffjob:drag')
AddEventHandler('esx_sheriffjob:drag', function(target)
  local _source = source
  TriggerClientEvent('esx_sheriffjob:drag', target, _source)
end)

RegisterServerEvent('esx_sheriffjob:putInVehicle')
AddEventHandler('esx_sheriffjob:putInVehicle', function(target)
  TriggerClientEvent('esx_sheriffjob:putInVehicle', target)
end)

RegisterServerEvent('esx_sheriffjob:OutVehicle')
AddEventHandler('esx_sheriffjob:OutVehicle', function(target)
  TriggerClientEvent('esx_sheriffjob:OutVehicle', target)
end)

RegisterServerEvent('esx_sheriffjob:getStockItem')
AddEventHandler('esx_sheriffjob:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_sheriff', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn') .. count .. ' ' .. item.label)
  end)
end)

RegisterServerEvent('esx_sheriffjob:putStockItems')
AddEventHandler('esx_sheriffjob:putStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_sheriff', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= 0 then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('added') .. count .. ' ' .. item.label)
  end)
end)

ESX.RegisterServerCallback('esx_sheriffjob:getOtherPlayerData', function(source, cb, target)

  if Config.EnableESXIdentity then

    local xPlayer = ESX.GetPlayerFromId(target)

    local identifier = GetPlayerIdentifiers(target)[1]

    local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
      ['@identifier'] = identifier
    })

    local user          = result[1]
    local firstname     = user['prenom']
    local lastname      = user['nom']
    local sex           = user['sex']
    local dob           = user['dateofbirth']
    local height        = user['height'] .. " Inches"

    local data = {
      name        = GetPlayerName(target),
      job         = xPlayer.job,
      inventory   = xPlayer.inventory,
      accounts    = xPlayer.accounts,
      weapons     = xPlayer.loadout,
      firstname   = firstname,
      lastname    = lastname,
      sex         = sex,
      dob         = dob,
      height      = height
    }

    -- TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
    --
    --   if status ~= nil then
    --     data.drunk = math.floor(status.percent)
    --   end
    -- end)

    if Config.EnableLicenses then

      TriggerEvent('esx_license:getLicenses', target, function(licenses)
        data.licenses = licenses
        cb(data)
      end)
    else
      cb(data)
    end
  else

    local xPlayer = ESX.GetPlayerFromId(target)

    local data = {
      name       = GetPlayerName(target),
      job        = xPlayer.job,
      inventory  = xPlayer.inventory,
      accounts   = xPlayer.accounts,
      weapons    = xPlayer.loadout
    }

    -- TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
    --
    --   if status ~= nil then
    --     data.drunk = status.getPercent()
    --   end
    -- end)

    TriggerEvent('esx_license:getLicenses', target, function(licenses)
      data.licenses = licenses
    end)

    cb(data)
  end
end)

ESX.RegisterServerCallback('esx_sheriffjob:getFineList', function(source, cb, category)

  MySQL.Async.fetchAll(
    'SELECT * FROM fine_types WHERE category = @category',
    {
      ['@category'] = category
    },
    function(fines)
      cb(fines)
    end
  )
end)

ESX.RegisterServerCallback('esx_sheriffjob:getVehicleInfos', function(source, cb, plate)

  if Config.EnableESXIdentity then

    MySQL.Async.fetchAll(
      'SELECT * FROM owned_vehicles',
      {},
      function(result)

        local foundIdentifier = nil

        for i=1, #result, 1 do

          local vehicleData = json.decode(result[i].vehicle)

          if vehicleData.plate == plate then
            foundIdentifier = result[i].owner
            break
          end
        end

        if foundIdentifier ~= nil then

          MySQL.Async.fetchAll(
            'SELECT * FROM users WHERE identifier = @identifier',
            {
              ['@identifier'] = foundIdentifier
            },
            function(result)

              local ownerName = result[1].prenom .. " " .. result[1].nom

              local infos = {
                plate = plate,
                owner = ownerName
              }

              cb(infos)
            end
          )
        else

          local infos = {
          plate = plate
          }

          cb(infos)
        end
      end
    )
  else

    MySQL.Async.fetchAll(
      'SELECT * FROM owned_vehicles',
      {},
      function(result)

        local foundIdentifier = nil

        for i=1, #result, 1 do

          local vehicleData = json.decode(result[i].vehicle)

          if vehicleData.plate == plate then
            foundIdentifier = result[i].owner
            break
          end
        end

        if foundIdentifier ~= nil then

          MySQL.Async.fetchAll(
            'SELECT * FROM users WHERE identifier = @identifier',
            {
              ['@identifier'] = foundIdentifier
            },
            function(result)

                local ownerName = result[1].prenom .. " " .. result[1].nom

                local infos = {
                  plate = plate,
                  owner = ownerName
                }
              cb(infos)
            end
          )
        else

          local infos = {
            plate = plate
          }

          cb(infos)
        end
      end
    )
  end
end)

ESX.RegisterServerCallback('esx_sheriffjob:getArmoryWeapons', function(source, cb)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_sheriff', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)
  end)
end)

ESX.RegisterServerCallback('esx_sheriffjob:addArmoryWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.removeWeapon(weaponName)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_sheriff', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = weapons[i].count + 1
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 1
      })
    end

    store.set('weapons', weapons)
    cb()
  end)
end)

ESX.RegisterServerCallback('esx_sheriffjob:removeArmoryWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.addWeapon(weaponName, 1000)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_sheriff', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 0
      })
    end

    store.set('weapons', weapons)
    cb()
  end)
end)

ESX.RegisterServerCallback('esx_sheriffjob:buy', function(source, cb, amount)

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_sheriff', function(account)

    if account.money >= amount then
      account.removeMoney(amount)
      cb(true)
    else
      cb(false)
    end
  end)
end)

ESX.RegisterServerCallback('esx_sheriffjob:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_sheriff', function(inventory)
    cb(inventory.items)
  end)

end)

ESX.RegisterServerCallback('esx_sheriffjob:getPlayerInventory', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)
  local items   = xPlayer.inventory

  cb({
    items = items
  })
end)

RegisterServerEvent('sheriff:showBadgeTo')
AddEventHandler('sheriff:showBadgeTo', function(t)
  TriggerClientEvent('sheriff:showMePlate', t)
end)
RegisterServerEvent('sheriff:showBadgeTo2')
AddEventHandler('sheriff:showBadgeTo2', function(t)
  TriggerClientEvent('sheriff:showMePlate2', t)
end)

RegisterServerEvent('esx_sheriffjob:notify')
AddEventHandler('esx_sheriffjob:notify', function(dest, text)
  TriggerClientEvent('esx:showNotification', dest, text)
end)
