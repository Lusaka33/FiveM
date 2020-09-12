local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}


ESX                           = nil
local GUI      = {}
local PlayerData                = {}
local lastVehicle = nil
local lastOpen = false
GUI.Time                      = 0

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  	PlayerData = xPlayer
end)

function VehicleInFront()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 4.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
    local a, b, c, d, result = GetRaycastResult(rayHandle)
    return result
end

-- Key controls
Citizen.CreateThread(function()
  while true do

		Wait(0)

		if IsControlPressed(0, Keys["M"]) and (GetGameTimer() - GUI.Time) > 1000 then
				GUI.Time  = GetGameTimer()
        local vehFront = VehicleInFront()
	    	local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
	    	local closecar = GetClosestVehicle(x, y, z, 4.0, 0, 71)
          	if vehFront > 0 and closecar ~= nil and GetPedInVehicleSeat(closecar, -1) ~= GetPlayerPed(-1) then
          			--lastVehicle = vehFront
    						--local model = GetDisplayNameFromVehicleModel(GetEntityModel(closecar))
      					local locked = GetVehicleDoorLockStatus(closecar)
	          		--ESX.UI.Menu.CloseAll()
								--if ESX.UI.Menu.IsOpen('inventory', GetCurrentResourceName(), 'inventory') then
										--SetVehicleDoorShut(vehFront, 5, false)
								--else
										if locked == 1 then
												--SetVehicleDoorOpen(vehFront, 5, false, false)
												--ESX.UI.Menu.CloseAll()
												--TriggerServerEvent("esx_truck_inventory:getInventory", GetVehicleNumberPlateText(vehFront))
												TriggerServerEvent("esx_truck_inventory:loadInventory", GetVehicleNumberPlateText(vehFront), GetVehicleClass(vehFront))
										else
												ESX.ShowNotification('Ce coffre est ~r~fermé')
										end
								--end
        		else
        				ESX.ShowNotification('Pas de ~r~véhicule~w~ à proximité')
          	end
      			--lastOpen = true
      			--GUI.Time  = GetGameTimer()
    		--elseif lastOpen and IsControlPressed(0, Keys["BACKSPACE"]) and (GetGameTimer() - GUI.Time) > 150 then
      			--lastOpen = false
      			--ESX.UI.Menu.CloseAll()
      			--if lastVehicle > 0 then
								--SetVehicleDoorShut(lastVehicle, 5, false)
								--lastVehicle = 0
      			--end
    		--end
		end
	end
end)
--[[
RegisterNetEvent('esx_truck_inventory:getInventoryLoaded')
AddEventHandler('esx_truck_inventory:getInventoryLoaded', function(inventory)
	local elements = {}
	local vehFrontBack = VehicleInFront()


	table.insert(elements, {
      label     = 'Déposer',
      count     = 0,
      value     = 'deposit',
    })

	if inventory ~= nil and #inventory > 0 then
		for i=1, #inventory, 1 do
		  if inventory[i].count > 0 then
		    table.insert(elements, {
		      label     = inventory[i].label .. ' x' .. inventory[i].count,
		      count     = inventory[i].count,
		      value     = inventory[i].name,
		    })
		  end

		end
	end

	ESX.UI.Menu.Open(
	  'inventory', GetCurrentResourceName(), 'inventory_deposit',
	  {
	    title    = 'Coffre véhicule',
	    align    = 'bottom-right',
	    elements = elements,
	  },
	  function(data, menu)
	  	if data.current.value == 'deposit' then
	  		local elem = {}
	  		PlayerData = ESX.GetPlayerData()
			for i=1, #PlayerData.inventory, 1 do
				if PlayerData.inventory[i].count > 0 then
				    table.insert(elem, {
				      label     = PlayerData.inventory[i].label .. ' x' .. PlayerData.inventory[i].count,
				      count     = PlayerData.inventory[i].count,
				      value     = PlayerData.inventory[i].name,
				      name     = PlayerData.inventory[i].label,
				    })
				end
			end
			ESX.UI.Menu.Open(
			  'inventory', GetCurrentResourceName(), 'inventory_player',
			  {
			    title    = 'Contenu de l\'inventaire',
			    align    = 'bottom-right',
			    elements = elem,
			  },function(data3, menu3)
				ESX.UI.Menu.Open(
				  'dialog', GetCurrentResourceName(), 'inventory_item_count_give',
				  {
				    title = 'quantité'
				  },
				  function(data4, menu4)

				    local quantity = tonumber(data4.value)
				    vehFront = VehicleInFront()

				    if quantity > 0 and quantity <= tonumber(data3.current.count) and vehFront > 0 then
				    	local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
				    	local closecar = GetClosestVehicle(x, y, z, 4.0, 0, 71)
				      TriggerServerEvent('esx_truck_inventory:addInventoryItem', GetVehicleClass(closecar), GetDisplayNameFromVehicleModel(GetEntityModel(closecar)), GetVehicleNumberPlateText(vehFront), data3.current.value, quantity, data3.current.name)
				    else
			      		ESX.ShowNotification('~rQuantité invalide')
				    end

				    ESX.UI.Menu.CloseAll()

		        	local vehFront = VehicleInFront()
		          	if vehFront > 0 then
		              TriggerServerEvent("esx_truck_inventory:getInventory", GetVehicleNumberPlateText(vehFront))
		            else
		              SetVehicleDoorShut(vehFrontBack, 5, false)
		            end
				  end,
				  function(data4, menu4)
		            SetVehicleDoorShut(vehFrontBack, 5, false)
				    ESX.UI.Menu.CloseAll()
				  end
				)
			end)
	  	else
			ESX.UI.Menu.Open(
			  'dialog', GetCurrentResourceName(), 'inventory_item_count_give',
			  {
			    title = 'quantité'
			  },
			  function(data2, menu2)

			    local quantity = tonumber(data2.value)
			    vehFront = VehicleInFront()

			    if quantity > 0 and quantity <= tonumber(data.current.count) and vehFront > 0 then
			      TriggerServerEvent('esx_truck_inventory:removeInventoryItem', GetVehicleNumberPlateText(vehFront), data.current.value, quantity)
			    else
			      ESX.ShowNotification('~rQuantité invalide')
			    end

			    ESX.UI.Menu.CloseAll()

	        	local vehFront = VehicleInFront()
	          	if vehFront > 0 then
	          		ESX.SetTimeout(1500, function()
	              		TriggerServerEvent("esx_truck_inventory:getInventory", GetVehicleNumberPlateText(vehFront))
	          		end)
	            else
	              SetVehicleDoorShut(vehFrontBack, 5, false)
	            end
			  end,
			  function(data2, menu2)
	            SetVehicleDoorShut(vehFrontBack, 5, false)
			    ESX.UI.Menu.CloseAll()
			  end
			)
	  	end
	  end)
end)
]]

function GetQty()
	DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 10)
	while (UpdateOnscreenKeyboard() == 0) do
		DisableAllControlActions(0);
		Wait(0);
	end
	if (GetOnscreenKeyboardResult()) then
		return (tonumber(GetOnscreenKeyboardResult()) or 0)
	else
		return 0
	end
end

RegisterNetEvent('esx_truck_inventory:displayMenu')
AddEventHandler('esx_truck_inventory:displayMenu', function(car_i, car_d, play_i, play_d, car_size, car_m, car_s)
	local elements_D = {}
	local elements_R = {}
	local vehFront = VehicleInFront()
	local poidJ = 0
	local poidV = 0
	SetVehicleDoorOpen(vehFront, 5, false, false)

	table.insert(elements_D, {label = "Argent Propre : " .. play_d.cash .. "$/" .. car_m .. "$", count = play_d.cash, type = "cash", value = "cash"})
	table.insert(elements_D, {label = "Argent Sale : " .. play_d.sale .. "$/" .. car_s .. "$", count = play_d.sale, type = "sale", value = "sale"})
	table.insert(elements_R, {label = "Argent Propre : " .. car_d.cash .. "$/" .. car_m .. "$", count = car_d.cash, type = "cash", value = "cash"})
	table.insert(elements_R, {label = "Argent Sale : " .. car_d.sale .. "$/" .. car_s .. "$", count = car_d.sale, type = "sale", value = "sale"})

	for nb,value in pairs(car_i) do
		if value.count > 0 then
			table.insert(elements_R, {
				label = value.name .. " x" .. value.count .. " [" .. (((value.ppi or 0) / 10) * value.count) .. "kg]",
				name = value.name,
				count = value.count,
				ppi = value.ppi or 0,
				type = "item",
				value = value.item
			})
			poidV = poidV + ((value.ppi or 0) * value.count)
		end
	end

	for nb,value in pairs(play_i) do
		if value.count > 0 then
			table.insert(elements_D, value)
			poidJ = poidJ + ((value.ppi or 0) * value.count)
		end
	end

	for nb,value in pairs(car_d.weapon) do
		if value.count > 0 then
			table.insert(elements_R, {
				label = value.label .. " x" .. (value.count or 1) .. " (munition : " .. (value.ammo or 0) .. ") [" .. ((value.ppi or 0) / 10) .. "kg]",
				name = value.label,
				ammo = value.ammo,
				count = value.count or 1,
				ppi = value.ppi or 0,
				type = "weapon",
				value = value.name
			})
			poidV = poidV + value.ppi
		end
	end

	local ListWeapons = ESX.GetWeaponList()
	for nb,value in pairs(ListWeapons) do

    if HasPedGotWeapon(GetPlayerPed(-1),  GetHashKey(value.name),  false) and value.name ~= 'WEAPON_UNARMED' then
      local ammo = GetAmmoInPedWeapon(GetPlayerPed(-1), GetHashKey(value.name))
      table.insert(elements_D, {
        label     = value.label .. ' (munition : ' .. ammo .. ') [' .. (value.ppi / 10) .. "kg]",
				name      = value.label,
				ammo      = ammo,
				count     = 1,
				ppi       = value.ppi,
        type      = 'weapon',
        value     = value.name
      })
      poidJ = poidJ + value.ppi
		end
	end

	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'coffre_principal',
	  {
	    title    = 'Coffre véhicule',
	    align    = 'bottom-right',
	    elements = {
				{label = "Déposer (" .. (poidV / 10) .. "/" .. (car_size / 10) .. " kg)", value = "deposer"},
				{label = "Retirer (" .. (poidJ / 10) .. "/10 kg)", value = "retirer"}
			},
	  },
	  function(data, menu)
	  	if data.current.value == 'deposer' then
				menu.close()

				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'coffre_deposer',
					{
						title    = 'Déposer dans le coffre (' .. (poidV / 10) .. '/' .. (car_size / 10) .. ' kg)',
						align    = 'bottom-right',
						elements = elements_D,
					},
					function(data2, menu2)
						if data2.current.type == 'cash' then
							menu2.close()
							TriggerServerEvent('esx_truck_inventory:cash_AddInCoffre', GetVehicleNumberPlateText(vehFront), GetVehicleClass(vehFront), GetQty())
							SetVehicleDoorShut(vehFront, 5, false)
						end
						if data2.current.type == 'sale' then
							menu2.close()
							TriggerServerEvent('esx_truck_inventory:sale_AddInCoffre', GetVehicleNumberPlateText(vehFront), GetVehicleClass(vehFront), GetQty())
							SetVehicleDoorShut(vehFront, 5, false)
						end
						if data2.current.type == 'item' then
							menu2.close()
							TriggerServerEvent('esx_truck_inventory:addInventoryItem', GetVehicleNumberPlateText(vehFront), GetVehicleClass(vehFront), data2.current.value, data2.current.name, GetQty())
							SetVehicleDoorShut(vehFront, 5, false)
						end
						if data2.current.type == 'weapon' then
							menu2.close()
							TriggerServerEvent('esx_truck_inventory:weapon_AddInCoffre', GetVehicleNumberPlateText(vehFront), GetVehicleClass(vehFront), data2.current.value, data2.current.name, data2.current.ammo, data2.current.ppi, 1)
							SetVehicleDoorShut(vehFront, 5, false)
						end
					end,
				  function(data2, menu2)
		        SetVehicleDoorShut(vehFront, 5, false)
				    ESX.UI.Menu.CloseAll()
				  end
				)
			end

			if data.current.value == 'retirer' then
	  		menu.close()

				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'coffre_retirer',
					{
						title    = 'Retier du coffre (' .. (poidJ / 10) .. '/10 kg)',
						align    = 'bottom-right',
						elements = elements_R,
					},
					function(data3, menu3)
						if data3.current.type == 'cash' then
							menu3.close()
							TriggerServerEvent('esx_truck_inventory:cash_AddInCoffre', GetVehicleNumberPlateText(vehFront), GetVehicleClass(vehFront), 0 - GetQty())
							SetVehicleDoorShut(vehFront, 5, false)
						end
						if data3.current.type == 'sale' then
							menu3.close()
							TriggerServerEvent('esx_truck_inventory:sale_AddInCoffre', GetVehicleNumberPlateText(vehFront), GetVehicleClass(vehFront), 0 - GetQty())
							SetVehicleDoorShut(vehFront, 5, false)
						end
						if data3.current.type == 'item' then
							menu3.close()
							TriggerServerEvent('esx_truck_inventory:removeInventoryItem', GetVehicleNumberPlateText(vehFront), GetVehicleClass(vehFront), data3.current.value, data3.current.name,  0 - GetQty())
							SetVehicleDoorShut(vehFront, 5, false)
						end
						if data3.current.type == 'weapon' then
							menu3.close()
							TriggerServerEvent('esx_truck_inventory:weapon_AddInCoffre', GetVehicleNumberPlateText(vehFront), GetVehicleClass(vehFront), data3.current.value, data3.current.name, data3.current.ammo, data3.current.ppi, -1)
							SetVehicleDoorShut(vehFront, 5, false)
						end
					end,
				  function(data3, menu3)
		        SetVehicleDoorShut(vehFront, 5, false)
				    ESX.UI.Menu.CloseAll()
				  end
				)
			end
		end,
		function(data, menu)
			SetVehicleDoorShut(vehFront, 5, false)
			ESX.UI.Menu.CloseAll()
		end
	)
end)
