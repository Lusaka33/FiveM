RegisterNetEvent('entreprise:displayArmurerie')
AddEventHandler('entreprise:displayArmurerie', function(job, weap)

	local els = {}
	local play_weap = {}

	local ListWeapons = ESX.GetWeaponList()
	for nb,value in pairs(ListWeapons) do

		if HasPedGotWeapon(GetPlayerPed(-1),  GetHashKey(value.name),  false) and value.name ~= 'WEAPON_UNARMED' then
        local ammo = GetAmmoInPedWeapon(GetPlayerPed(-1), GetHashKey(value.name))
        play_weap[value.name] = {
				label     = value.label,
				name      = value.name,
				ammo      = ammo,
				count     = 1,
				ppi       = value.ppi
			}
		end
	end

	for nb,value in pairs(weap) do
    if play_weap[value.name] ~= nil then
      table.insert(els, {
        label = "Reposer : " .. ESX.GetWeaponLabel(value.name) .. " (dans l'armurerie : " .. value.dispo .. "/" .. value.total .. ")",
        type = "deposer",
        value = value.name
      })
    else
      table.insert(els, {
        label = "Prendre : " .. ESX.GetWeaponLabel(value.name) .. " (dans l'armurerie : " .. value.dispo .. "/" .. value.total .. ")",
        type = "take",
        value = value.name
      })
    end
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open(
	  'inventory', GetCurrentResourceName(), 'coffre_principal',
	  {
	    title    = 'Armurerie',
	    align    = 'bottom-right',
	    elements = els
	  },
	  function(data, menu)
      if data.current.type == 'deposer' then
        menu.close()
        TriggerServerEvent('entreprise:putArmurerie', job, data.current.value)
      end
      if data.current.type == 'take' then
        menu.close()
        TriggerServerEvent('entreprise:takeArmurerie', job, data.current.value)
      end
    end,
    function(data, menu)
      ESX.UI.Menu.CloseAll()
    end
	)
end)
