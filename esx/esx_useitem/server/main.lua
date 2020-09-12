ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


------------------------------------
	--------- Utiliser Swim --------
------------------------------------

ESX.RegisterUsableItem('mask_swim', function(source)
	TriggerClientEvent('esx_useitem:swim', source)

	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('mask_swim', 1)
end)

------------------------------------
	------- Utiliser Bong ---------
------------------------------------

ESX.RegisterUsableItem('bong', function(source)
	TriggerClientEvent('esx_useitem:bong', source)
end)

RegisterServerEvent('esx_useitem:bong')
AddEventHandler('esx_useitem:bong', function()

	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('bong', 1)
	TriggerClientEvent('esx_status:add', source, 'drunk', -450000)
end)

------------------------------------
	------ Utiliser Sandwich -------
------------------------------------

ESX.RegisterUsableItem('sandwich', function(source)
	TriggerClientEvent('esx_useitem:sandwich', source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('bread', 1)
	TriggerClientEvent('esx_status:add', source, 'hunger', 500000)
end)

------------------------------------
	------ Utiliser cigarette -------
------------------------------------

ESX.RegisterUsableItem('cigarette', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local lighter = xPlayer.getInventoryItem('lighter')

	if lighter.count > 0 then
		xPlayer.removeInventoryItem('cigarette', 1)
		TriggerClientEvent('esx_useitem:startSmoke', source)
	else
		TriggerClientEvent('esx:showNotification', source, ('Tu n\'as pas de briquet'))
	end
end)


------------------------------------
	------ Utiliser Lockpick -------
------------------------------------

ESX.RegisterServerCallback('esx_useitem:hasSucceeded', function(source, cb)
	local randomValue = math.random(1, 10)
	if (randomValue  <= 3) then
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterUsableItem('lockpick', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('lockpick', 1)
	TriggerClientEvent('esx_useitem:startLockpick', source)
end)

------------------------------------
	-------- Utiliser Mask  --------
------------------------------------

ESX.RegisterUsableItem('mask', function(source)
 	TriggerClientEvent('esx_useitem:mask',source)

 	xPlayer.removeInventoryItem('mask', 1)
end)

------------------------------------
	------ Utiliser le joint -------
------------------------------------

ESX.RegisterUsableItem('Joint', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local lighter = xPlayer.getInventoryItem('lighter')

	if lighter.count > 0 then
		xPlayer.removeInventoryItem('Joint', 1)
		TriggerClientEvent('esx_useitem:startJoint', source)
	else
		TriggerClientEvent('esx:showNotification', source, ('Tu n\'as pas de briquet'))
	end
end)
------------------------------------
	------ Defibrilateur -------
------------------------------------
ESX.RegisterUsableItem('defibri', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

		xPlayer.removeInventoryItem('defibri', 1)
		TriggerClientEvent('esx_useitem:defibri', source)
end)

------------------------------------
	------ Bandages -------
------------------------------------

ESX.RegisterUsableItem('bandage', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

		xPlayer.removeInventoryItem('bandage', 1)
		TriggerClientEvent('esx_useitem:bandage', source)
end)

------------------------------------
	------ Kit de survie -------
------------------------------------

ESX.RegisterUsableItem('kitsurvie', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

		xPlayer.removeInventoryItem('kitsurvie', 1)
		TriggerClientEvent('esx_useitem:kitsurvie', source)
end)






--[[

------------------------------------
	-------- Utiliser Brolly --------
------------------------------------
ESX.RegisterUsableItem('brolly', function(source)
	TriggerClientEvent('esx_useitem:brolly', source)
end)

------------------------------------
	-------- Utiliser Kitpic -------
------------------------------------
ESX.RegisterUsableItem('kitpic', function(source)
	TriggerClientEvent('esx_useitem:kitpic', source)

	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('kitpic', 1)
end)

------------------------------------
	-------- Utiliser Ball ---------
------------------------------------
ESX.RegisterUsableItem('ball', function(source)
	TriggerClientEvent('esx_useitem:ball', source)
end)


------------------------------------
  ----- Faire Les Poubelles ------
------------------------------------
RegisterServerEvent('esx_useitem:bin')
AddEventHandler('esx_useitem:bin', function()

	local xPlayer  = ESX.GetPlayerFromId(source)
	local total   = math.random(0, 99);

	if     total >= 0 and total <= 10 then
		TriggerClientEvent('esx:showNotification', source, 'La poubelle est ~g~vide')
	elseif total > 20 and total <= 30 then
		xPlayer.addInventoryItem('paper', 1)
	elseif total > 20 and total <= 30 then
		xPlayer.addInventoryItem('p_bag', 1)
	elseif total > 50 and total <= 40 then
		xPlayer.addInventoryItem('usbstick', 1)
	elseif total > 50 and total <= 50 then
		xPlayer.addInventoryItem('s_toux', 1)
	elseif total > 50 and total <= 60 then
		xPlayer.addInventoryItem('condom', 1)
	elseif total > 60 and total <= 65 then
		xPlayer.addInventoryItem('exta', 1)
	elseif total > 65 and total <= 71 then
		xPlayer.addInventoryItem('magazine', 1)
	elseif total > 71 and total <= 74 then
		xPlayer.addInventoryItem('orange', 1)
	elseif total > 74 and total <= 76 then
		xPlayer.addInventoryItem('grape', 1)
	elseif total > 76 and total <= 79 then
		xPlayer.addInventoryItem('water', 1)
	elseif total > 79 and total <=85 then
		xPlayer.addInventoryItem('bread', 1)
	elseif total > 85 and total <= 87 then
		xPlayer.addInventoryItem('orangejus', 1)
	elseif total > 87 and total <= 88 then
		xPlayer.addInventoryItem('grapesjus', 1)
	elseif total > 88 and total <= 95 then
		xPlayer.addAccountMoney('black_money', 50)
	elseif total > 95 and total <= 98 then
		xPlayer.addAccountMoney('black_money', 200)
	elseif total > 98 and total <= 99 then
		xPlayer.addWeapon("weapon_pistol", 12)
	end
end)
]]
