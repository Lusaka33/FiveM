ESX                = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'gouvernor', Config.MaxInService)
end

TriggerEvent('esx_society:registerSociety', 'gouvernor', 'gouvernor', 'society_gouvernor', 'society_gouvernor', 'society_gouvernor', {type = 'private'})

-- Sonnette
local players = {}

RegisterServerEvent("esx_gouvernor:addPlayer")
AddEventHandler("esx_gouvernor:addPlayer", function(jobName)
	local _source = source
	players[_source] = jobName
end)

RegisterServerEvent("esx_gouvernor:sendSonnette")
AddEventHandler("esx_gouvernor:sendSonnette", function()
	local _source = source
	for i,k in pairs(players) do
		if(k~=nil) then
			if(k == "gouvernor") then
				TriggerClientEvent("esx_gouvernor:sendRequest", i, GetPlayerName(_source), _source)
			end
		end
	end
end)

RegisterServerEvent("esx_gouvernor:sendStatusToPoeple")
AddEventHandler("esx_gouvernor:sendStatusToPoeple", function(id, status)
	TriggerClientEvent("esx_gouvernor:sendStatus", id, status)
end)

-- Stock
RegisterServerEvent('esx_gouvernor:getStockItem')
AddEventHandler('esx_gouvernor:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_gouvernor', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end
    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_removed') .. count .. ' ' .. item.label)
  end)
end)

ESX.RegisterServerCallback('esx_gouvernor:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_gouvernor', function(inventory)
    cb(inventory.items)
  end)
end)

RegisterServerEvent('esx_gouvernor:putStockItems')
AddEventHandler('esx_gouvernor:putStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_gouvernor', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= 0 then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_quantity'))
    end
    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_added') .. count .. ' ' .. item.label)
  end)
end)

-- Weapon stock
ESX.RegisterServerCallback('esx_gouvernor:getVaultWeapons', function(source, cb)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_gouvernor', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end
    cb(weapons)
  end)
end)

ESX.RegisterServerCallback('esx_gouvernor:addVaultWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.removeWeapon(weaponName)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_gouvernor', function(store)

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

ESX.RegisterServerCallback('esx_gouvernor:removeVaultWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.addWeapon(weaponName, 1000)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_gouvernor', function(store)

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

ESX.RegisterServerCallback('esx_gouvernor:getPlayerInventory', function(source, cb)

  local xPlayer    = ESX.GetPlayerFromId(source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })
end)
