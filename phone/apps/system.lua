ESX = nil

Citizen.CreateThread(function()

	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

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

	local GUI      = {}
	GUI.Time       = 0
	local phone = "666"
	local zoom = 10
	local fond = 8
	local message = {} -- { phone, isSender, isAnonyme, message, isRead, date }
	local contact = {} -- { phone, name }
	local comaMode = false



	function refreshSMSnb ()
		local nbMsg = 0
		for nb,value in pairs(message) do
			nbMsg = nbMsg + 1
		end

		SendNUIMessage({
			action  = 'refreshSMSnb',
			myNbMsg = nbMsg,
		})
	end



	-- take : { value : /contactName/ }  return : { value : /contactName/ }
	RegisterNUICallback('askContactName', function(data, cb)

		DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", data.value or "", "", "", "", 22)
		while (UpdateOnscreenKeyboard() == 0) do
		  DisableAllControlActions(0);
		  Wait(0);
		end
		if (GetOnscreenKeyboardResult()) then
			SendNUIMessage({
				action  = 'setContactName',
				value = GetOnscreenKeyboardResult() or ""
			})
		end

		cb('OK')
	end)
	-- take : { value : /nbPhone/ }  return : { value : /nbPhone/ }
	RegisterNUICallback('askContactNumber', function(data, cb)

		DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", data.value or "", "", "", "", 10)
		while (UpdateOnscreenKeyboard() == 0) do
		  DisableAllControlActions(0);
		  Wait(0);
		end
		if (GetOnscreenKeyboardResult()) then
			SendNUIMessage({
				action  = 'setContactNumber',
				value = GetOnscreenKeyboardResult() or ""
			})
		end

		cb('OK')
	end)


	-- take : { phone : /nbPhone/ }
	RegisterNUICallback('delContact', function(data, cb)
		TriggerServerEvent('phone:deleteContact', data.phone or "666")
		for nb,value in pairs(contact) do
			if value.phone == data.phone then
				contact[nb] = nil
			end
		end
		cb('OK')

		local datas = {}
		for nb,value in pairs(contact) do
			if value ~= nil then
				table.insert(datas, value)
			end
		end
		SendNUIMessage({
			action  = 'openContact',
			mymessage = datas
		})
	end)
	-- take : { phone : /nbPhone/ , name : /contactName/ }
	RegisterNUICallback('addContact', function(data, cb)
		TriggerServerEvent('phone:addContact', data.phone or "666", data.name or "unnamed")
		table.insert(contact, {
			name = data.name or "unnamed",
			phone = data.phone or "666"
		})
		cb('OK')

		local datas = {}
		for nb,value in pairs(contact) do
			if value ~= nil then
				table.insert(datas, value)
			end
		end
		SendNUIMessage({
			action  = 'openContact',
			mymessage = datas
		})
	end)
	-- take : { original : /oldPhone/ , phone : /nbPhone/ , name : /contactName/ }
	RegisterNUICallback('modifyContact', function(data, cb)
		TriggerServerEvent('phone:modifyContact', data.original or "666", data.phone or "666", data.name or "unnamed")
		for nb,value in pairs(contact) do
			if value.phone == data.original then
				contact[nb].phone = data.phone or "666"
				contact[nb].name = data.name or "unnamed"
			end
		end
		cb('OK')

		local datas = {}
		for nb,value in pairs(contact) do
			if value ~= nil then
				table.insert(datas, value)
			end
		end
		SendNUIMessage({
			action  = 'openContact',
			mymessage = datas
		})
	end)


	-- take : {}   return : call('openContact')
	RegisterNUICallback('openContact', function(data, cb)
		local datas = {}
		for nb,value in pairs(contact) do
			if value ~= nil then
				table.insert(datas, value)
			end
		end
		SendNUIMessage({
			action  = 'openContact',
			mymessage = datas
		})
		cb('OK')
	end)


	-- take : {}   return : call('openMessageMenu')
	RegisterNUICallback('openMessageMenu', function(data, cb)
		local datas = {}
		local temp = {}
		local anonyme = false
		for nb,value in pairs(contact) do
			if value ~= nil then
				--ESX.ShowNotification("Debug : from(contact) add phone = " .. (value.phone or "nul") .. " | name = " .. (value.name or "nul") .. " | ts = 0")
				temp[value.phone] = {
					name = value.name,
					ts = 0
				}
			end
		end
		for nb,value in pairs(message) do
			if value ~= nil then
				if value.isAnonyme == 0 then
					--ESX.ShowNotification("Debug : from(message) add phone = " .. (value.phone or "nul") .. " | ts = " .. (value.date or "nul"))
					if temp[value.phone] ~= nil then
						if (tonumber(temp[value.phone].ts) or 0) < (tonumber(value.date) or 0) then
							temp[value.phone].ts = value.date
						end
					else
						temp[value.phone] = {
							name = value.phone,
							ts = value.date
						}
					end
				else
					--[[table.insert(datas, {
						name = "Anonyme",
						phone = value.phone
					})
					anonyme = true]]
				end
			end
		end
		local lastTemp = 0
		local temp_data = {}
		local noMore = false
		local noMore2 = true
		while noMore == false do
			lastTemp = 0
			temp_data = {}
			noMore2 = true
			for nb,value in pairs(temp) do
				if value ~= false then
					noMore2 = false
					if (tonumber(value.ts) or 0) >= (tonumber(lastTemp) or 0) then
						lastTemp = tonumber(value.ts)
						temp_data = {
							name = value.name,
							phone = nb
						}
					end
				end
			end
			if noMore2 == true then
				noMore = true
			else
				--ESX.ShowNotification("Debug : from(loop) add phone = " .. (temp_data.phone or "nul") .. " | name = " .. (temp_data.name or "nul") .. " | ts = " .. (lastTemp or "nul"))
				table.insert(datas, temp_data)
				temp[temp_data.phone] = false
			end
		end
		SendNUIMessage({
			action  = 'openMessageMenu',
			mymessage = datas
		})
		cb('OK')
	end)

	--[[function reopenMessageMenu ()
		local datas = {}
		local temp = {}
		for nb,messag in pairs(message) do
			if messag ~= nil then
				if messag.isAnonyme == 0 then
					temp[messag.phone_2] = true
				end
			end
		end
		for nb,contac in pairs(contact) do
			if contac ~= nil then
				table.insert(datas, {
					name = contac.name,
					phone = "0" .. tonumber(contac.phone)
				})
				temp[contac.phone] = false
			end
		end
		for nb,value in pairs(temp) do
			if value == true then
				table.insert(datas, {
					name = "0" .. nb,
					phone = "0" .. tonumber(nb)
				})
				temp[nb] = false
			end
		end
		SendNUIMessage({
			action  = 'openMessageMenu',
			mymessage = datas
		})
	end]]


	-- take : { phone : /nbPhone/ }   return : call('openMessageChat')
	RegisterNUICallback('openMessageChat', function(data, cb)
		local datas = {}
		local nom = data.phone or "666"
		for nb,value in pairs(message) do
			if value ~= nil then
				if value.phone == data.phone then
					if value.isAnonyme == 0 then
						table.insert(datas, value)
					end
				end
			end
		end
		for nb,value in pairs(contact) do
			if value ~= nil then
				if value.phone == data.phone then
					nom = value.name
				end
			end
		end
		SendNUIMessage({
			action  = 'openMessageChat',
			name = nom,
			phone = data.phone or "666",
			mymessage = datas
		})
		cb('OK')
	end)
	-- take : {}   return : call('openMessageChat')
	RegisterNUICallback('openNewMessageChat', function(data, cb)
		cb('OK')
		DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 22)
		while (UpdateOnscreenKeyboard() == 0) do
		  DisableAllControlActions(0);
		  Wait(0);
		end
		if (GetOnscreenKeyboardResult()) then
			local datas = {}
			local ph = GetOnscreenKeyboardResult() or "666"
			local nom = ph
			for nb,value in pairs(message) do
				if value ~= nil then
					if value.phone == ph then
						if value.isAnonyme == 0 then
							table.insert(datas, value)
						end
					end
				end
			end
			for nb,value in pairs(contact) do
				if value ~= nil then
					if value.phone == ph then
						nom = value.name
					end
				end
			end
			SendNUIMessage({
				action  = 'openMessageChat',
				name = nom,
				phone = ph,
				mymessage = datas
			})
		else
			local datas = {}
			local temp = {}
			local anonyme = false
			for nb,value in pairs(contact) do
				if value ~= nil then
					--ESX.ShowNotification("Debug : from(contact) add phone = " .. (value.phone or "nul") .. " | name = " .. (value.name or "nul") .. " | ts = 0")
					temp[value.phone] = {
						name = value.name,
						ts = 0
					}
				end
			end
			for nb,value in pairs(message) do
				if value ~= nil then
					if value.isAnonyme == 0 then
						--ESX.ShowNotification("Debug : from(message) add phone = " .. (value.phone or "nul") .. " | ts = " .. (value.date or "nul"))
						if temp[value.phone] ~= nil then
							if (tonumber(temp[value.phone].ts) or 0) < (tonumber(value.date) or 0) then
								temp[value.phone].ts = value.date
							end
						else
							temp[value.phone] = {
								name = value.phone,
								ts = value.date
							}
						end
					else
						--[[table.insert(datas, {
							name = "Anonyme",
							phone = value.phone
						})
						anonyme = true]]
					end
				end
			end
			local lastTemp = 0
			local temp_data = {}
			local noMore = false
			local noMore2 = true
			while noMore == false do
				lastTemp = 0
				temp_data = {}
				noMore2 = true
				for nb,value in pairs(temp) do
					if value ~= false then
						noMore2 = false
						if (tonumber(value.ts) or 0) >= (tonumber(lastTemp) or 0) then
							lastTemp = tonumber(value.ts)
							temp_data = {
								name = value.name,
								phone = nb
							}
						end
					end
				end
				if noMore2 == true then
					noMore = true
				else
					--ESX.ShowNotification("Debug : from(loop) add phone = " .. (temp_data.phone or "nul") .. " | name = " .. (temp_data.name or "nul") .. " | ts = " .. (lastTemp or "nul"))
					table.insert(datas, temp_data)
					temp[temp_data.phone] = false
				end
			end
			SendNUIMessage({
				action  = 'openMessageMenu',
				mymessage = datas
			})
		end
	end)


	-- take : { phone : /nbPhone/ , ts : /date/ }
	RegisterNUICallback('SendMessage', function(data, cb)
		cb('OK')
		DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 160)
		while (UpdateOnscreenKeyboard() == 0) do
		  DisableAllControlActions(0);
		  Wait(0);
		end
		if (GetOnscreenKeyboardResult()) then
			TriggerServerEvent('phone:addMessage', data.phone or "666", GetOnscreenKeyboardResult() or "", 0, data.ts)
			table.insert(message, {phone = data.phone or "666", isSender = 1, isRead = 1, message = GetOnscreenKeyboardResult() or "", isAnonyme = 0, date = data.ts})
		end
		refreshSMSnb()

		local datas = {}
		local nom = data.phone or "666"
		for nb,value in pairs(message) do
			if value ~= nil then
				if value.phone == data.phone then
					if value.isAnonyme == 0 then
						table.insert(datas, value)
					end
				end
			end
		end
		for nb,value in pairs(contact) do
			if value ~= nil then
				if value.phone == data.phone then
					nom = value.name
				end
			end
		end
		SendNUIMessage({
			action  = 'openMessageChat',
			name = nom,
			phone = data.phone or "666",
			mymessage = datas
		})
	end)
	-- take : { phone : /nbPhone/ , ts : /date/ }
	RegisterNUICallback('SendGPSMessage', function(data, cb)
		local plyCoords = GetEntityCoords(GetPlayerPed(-1), 1)
		TriggerServerEvent('phone:addMessage', data.phone or "666", "_GPS : {" .. plyCoords['x'] .. ",  " .. plyCoords['y'] .. "}", 0, data.ts)
		cb('OK')

		table.insert(message, {phone = data.phone or "666", isSender = 1, isRead = 1, message = "_GPS : {" .. plyCoords['x'] .. " " .. plyCoords['y'] .. "}", isAnonyme = 0, date = data.ts})
		refreshSMSnb()

		local datas = {}
		local nom = data.phone or "666"
		for nb,value in pairs(message) do
			if value ~= nil then
				if value.phone == data.phone then
					if value.isAnonyme == 0 then
						table.insert(datas, value)
					end
				end
			end
		end
		for nb,value in pairs(contact) do
			if value ~= nil then
				if value.phone == data.phone then
					nom = value.name
				end
			end
		end
		SendNUIMessage({
			action  = 'openMessageChat',
			name = nom,
			phone = data.phone or "666",
			mymessage = datas
		})
	end)
	-- take : { phone : /nbPhone/ }
	RegisterNUICallback('SendAnonymeMessage', function(data, cb)
		cb('OK')
		DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 160)
		while (UpdateOnscreenKeyboard() == 0) do
			DisableAllControlActions(0);
			Wait(0);
		end
		if (GetOnscreenKeyboardResult()) then
			TriggerServerEvent('phone:addMessage', data.phone or "666", GetOnscreenKeyboardResult() or "", 1)
			table.insert(message, {phone = data.phone or "666", isSender = 1, isRead = 1, message = GetOnscreenKeyboardResult() or "", isAnonyme = 1, date = "Il y a pas longtemps"})
		end
		refreshSMSnb()

		local datas = {}
		local nom = data.phone or "666"
		for nb,value in pairs(message) do
			if value ~= nil then
				if value.phone == data.phone then
					if value.isAnonyme == 0 then
						table.insert(datas, value)
					end
				end
			end
		end
		for nb,value in pairs(contact) do
			if value ~= nil then
				if value.phone == data.phone then
					nom = value.name
				end
			end
		end
		SendNUIMessage({
			action  = 'openMessageChat',
			name = nom,
			phone = data.phone or "666",
			mymessage = datas
		})
	end)
	-- take : { phone : /nbPhone/ , msg : /message/ , date : /date/ }
	RegisterNUICallback('DeleteMessage', function(data, cb)
		cb('OK')

		TriggerServerEvent('phone:deleteMessage', data.phone or "666", data.msg or "", data.date or "Il y a pas longtemps")

		for nb,value in pairs(message) do
			if value ~= nil then
				if value.phone == data.phone then
					if value.message == data.msg then
						if value.date == data.date then
							message[nb] = nil
						end
					end
				end
			end
		end

		refreshSMSnb()

		local datas = {}
		local nom = data.phone or "666"
		for nb,value in pairs(message) do
			if value ~= nil then
				if value.phone == data.phone then
					if value.isAnonyme == 0 then
						table.insert(datas, value)
					end
				end
			end
		end
		for nb,value in pairs(contact) do
			if value ~= nil then
				if value.phone == data.phone then
					nom = value.name
				end
			end
		end
		SendNUIMessage({
			action  = 'openMessageChat',
			name = nom,
			phone = data.phone or "666",
			mymessage = datas
		})
	end)


	-- take : { phone : /nbPhone/ }
	RegisterNUICallback('deleteConversation', function(data, cb)
		cb('OK')

		TriggerServerEvent('phone:deleteConversation', data.phone or "666")

		for nb,value in pairs(message) do
			if value ~= nil then
				if value.phone == data.phone then
					message[nb] = nil
				end
			end
		end

		refreshSMSnb()

		local datas = {}
		local temp = {}
		local anonyme = false
		for nb,value in pairs(contact) do
			if value ~= nil then
				--ESX.ShowNotification("Debug : from(contact) add phone = " .. (value.phone or "nul") .. " | name = " .. (value.name or "nul") .. " | ts = 0")
				temp[value.phone] = {
					name = value.name,
					ts = 0
				}
			end
		end
		for nb,value in pairs(message) do
			if value ~= nil then
				if value.isAnonyme == 0 then
					--ESX.ShowNotification("Debug : from(message) add phone = " .. (value.phone or "nul") .. " | ts = " .. (value.date or "nul"))
					if temp[value.phone] ~= nil then
						if (tonumber(temp[value.phone].ts) or 0) < (tonumber(value.date) or 0) then
							temp[value.phone].ts = value.date
						end
					else
						temp[value.phone] = {
							name = value.phone,
							ts = value.date
						}
					end
				else
					--[[table.insert(datas, {
						name = "Anonyme",
						phone = value.phone
					})
					anonyme = true]]
				end
			end
		end
		local lastTemp = 0
		local temp_data = {}
		local noMore = false
		local noMore2 = true
		while noMore == false do
			lastTemp = 0
			temp_data = {}
			noMore2 = true
			for nb,value in pairs(temp) do
				if value ~= false then
					noMore2 = false
					if (tonumber(value.ts) or 0) >= (tonumber(lastTemp) or 0) then
						lastTemp = tonumber(value.ts)
						temp_data = {
							name = value.name,
							phone = nb
						}
					end
				end
			end
			if noMore2 == true then
				noMore = true
			else
				--ESX.ShowNotification("Debug : from(loop) add phone = " .. (temp_data.phone or "nul") .. " | name = " .. (temp_data.name or "nul") .. " | ts = " .. (lastTemp or "nul"))
				table.insert(datas, temp_data)
				temp[temp_data.phone] = false
			end
		end
		SendNUIMessage({
			action  = 'openMessageMenu',
			mymessage = datas
		})
	end)


	-- take : { phone : /nbPhone/ , msg : /message/ }
	RegisterNUICallback('setGPS', function(data, cb)
		if data.msg:sub(1,4) == "_GPS" then
			local coord = json.decode(data.msg:sub(8))
			local x1 = coord[1] or tonumber('0.0')
			local y1 = coord[2] or tonumber('0.0')
			ESX.ShowNotification("Triangulation GPS : OK")
			SetNewWaypoint(x1,y1)
		else

			ESX.ShowNotification("Coordonnées illisible")
		end
	end)


	-- take : {}
	RegisterNUICallback('resetSMS', function(data, cb)
		TriggerServerEvent('phone:resetSMS')
		message = {}
		refreshSMSnb()
		cb('OK')
	end)
	-- take : {}
	RegisterNUICallback('resetTel', function(data, cb)
		TriggerServerEvent('phone:resetTel')
		message = {}
		contact = {}
		refreshSMSnb()
		cb('OK')
	end)


	-- take : { service : /service/ , raison : /raison/ }
	RegisterNUICallback('Appel', function(data, cb)
		data.raison = data.raison:sub(43) or "__inconnu__"
		if data.service == "mecano" then
			ESX.ShowNotification("- Depan'O'matic bonjour, que puis je faire pour vous ?")
			ESX.ShowNotification("- " .. data.raison)
			ESX.ShowNotification("- ok, je vous envoi une depanneuse")
		elseif data.service == "taxi" then
			ESX.ShowNotification("- Taxi Fron bonjour, que puis je faire pour vous ?")
			ESX.ShowNotification("- " .. data.raison)
			ESX.ShowNotification("- ok, je vous envoi un chauffard")
		else
			ESX.ShowNotification("- 911, what's your emergency ?")
			ESX.ShowNotification("- " .. data.raison)
			ESX.ShowNotification("- ok, je vous envoi les secours")
		end
		local plyCoords = GetEntityCoords(GetPlayerPed(-1), 1)
		TriggerServerEvent('phone:call', data.service, data.raison, plyCoords['x'], plyCoords['y'], plyCoords['z'])
		cb('OK')
	end)


	-- take : { zoom : /zoom/ , fond : /fond/ }
	RegisterNUICallback('saveData', function(data, cb)
		zoom = data.zoom or zoom
		fond = data.fond or fond
		TriggerServerEvent('phone:saveData', data.zoom or zoom, data.fond or fond)
		cb('OK')
	end)


	-- take : {}
	RegisterNUICallback('openTel', function(data, cb)
		ePhoneInAnim()
		cb('OK')
	end)
	-- take : {}
	RegisterNUICallback('closeTel', function(data, cb)
		ePhoneOutAnim()
		cb('OK')
	end)


	-- take : {}
	RegisterNUICallback('callComa', function(data, cb)
		local plyCoords = GetEntityCoords(GetPlayerPed(-1), 1)
		TriggerServerEvent('phone:dispatchComa', plyCoords['x'], plyCoords['y'], plyCoords['z'])
		ESX.ShowNotification('Votre appel va etre redirigé vers les service de secours')
		cb('OK')
	end)
	-- take : {}
	RegisterNUICallback('respawn', function(data, cb)
		TriggerEvent('phone:doRespawn')
		ESX.ShowNotification('Vous avez choisis de respawn')
		cb('OK')
	end)

	Citizen.CreateThread(function()
		while true do
	  	    Wait(0)

			if IsControlPressed(0, Keys['ENTER']) and (GetGameTimer() - GUI.Time) > 150 then
				SendNUIMessage({
					action  = 'controlPressed',
					control = 'ENTER'
				})
				GUI.Time = GetGameTimer()
			end

			if IsControlPressed(0, Keys['H']) and (GetGameTimer() - GUI.Time) > 150 then
				SendNUIMessage({
					action  = 'controlPressed',
					control = 'H'
				})
				GUI.Time = GetGameTimer()
			end

			if IsControlPressed(0, Keys['BACKSPACE']) and (GetGameTimer() - GUI.Time) > 150 then
				SendNUIMessage({
					action  = 'controlPressed',
					control = 'BACKSPACE'
				})
				GUI.Time = GetGameTimer()
			end

			if IsControlPressed(0, Keys['TOP']) and (GetGameTimer() - GUI.Time) > 150 then
				SendNUIMessage({
					action  = 'controlPressed',
					control = 'TOP'
				})
				GUI.Time = GetGameTimer()
			end

			if IsControlPressed(0, Keys['DOWN']) and (GetGameTimer() - GUI.Time) > 150 then
				SendNUIMessage({
					action  = 'controlPressed',
					control = 'DOWN'
				})
				GUI.Time = GetGameTimer()
			end

			if IsControlPressed(0, Keys['LEFT']) and (GetGameTimer() - GUI.Time) > 150 then
				SendNUIMessage({
					action  = 'controlPressed',
					control = 'LEFT'
				})
				GUI.Time = GetGameTimer()
			end

			if IsControlPressed(0, Keys['RIGHT']) and (GetGameTimer() - GUI.Time) > 150 then
				SendNUIMessage({
					action  = 'controlPressed',
					control = 'RIGHT'
				})
				GUI.Time = GetGameTimer()
			end

	  end
	end)

	RegisterNetEvent('phone:loaded')
	AddEventHandler('phone:loaded', function(number, zooom, foond, msg, ctct)
		local nbMsg = 0
		for nb,messag in pairs(msg) do
			nbMsg = nbMsg + 1
		end

		SendNUIMessage({
			action  = 'loaded',
			myphone = number or phone,
			myzoom = zooom or zoom,
			myfond = foond or fond,
			myNbMsg = nbMsg
		})

		message = {}
		for nb,value in pairs(msg) do
			if value ~= nil then
				table.insert(message, {phone = value.phone_2, isSender = value.is1Sender, isAnonyme = value.isAnonyme, message = value.message, isRead = value.isRead, date = value.date})
			end
		end
		contact = {}
		for nb,value in pairs(ctct) do
			if value ~= nil then
				table.insert(contact, {phone = value.phone, name = value.name})
			end
		end
		phone = number or phone
		zoom = zooom or zoom
		fond = foond or fond
	end)
	TriggerServerEvent('phone:load_Data')



	RegisterNetEvent('phone:newMessage')
	AddEventHandler('phone:newMessage', function(from, to, msg, anonyme, date)
		if from == phone then
			ESX.ShowNotification("Message envoyé")
		elseif to == phone then
			local name = from
			for nb,value in pairs(contact) do
				if value.phone == from then
					name = value.name
				end
			end
			if anonyme == 1 then
				name = "inconnu"
			end
			table.insert(message, {phone = from, isSender = 0, isRead = 0, message = msg, isAnonyme = anonyme, date = date})
			SendNUIMessage({
				action  = 'playSonnerie'
			})
			ESX.ShowNotification("Message reçu de " .. name .. " : " .. msg)
		end
	end)

	RegisterNetEvent('phone:deadMenu')
	AddEventHandler('phone:deadMenu', function(DCD)
		comaMode = DCD
		if DCD == true then
			ESX.ShowNotification("Utiliser votre téléphone (H) pour appelez les secours")
			SendNUIMessage({
				action  = 'deadMode',
				value = DCD
			})
		else
			SendNUIMessage({
				action  = 'deadMode',
				value = DCD
			})
		end
	end)
end)
