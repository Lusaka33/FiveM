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

RegisterNetEvent('entreprise:displayCoffre')
AddEventHandler('entreprise:displayCoffre', function(job, car_i, play_i)
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


	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open(
	  'inventory', GetCurrentResourceName(), 'coffre_principal',
	  {
	    title    = 'Coffre d\'entreprise',
	    align    = 'bottom-right',
	    elements = {
				{label = "Déposer (" .. (poidV / 10) .. "/250 kg)", value = "deposer"},
				{label = "Retirer (" .. (poidJ / 10) .. "/10 kg)", value = "retirer"}
			},
	  },
	  function(data, menu) 
	  	if data.current.value == 'deposer' then
				menu.close()
				
				ESX.UI.Menu.Open(
					'inventory', GetCurrentResourceName(), 'coffre_deposer',
					{
						title    = 'Déposer dans le coffre (' .. (poidV / 10) .. '/250 kg)',
						align    = 'bottom-right',
						elements = elements_D,
					},
					function(data2, menu2) 
							menu2.close()
							TriggerServerEvent('entreprise:addItemCoffre', job, data2.current.value, GetQty())
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
						title    = 'Retier du coffre (' .. (poidJ / 10) .. '/10 kg)',
						align    = 'bottom-right',
						elements = elements_R,
					},
					function(data3, menu3) 
						menu3.close()
						TriggerServerEvent('entreprise:addItemCoffre', job, data3.current.value,  0 - GetQty())
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