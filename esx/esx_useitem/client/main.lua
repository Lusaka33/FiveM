ESX = nil
local CurrentActionData   = {}
local lastTime            = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)



---------------------------------------------------------------------------------------------
-------------------------------------------USE BONG -----------------------------------------
---------------------------------------------------------------------------------------------

RegisterNetEvent('esx_useitem:bong')
AddEventHandler('esx_useitem:bong', function()

  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

	Citizen.CreateThread(function()

    local playerPed  = GetPlayerPed(-1)
    local coords     = GetEntityCoords(playerPed)
    local boneIndex  = GetPedBoneIndex(playerPed, 18905)
    local boneIndex2 = GetPedBoneIndex(playerPed, 57005)

      RequestAnimDict('anim@safehouse@bong')

    while not HasAnimDictLoaded('anim@safehouse@bong') do
      Citizen.Wait(0)
    end

    ESX.Game.SpawnObject('hei_heist_sh_bong_01', {
      x = coords.x,
      y = coords.y,
      z = coords.z - 3
    }, function(object)

    ESX.Game.SpawnObject('p_cs_lighter_01', {
      x = coords.x,
      y = coords.y,
      z = coords.z - 3
    }, function(object2)

    Citizen.CreateThread(function()

      TaskPlayAnim(playerPed, "anim@safehouse@bong", "bong_stage1", 3.5, -8, -1, 49, 0, 0, 0, 0)
      Citizen.Wait(1500)
      AttachEntityToEntity(object2, playerPed, boneIndex2, 0.10, 0.0, 0, 99.0, 192.0, 180.0, true, true, false, true, 1, true)
      AttachEntityToEntity(object, playerPed, boneIndex, 0.10, -0.25, 0, 95.0, 190.0, 180.0, true, true, false, true, 1, true)
      Citizen.Wait(6000)
      DeleteObject(object)
      DeleteObject(object2)
      ClearPedSecondaryTask(playerPed)
      TriggerServerEvent('esx_useitem:bong')
      end)
     end)
    end)
  end)
end)

-----------------------------------------------------------------------------------------------
------------------------------------------ OUTFIT SWIM ----------------------------------------
-----------------------------------------------------------------------------------------------

RegisterNetEvent('esx_useitem:swim')
AddEventHandler('esx_useitem:swim', function()

  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

	Citizen.CreateThread(function()

    local playerPed  = GetPlayerPed(-1)
    local coords     = GetEntityCoords(playerPed)
    local boneIndex  = GetPedBoneIndex(playerPed, 12844)
    local boneIndex2 = GetPedBoneIndex(playerPed, 24818)

    ESX.Game.SpawnObject('p_s_scuba_mask_s', {
      x = coords.x,
      y = coords.y,
      z = coords.z - 3
    }, function(object)


    ESX.Game.SpawnObject('p_s_scuba_tank_s', {
      x = coords.x,
      y = coords.y,
      z = coords.z - 3
    }, function(object2)

      Citizen.CreateThread(function()
      AttachEntityToEntity(object2, playerPed, boneIndex2, -0.30, -0.22, 0.0, 0.0, 90.0, 180.0, true, true, false, true, 1, true)
      AttachEntityToEntity(object, playerPed, boneIndex, 0.0, 0.0, 0.0, 0.0, 90.0, 180.0, true, true, false, true, 1, true)
      SetPedDiesInWater(playerPed, false)
      ESX.ShowNotification('~g~Boutielle ~s~: 100%')
      ESX.ShowNotification('~g~Allez vous baigner')
      Citizen.Wait(45000)
      ESX.ShowNotification('~y~Boutielle ~s~: 50%')
      Citizen.Wait(45000)
      ESX.ShowNotification('~o~Boutielle ~s~: 10%')
      Citizen.Wait(30000)
      ESX.ShowNotification('~r~Boutielle ~s~: 0%')
      SetPedDiesInWater(playerPed, true)
      DeleteObject(object)
      DeleteObject(object2)
      ClearPedSecondaryTask(playerPed)
      end)
     end)
    end)
  end)
end)

----------------------------------------------------------------------------------------------
---------------------------------------EAT SANDWICH ------------------------------------------
----------------------------------------------------------------------------------------------

RegisterNetEvent('esx_useitem:sandwich')
AddEventHandler('esx_useitem:sandwich', function()

  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

	Citizen.CreateThread(function()

    local playerPed  = GetPlayerPed(-1)
    local coords     = GetEntityCoords(playerPed)
    local boneIndex  = GetPedBoneIndex(playerPed, 18905)
    local boneIndex2 = GetPedBoneIndex(playerPed, 57005)

      RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')

    while not HasAnimDictLoaded('amb@code_human_wander_eating_donut@male@idle_a') do
      Citizen.Wait(0)
    end

    ESX.Game.SpawnObject('prop_sandwich_01', {
      x = coords.x,
      y = coords.y,
      z = coords.z - 3
    }, function(object)


    Citizen.CreateThread(function()

      TaskPlayAnim(playerPed, "amb@code_human_wander_eating_donut@male@idle_a", "idle_c", 3.5, -8, -1, 49, 0, 0, 0, 0)
      AttachEntityToEntity(object, playerPed, boneIndex2, 0.15, 0.01, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
      Citizen.Wait(6500)
      DeleteObject(object)
      ClearPedSecondaryTask(playerPed)
      end)
    end)
  end)
end)

-----------------------------------------------------------------------------------------------
------------------------------------------- Cigarrette ----------------------------------------
-----------------------------------------------------------------------------------------------

RegisterNetEvent('esx_useitem:startSmoke')
AddEventHandler('esx_useitem:startSmoke', function(source)
  SmokeAnimation()
end)

function SmokeAnimation()
  local playerPed = GetPlayerPed(-1)

  Citizen.CreateThread(function()
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING", 0, true)
  end)
end

-----------------------------------------------------------------------------------------------
----------------------------------------- Lockpick -------------------------------------------
-----------------------------------------------------------------------------------------------

RegisterNetEvent('esx_useitem:startLockpick')
AddEventHandler('esx_useitem:startLockpick', function(source)
  LockPick()
end)

function LockPick()
  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)
  local vehicle   = GetClosestVehicle(coords.x,  coords.y,  coords.z,  3.0,  0,  71)

  if DoesEntityExist(vehicle) then
    local playerPed = GetPlayerPed(-1)
    local coords    = GetEntityCoords(playerPed)

    if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
      local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  3.0,  0,  71)

      if DoesEntityExist(vehicle) then
        Citizen.CreateThread(function()

          ESX.UI.Menu.CloseAll()
          TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)

          Wait(10000) -- 10 seconds, change in milliseconds if wanted

          ESX.TriggerServerCallback('esx_useitem:hasSucceeded', function(succeeded)
            if succeeded then

              ClearPedTasksImmediately(playerPed)
              SetVehicleDoorsLocked(vehicle, 1)
              SetVehicleDoorsLockedForAllPlayers(vehicle, false)
              ESX.ShowNotification('Fordon ~g~upplåst') -- Vehicle Unlocked
            else
              ClearPedTasksImmediately(playerPed)
              ESX.ShowNotification('Ditt dyrkset gick ~r~sönder') -- Lockpick broke
            end
          end)
        end)
      end
    end
  end
end

-----------------------------------------------------------------------------------------------
--------------------------------------- Mask --------------------------------------------------
-----------------------------------------------------------------------------------------------

RegisterNetEvent('esx_useitem:mask')
AddEventHandler('esx_useitem:mask', function()

  if mask == false then
    SetPedComponentVariation(GetPlayerPed(-1), 1, 38, 0, 2)
    mask = true
  else
    SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 0, 2)
    mask = false
  end
end)


-----------------------------------------------------------------------------------------------
------------------------------------------- Joint ----------------------------------------
-----------------------------------------------------------------------------------------------

RegisterNetEvent('esx_useitem:startJoint')
AddEventHandler('esx_useitem:startJoint', function(source)
  JointAnimation()
end)

function JointAnimation()
  local playerPed = GetPlayerPed(-1)

  Citizen.CreateThread(function()
    RequestAnimSet("MOVE_M@DRUNK@SLIGHTLYDRUNK")
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_DRUG_DEALER", 0, 1)
          Citizen.Wait(5000)
          DoScreenFadeOut(1000)
          Citizen.Wait(1000)
          ClearPedTasksImmediately(playerPed)
          SetTimecycleModifier("spectator5")
          SetPedMotionBlur(playerPed, true)
          SetPedMovementClipset(playerPed, "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
          SetPedIsDrunk(playerPed, true)
          DoScreenFadeIn(1000)
        Citizen.Wait(100000)
          DoScreenFadeOut(1000)
          Citizen.Wait(1000)
          DoScreenFadeIn(1000)
          ClearTimecycleModifier()
          ResetScenarioTypesEnabled()
          ResetPedMovementClipset(playerPed, 0)
          SetPedIsDrunk(playerPed, false)
          SetPedMotionBlur(playerPed, false)
  end)
end


-----------------------------------------------------------------------------------------------
------------------------------------------- Defibirlateur ----------------------------------------
-----------------------------------------------------------------------------------------------
RegisterNetEvent('esx_useitem:defibri')
AddEventHandler('esx_useitem:defibri', function(source)
  defibri()
end)

function defibri()
  local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer == -1 or closestDistance > 10.0 then
            ESX.ShowNotification("personne à 10m")
        else
            local closestPlayerPed = GetPlayerPed(closestPlayer)
            local health = GetEntityHealth(closestPlayerPed)
            if health == 0 then
                local playerPed = GetPlayerPed(-1)
                Citizen.CreateThread(function()
                    ESX.ShowNotification("aucun pouls, je pose le défibrillateur")
                    TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
                    Wait(5000)
                    ESX.ShowNotification("attention, je vais choquer")
                    Wait(3000)
                    ClearPedTasks(playerPed)
                    if GetEntityHealth(closestPlayerPed) == 0 then
                        TriggerServerEvent('esx_ambulancejob:revive', GetPlayerServerId(closestPlayer))
                        ESX.ShowNotification("1, 2, 3 CHOC")
                    else
                        ESX.ShowNotification("erreur inconnu")
                    end
                end)
            else
                ESX.ShowNotification("pas inconcient")
            end
        end
    end

-----------------------------------------------------------------------------------------------
------------------------------------------- Bandages ----------------------------------------
-----------------------------------------------------------------------------------------------
RegisterNetEvent('esx_useitem:bandage')
AddEventHandler('esx_useitem:bandage', function(source)
  bandage()
end)

function bandage()
  local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer == -1 or closestDistance > 5.0 then
            ESX.ShowNotification("Pas de joueur proche")
        else
            local playerPed = GetPlayerPed(-1)
            Citizen.CreateThread(function()
                ESX.ShowNotification("soin en cours ...")
                TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
                Wait(10000)
                ClearPedTasks(playerPed)
                TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
                ESX.ShowNotification("personne soignée")
            end)
        end
    end

-----------------------------------------------------------------------------------------------
------------------------------------------- KIt de survie ----------------------------------------
-----------------------------------------------------------------------------------------------
RegisterNetEvent('esx_useitem:kitsurvie')
AddEventHandler('esx_useitem:kitsurvie', function(source)
  kitsurvie()
end)

function kitsurvie()
            local PlayerPed = GetPlayerPed(-1)
            local localPlayerId = PlayerId()
            local serverId = GetPlayerServerId(localPlayerId)
            local health = GetEntityHealth(players)
            if health == 0 then
                Citizen.CreateThread(function()
                    ESX.ShowNotification("vous posez le défibrillateur")
                    Wait(5000)
                    ESX.ShowNotification("attention, vous choquez")
                    Wait(3000)
                    ClearPedTasks(playerPed)
                    if GetEntityHealth(PlayerPed) == 0 then
                        TriggerServerEvent('esx_ambulancejob:revive', serverId)
                        ESX.ShowNotification("1, 2, 3 CHOC")
                    else
                        ESX.ShowNotification("erreur inconnu")
                    end
                end)
            else
                ESX.ShowNotification("pas inconcient")
            end
        end

-----------------------------------------------------------------------------------------------
---------------------------------- REMOVE OBJ -------------------------------------------------
-----------------------------------------------------------------------------------------------
AddEventHandler('esx_useitem:hasEnteredEntityZone', function(entity)

  local playerPed = GetPlayerPed(-1)

  CurrentAction     = 'remove_entity'
  CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour enlever l\'objet'
  CurrentActionData = {entity = entity}
end)

AddEventHandler('esx_useitem:hasExitedEntityZone', function(entity)

  if CurrentAction == 'remove_entity' then
    CurrentAction = nil
  end
end)

Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0) 

		local playerPed = GetPlayerPed(-1)
		local coords    = GetEntityCoords(playerPed)

		local entity, distance = ESX.Game.GetClosestObject({
      'stt_prop_stunt_soccer_lball',
      'prop_yoga_mat_02',
      'prop_champset',
      'prop_beach_fire',
      'prop_bong_01'
		})

		if distance ~= -1 and distance <= 3.0 then

 			if LastEntity ~= entity then
				TriggerEvent('esx_useitem:hasEnteredEntityZone', entity)
				LastEntity = entity
			end
		else

			if LastEntity ~= nil then
				TriggerEvent('esx_useitem:hasExitedEntityZone', LastEntity)
				LastEntity = nil
			end
		end
	end
end)



-----------------------------------------------------------------------------------------------
---------------------------------------- KEY CONTROLS ------------------------------------------
------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
  while true do
      Citizen.Wait(0)

      if CurrentAction ~= nil then

        SetTextComponentFormat('STRING')
        AddTextComponentString(CurrentActionMsg)
        DisplayHelpTextFromStringLabel(0, 0, 1, -1)
      if IsControlJustReleased(0, 38) then

        if CurrentAction == 'remove_entity' then
          DeleteEntity(CurrentActionData.entity)
        end

        if CurrentAction == 'open_bin' then
          if GetGameTimer() - lastTime >= 15000 then
            OpenBin()
            lastTime = GetGameTimer()
          end
        end
        CurrentAction = nil
      end
    end
  end
end)









--[[
----------------------------------------------------------------------------
--------------------------------  OPEN BIN  --------------------------------
----------------------------------------------------------------------------

AddEventHandler('esx_useitem:trashcanEnteredEntityZone', function(entity)

  local playerPed = GetPlayerPed(-1)

  CurrentAction     = 'open_bin'
  CurrentActionMsg  = 'Appuyez sur ~INPUT_TALK~ pour faire les poubelles'
  CurrentActionData = {entity = entity}
end)

AddEventHandler('esx_useitem:trashcanhasExitedEntityZone', function(entity)

  if CurrentAction == 'open_bin' then
    CurrentAction = nil
  end
end)

Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		local playerPed = GetPlayerPed(-1)
		local coords    = GetEntityCoords(playerPed)

		local entity, distance = ESX.Game.GetClosestObject({
      'prop_recyclebin_03_a',
      'zprop_bin_01a_old',
      'prop_bin_01a',
      'prop_bin_03a',
      'prop_bin_05a',
      'prop_bin_06a',
      'prop_bin_07a',
      'prop_bin_07d',
      'prop_cs_bin_02'
		})

		if distance ~= -1 and distance <= 2.0 then

 			if entity then
				TriggerEvent('esx_useitem:trashcanEnteredEntityZone', entity)
				LastEntity = entity
			end
		else

			if entity ~= nil then
				TriggerEvent('esx_useitem:trashcanhasExitedEntityZone', entity)
				entity = nil
			end
		end
	end
end)

function OpenBin()

  local playerPed = GetPlayerPed(-1)

	Citizen.CreateThread(function()

    local playerPed  = GetPlayerPed(-1)

    TaskPlayAnim(playerPed, "amb@prop_human_bum_bin@enter", "enter", 3.5, -8, -1, 2, 0, 0, 0, 0)
    TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
    Citizen.CreateThread(function()
    Citizen.Wait(10000)
    TriggerServerEvent('esx_useitem:bin')
    ClearPedTasksImmediately(playerPed)
    end)
  end)
end

------------------------------------------------------------------------------------
------------------------------------ Use Brolly ------------------------------------
------------------------------------------------------------------------------------

RegisterNetEvent('esx_useitem:brolly')
AddEventHandler('esx_useitem:brolly', function()

  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

	Citizen.CreateThread(function()

    local playerPed = GetPlayerPed(-1)
    local coords    = GetEntityCoords(playerPed)
    local boneIndex = GetPedBoneIndex(playerPed, 57005)

      RequestAnimDict('amb@code_human_wander_drinking@beer@male@base')

    while not HasAnimDictLoaded('amb@code_human_wander_drinking@beer@male@base') do
      Citizen.Wait(0)
    end

    ESX.Game.SpawnObject('p_amb_brolly_01', {
      x = coords.x,
      y = coords.y,
      z = coords.z + 2
    }, function(object)

    Citizen.CreateThread(function()

      AttachEntityToEntity(object, playerPed, boneIndex, 0.10, 0, -0.001, 80.0, 150.0, 200.0, true, true, false, true, 1, true)
      TaskPlayAnim(playerPed, "amb@code_human_wander_drinking@beer@male@base", "static", 3.5, -8, -1, 49, 0, 0, 0, 0)

     end)
    end)
  end)
end)


-----------------------------------------------------------------------------------------------
--------------------------------------------- KIT PIC -----------------------------------------
-----------------------------------------------------------------------------------------------

RegisterNetEvent('esx_useitem:kitpic')
AddEventHandler('esx_useitem:kitpic', function()

    local playerPed = GetPlayerPed(-1)
    local coords    = GetEntityCoords(playerPed)

  ESX.Game.SpawnObject('prop_yoga_mat_02',  {
      x = coords.x,
      y = coords.y,
      z = coords.z -1
    }, function(object)
  end)
  ESX.Game.SpawnObject('prop_yoga_mat_02',  {
    x = coords.x ,
    y = coords.y -0.9,
    z = coords.z -1
  }, function(object)
  end)
  ESX.Game.SpawnObject('prop_yoga_mat_02',  {
    x = coords.x ,
    y = coords.y +0.9,
    z = coords.z -1
  }, function(object)
  end)
  ESX.Game.SpawnObject('prop_champset',  {
    x = coords.x ,
    y = coords.y ,
    z = coords.z -1
  }, function(object)
  end)
  ESX.Game.SpawnObject('prop_beach_fire',  {
    x = coords.x +1.3,
    y = coords.y ,
    z = coords.z -1.6
  }, function(object)
  end)
end)

-----------------------------------------------------------------------------------------------
-------------------------------------------- BALL XXL -----------------------------------------
-----------------------------------------------------------------------------------------------

RegisterNetEvent('esx_useitem:ball')
  AddEventHandler('esx_useitem:ball', function()

    local playerPed = GetPlayerPed(-1)
    local coords    = GetEntityCoords(playerPed)

    ESX.Game.SpawnObject('stt_prop_stunt_soccer_lball',  {
      x = coords.x +1.5,
      y = coords.y +1.5,
      z = coords.z -1
    }, function(object)
  end)
end)

--]]