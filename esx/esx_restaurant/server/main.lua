ESX                = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_restaurant:buyItem')
AddEventHandler('esx_restaurant:buyItem', function(itemName, price, itemLabel)

  local _source  = source
  local xPlayer  = ESX.GetPlayerFromId(_source)
  local limit    = xPlayer.getInventoryItem(itemName).limit
  local qtty     = xPlayer.getInventoryItem(itemName).count

  if xPlayer.get('money') >= price then
    if qtty < limit then
      xPlayer.removeMoney(price)
      xPlayer.addInventoryItem(itemName, 1)
      TriggerClientEvent('esx:showNotification', _source, _U('bought') .. itemLabel)
    else
      TriggerClientEvent('esx:showNotification', _source, _U('max_item'))
    end
  else
    TriggerClientEvent('esx:showNotification', _source, _U('not_enough'))
  end
end)
