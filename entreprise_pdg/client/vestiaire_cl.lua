function GetQty_2()
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

RegisterNetEvent('entreprise:displayVestiaire')
AddEventHandler('entreprise:displayVestiaire', function(job, car_i, car_w, play_i)
	local elements_D = {}
	local elements_R = {}
	local poidJ = 0
	local poidV = 0

	for nb,value in pairs(car_i) do
		if value.count > 0 then
			table.insert(elements_R, {
				label = value.label .. " x" .. value.count .. " [" .. (((value.ppi or 0) / 10) * value.count) .. "kg]",
				name = value.label,
				count = value.count,
				ppi = value.ppi or 0,
				type = "item",
				value = value.name
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

	for nb,value in pairs(car_w) do
		--if value.count > 0 then
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
		--end
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
	


	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open(
	  'inventory', GetCurrentResourceName(), 'coffre_principal',
	  {
	    title    = 'Vestiaire privé',
	    align    = 'bottom-right',
	    elements = {
			{label = "Déposer (" .. (poidV / 10) .. "/10 kg)", value = "deposer"},
			{label = "Retirer (" .. (poidJ / 10) .. "/10 kg)", value = "retirer"}
		}
	  },
	  function(data, menu) 
	  		if data.current.value == 'deposer' then
				menu.close()
				
				ESX.UI.Menu.Open(
					'inventory', GetCurrentResourceName(), 'coffre_deposer',
					{
						title    = 'Déposer dans le vestiaire (' .. (poidV / 10) .. '/10 kg)',
						align    = 'bottom-right',
						elements = elements_D,
					},
					function(data2, menu2)
						if data2.current.type == 'item' then
							menu2.close()
							TriggerServerEvent('entreprise:item_AddInVestiaire', job, data2.current.value, GetQty_2())
						end
						if data2.current.type == 'weapon' then
							menu2.close()
							TriggerServerEvent('entreprise:weapon_AddInVestiaire', job, data2.current.value, data2.current.name, data2.current.ammo, data2.current.ppi, 1)
						end
					end,
				  function(data2, menu2)
				    ESX.UI.Menu.CloseAll()
				  end
				)
			end

			if data.current.value == 'retirer' then
	  		menu.close()
				
				ESX.UI.Menu.Open(
					'inventory', GetCurrentResourceName(), 'coffre_retirer',
					{
						title    = 'Retier du vestiaire (' .. (poidJ / 10) .. '/10 kg)',
						align    = 'bottom-right',
						elements = elements_R,
					},
					function(data3, menu3) 
						if data3.current.type == 'item' then
							menu3.close()
							TriggerServerEvent('entreprise:item_AddInVestiaire', job, data3.current.value,  0 - GetQty_2())
						end
						if data3.current.type == 'weapon' then
							menu3.close()
							TriggerServerEvent('entreprise:weapon_AddInVestiaire', job, data3.current.value, data3.current.name, data3.current.ammo, data3.current.ppi, -1)
						end
					end,
				  function(data3, menu3)
				    ESX.UI.Menu.CloseAll()
				  end
				)
			end

		end,
		function(data, menu)
			ESX.UI.Menu.CloseAll()
		end
	)
end)