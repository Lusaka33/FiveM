ESX                = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_pharmacy:buyItem')
AddEventHandler('esx_pharmacy:buyItem', function(itemName, price, itemLabel)

  local _source = source
  local xPlayer  = ESX.GetPlayerFromId(_source)

  if xPlayer.get('money') >= price then
    xPlayer.removeMoney(price)
    xPlayer.addInventoryItem(itemName, 1)
    TriggerClientEvent('esx:showNotification', _source, _U('bought') .. itemLabel)
  else
    TriggerClientEvent('esx:showNotification', _source, _U('not_enough'))
  end
end)
