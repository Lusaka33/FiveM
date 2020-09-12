ESX                               = nil
local PlayersHarvestingOrange     = {}
local PlayersHarvestingWater      = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Fontaine d'eau
RegisterServerEvent('esx_various:fontaine')
AddEventHandler('esx_various:fontaine', function()

  local currentSource = source
  TriggerEvent('player_state:change',currentSource, 0, 25, -5)
end)

-- Recolte d'orange
local function HarvestOrange(source)

  SetTimeout(3000, function()

    if PlayersHarvestingOrange[source] == true then

      local xPlayer  = ESX.GetPlayerFromId(source)
      local orange = xPlayer.getInventoryItem('orange')

      if orange.limit ~= -1 and orange.count >= orange.limit then
        TriggerClientEvent('esx:showNotification', source, ('~r~Vous n\'avez plus de place'))
      else
        xPlayer.addInventoryItem('orange', 1)
        HarvestOrange(source)
      end
    end
  end)
end

RegisterServerEvent('esx_various:startHarvestOrange')
AddEventHandler('esx_various:startHarvestOrange', function()

  local _source = source

  PlayersHarvestingOrange[_source] = true

  TriggerClientEvent('esx:showNotification', _source, ('Récolte en cours'))

  HarvestOrange(_source)
end)

RegisterServerEvent('esx_various:stopHarvestOrange')
AddEventHandler('esx_various:stopHarvestOrange', function()

  local _source = source

  PlayersHarvestingOrange[_source] = false
end)

-- Recolte d'eau
local function HarvestWater(source)

  SetTimeout(5000, function()

    if PlayersHarvestingWater[source] == true then

      local xPlayer  = ESX.GetPlayerFromId(source)
      local water    = xPlayer.getInventoryItem('water')
      local Bottleqty   = xPlayer.getInventoryItem('bottle').count

      if Bottleqty <= 0 then
        TriggerClientEvent('esx:showNotification', source, ('~r~Vous n\'avez pas de boutielle vide'))
      else
        xPlayer.removeInventoryItem('bottle', 1)
        xPlayer.addInventoryItem('water', 1)
        HarvestWater(source)
      end
    end
  end)
end

RegisterServerEvent('esx_various:startHarvestWater')
AddEventHandler('esx_various:startHarvestWater', function()

  local _source = source

  PlayersHarvestingWater[_source] = true

  TriggerClientEvent('esx:showNotification', _source, ('Remplissage en cours'))

  HarvestWater(_source)
end)

RegisterServerEvent('esx_various:stopHarvestWater')
AddEventHandler('esx_various:stopHarvestWater', function()

  local _source = source

  PlayersHarvestingWater[_source] = false
end)
