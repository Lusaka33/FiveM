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

-- Varibles
ESX                           = nil
local GUI                     = {}
GUI.Time                      = 0
local OwnedAppartement       = {}
local Blips                   = {}
local CurrentProperty         = nil
local CurrentPropertyOwner    = nil
local LastProperty            = nil
local LastPart                = nil
local HasAlreadyEnteredMarker = false
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local FirstSpawn              = true
local HasChest                = false
local Propertykeys            = {}

function DrawSub(text, time)
  ClearPrints()
  SetTextEntry_2('STRING')
  AddTextComponentString(text)
  DrawSubtitleTimed(time, 1)
end

-- Blips
function CreateBlips()

  for i=1, #Config.Appartement, 1 do

    local property = Config.Appartement[i]

    if property.entering ~= nil then

      Blips[property.name] = AddBlipForCoord(property.entering.x, property.entering.y, property.entering.z)

      SetBlipSprite (Blips[property.name], 369)
      SetBlipDisplay(Blips[property.name], 4)
      SetBlipScale  (Blips[property.name], 1.0)
      SetBlipAsShortRange(Blips[property.name], true)

      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(_U('free_prop'))
      EndTextCommandSetBlipName(Blips[property.name])
    end
  end
end

function GetAppartement()
  return Config.Appartement
end

function GetProperty(name)

  for i=1, #Config.Appartement, 1 do
    if Config.Appartement[i].name == name then
      return Config.Appartement[i]
    end
  end
end

function GetGateway(property)

  for i=1, #Config.Appartement, 1 do

    local property2 = Config.Appartement[i]

    if property2.isGateway and property2.name == property.gateway then
      return property2
    end
  end
end

function GetGatewayAppartement(property)

  local Appartement = {}

  for i=1, #Config.Appartement, 1 do
    if Config.Appartement[i].gateway == property.name then
      table.insert(Appartement, Config.Appartement[i])
    end
  end

  return Appartement
end

function EnterProperty(name, owner)

  local property       = GetProperty(name)
  local playerPed      = GetPlayerPed(-1)
  CurrentProperty      = property
  CurrentPropertyOwner = owner

  for i=1, #Config.Appartement, 1 do
    if Config.Appartement[i].name ~= name then
      Config.Appartement[i].disabled = true
    end
  end

  TriggerServerEvent('esx_appartement:saveLastProperty', name)

  Citizen.CreateThread(function()

    DoScreenFadeOut(800)

    while not IsScreenFadedOut() do
      Citizen.Wait(0)
    end

    for i=1, #property.ipls, 1 do

      RequestIpl(property.ipls[i])

      while not IsIplActive(property.ipls[i]) do
        Citizen.Wait(0)
      end
    end

    SetEntityCoords(playerPed, property.inside.x,  property.inside.y,  property.inside.z)

    DoScreenFadeIn(800)

    DrawSub(property.label, 5000)
  end)
end

function ExitProperty(name)

  local property  = GetProperty(name)
  local playerPed = GetPlayerPed(-1)
  local outside   = nil
  CurrentProperty = nil

  if property.isSingle then
    outside = property.outside
  else
    outside = GetGateway(property).outside
  end

  TriggerServerEvent('esx_appartement:deleteLastProperty')

  Citizen.CreateThread(function()

    DoScreenFadeOut(800)

    while not IsScreenFadedOut() do
      Citizen.Wait(0)
    end

    SetEntityCoords(playerPed, outside.x,  outside.y,  outside.z)

    for i=1, #property.ipls, 1 do
      RemoveIpl(property.ipls[i])
    end

    for i=1, #Config.Appartement, 1 do
      Config.Appartement[i].disabled = false
    end

    DoScreenFadeIn(800)
  end)
end

function SetPropertyOwned(name, owned)

  local property     = GetProperty(name)
  local entering     = nil
  local enteringName = nil

  if property.isSingle then
    entering     = property.entering
    enteringName = property.name
  else
    local gateway = GetGateway(property)
    entering      = gateway.entering
    enteringName  = gateway.name
  end

  if owned then

    OwnedAppartement[name] = true

    RemoveBlip(Blips[enteringName])

    Blips[enteringName] = AddBlipForCoord(entering.x,  entering.y,  entering.z)

    SetBlipSprite(Blips[enteringName], 357)
    SetBlipAsShortRange(Blips[enteringName], true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_U('property'))
    EndTextCommandSetBlipName(Blips[enteringName])
  else

    Owned[Appartementname] = nil

    local found = false

    for k,v in pairs(OwnedAppartement) do

      local _property = GetProperty(k)
      local _gateway  = GetGateway(_property)

      if _gateway ~= nil then

        if _gateway.name == enteringName then
          found = true
          break
        end
      end
    end

    if not found then

      RemoveBlip(Blips[enteringName])

      Blips[enteringName] = AddBlipForCoord(entering.x,  entering.y,  entering.z)

      SetBlipSprite(Blips[enteringName], 369)
      SetBlipAsShortRange(Blips[enteringName], true)

      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(_U('free_prop'))
      EndTextCommandSetBlipName(Blips[enteringName])
    end
  end
end

function PropertyIsOwned(property)
  return OwnedAppartement[property.name] == true
end

function OpenPropertyMenu(property)

  local elements = {}

  if PropertyIsOwned(property) then

    table.insert(elements, {label = _U('enter'), value = 'enter'})

    if PlayerData.job.name == 'Police' and PlayerData.job.name == 'Sheriff' and PlayerData.job.grade_name == 'boss' then
      table.insert(elements, {label = _U("break_door"), value = "breakdoor"})
    end

    if not Config.EnablePlayerManagement then
      table.insert(elements, {label = _U('leave'), value = 'leave'})
    end
  else

    if not Config.EnablePlayerManagement then
      table.insert(elements, {label = _U('buy'), value = 'buy'})
      table.insert(elements, {label = _U('rent'), value = 'rent'})
    end

    table.insert(elements, {label = _U('visit'), value = 'visit'})
  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'property',
    {
    title    = property.label,
    align    = 'top-left',
    elements = elements,
    },
    function(data2, menu)

      menu.close()

      if data2.current.value == 'enter' then
        TriggerEvent('instance:create', 'property', {property = property.name, owner = ESX.GetPlayerData().identifier})
      end

      if data2.current.value == 'breakdoor' then
        TriggerEvent('instance:create', 'property', {property = property.name, owner = ESX.GetPlayerData().identifier})
      end

      if data2.current.value == 'leave' then
        TriggerServerEvent('esx_appartement:removeOwnedProperty', property.name)
      end

      if data2.current.value == 'buy' then
        TriggerServerEvent('esx_appartement:buyProperty', property.name)
      end

      if data2.current.value == 'rent' then
        TriggerServerEvent('esx_appartement:rentProperty', property.name)
      end

      if data2.current.value == 'visit' then
        TriggerEvent('instance:create', 'property', {property = property.name, owner = ESX.GetPlayerData().identifier})
      end
    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'property_menu'
      CurrentActionMsg  = _U('press_to_menu')
      CurrentActionData = {property = property}
    end
  )
end

function OpenGatewayMenu(property)

  if Config.EnablePlayerManagement then
    OpenGatewayOwnedAppartementMenu(gatewayAppartement)
  else

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'gateway',
      {
        title    = property.name,
        align    = 'top-left',
        elements = {
          {label = _U('owned_appartement'),    value = 'owned_appartement'},
          {label = _U('available_appartement'), value = 'available_appartement'},
        }
      },
      function(data, menu)

        if data.current.value == 'owned_appartement' then
          OpenGatewayOwnedAppartementMenu(property)
        end

        if data.current.value == 'available_appartement' then
          OpenGatewayAvailableAppartementMenu(property)
        end
      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'gateway_menu'
        CurrentActionMsg  = _U('press_to_menu')
        CurrentActionData = {property = property}
      end
    )
  end
end

function OpenGatewayOwnedAppartementMenu(property)

  local gatewayAppartement = GetGatewayAppartement(property)
  local elements          = {}

  for i=1, #gatewayAppartement, 1 do

    if PropertyIsOwned(gatewayAppartement[i]) then
      table.insert(elements, {
        label = gatewayAppartement[i].label,
        value = gatewayAppartement[i].name
      })
    end
  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'gateway_owned_appartement',
    {
      title    = property.name .. ' - ' .. _U('owned_appartement'),
      align    = 'top-left',
      elements = elements,
    },
    function(data, menu)

      menu.close()

      local elements = {
        {label = _U('enter'), value = 'enter'}
      }

      if not Config.EnablePlayerManagement then
        table.insert(elements, {label = _U('leave'), value = 'leave'})
      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'gateway_owned_appartement_actions',
        {
          title    = data.current.label,
          align    = 'top-left',
          elements = elements,
        },
        function(data2, menu)

          menu.close()

          if data2.current.value == 'enter' then
            TriggerEvent('instance:create', 'property', {property = data.current.value, owner = ESX.GetPlayerData().identifier})
          end

          if data2.current.value == 'leave' then
            TriggerServerEvent('esx_appartement:removeOwnedProperty', property.name)
          end
        end,
        function(data, menu)
          menu.close()
        end
      )
    end,
    function(data, menu)
      menu.close()
    end
  )
end

function OpenGatewayAvailableAppartementMenu(property)

  local gatewayAppartement = GetGatewayAppartement(property)
  local elements          = {}

  for i=1, #gatewayAppartement, 1 do

    if not PropertyIsOwned(gatewayAppartement[i]) then
      table.insert(elements, {
        label = gatewayAppartement[i].label .. ' $' .. gatewayAppartement[i].price,
        value = gatewayAppartement[i].name,
        price = gatewayAppartement[i].price
      })
    end
  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'gateway_available_appartement',
    {
      title    = property.name.. ' - ' .. _U('available_appartement'),
      align    = 'top-left',
      elements = elements,
    },
    function(data, menu)

      menu.close()

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'gateway_available_appartement_actions',
        {
          title    = property.name,
          align    = 'top-left',
          elements = {
            {label = _U('buy'),   value = 'buy'},
            {label = _U('rent'),  value = 'rent'},
            {label = _U('visit'), value = 'visit'},
          },
        },
        function(data2, menu)
          menu.close()

          if data2.current.value == 'buy' then
            TriggerServerEvent('esx_appartement:buyProperty', data.current.value)
          end

          if data2.current.value == 'rent' then
            TriggerServerEvent('esx_appartement:rentProperty', data.current.value)
          end

          if data2.current.value == 'visit' then
            TriggerEvent('instance:create', 'property', {property = data.current.value, owner = ESX.GetPlayerData().identifier})
          end
        end,
        function(data, menu)
          menu.close()
        end
      )
    end,
    function(data, menu)
      menu.close()
    end
  )
end

function OpenRoomMenu(property, owner)

  local entering = nil
  local elements = {}

  if property.isSingle then
    entering = property.entering
  else
    entering = GetGateway(property).entering
  end

  table.insert(elements, {label = _U('invite_player'),  value = 'invite_player'})

  if CurrentPropertyOwner == owner then
    table.insert(elements, {label = _U('player_clothes'), value = 'player_dressing'})
    table.insert(elements, {label = _U('keys_config'),    value = 'menuKeys'})
  end

  table.insert(elements, {label = _U('dring_on'),       value = 'enableRing'})
  table.insert(elements, {label = _U('remove_object'),  value = 'room_inventory'})
  table.insert(elements, {label = _U('deposit_object'), value = 'player_inventory'})

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'room',
    {
      title    = property.label,
      align    = 'top-left',
      elements = elements,
    },
    function(data, menu)

      if data.current.value == 'invite_player' then

        local playersInArea = ESX.Game.GetPlayersInArea(entering, 10.0)
        local elements      = {}

        for i=1, #playersInArea, 1 do
          if playersInArea[i] ~= PlayerId() then
            table.insert(elements, {label = GetPlayerName(playersInArea[i]), value = playersInArea[i]})
          end
        end

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'room_invite',
          {
            title    = property.label .. ' - ' .. _U('invite'),
            align    = 'top-left',
            elements = elements,
          },
          function(data, menu)
            TriggerEvent('instance:invite', 'property', GetPlayerServerId(data.current.value), {property = property.name, owner = owner})
            ESX.ShowNotification(_U('you_invited', GetPlayerName(data.current.value)))
          end,
          function(data, menu)
            menu.close()
          end
        )
      end

      if data.current.value == 'player_dressing' then

        ESX.TriggerServerCallback('esx_appartement:getPlayerDressing', function(dressing)

          local elements = {}

          for i=1, #dressing, 1 do
            table.insert(elements, {label = dressing[i].label, value = dressing[i].skin})
          end

          ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'player_dressing',
            {
              title    = property.label .. ' - ' .. _U('player_clothes'),
              align    = 'top-left',
              elements = elements,
            },
            function(data, menu)

              TriggerEvent('skinchanger:getSkin', function(skin)

                TriggerEvent('skinchanger:loadClothes', skin, data.current.value)
                TriggerEvent('esx_skin:setLastSkin', skin)

                TriggerEvent('skinchanger:getSkin', function(skin)
                  TriggerServerEvent('esx_skin:save', skin)
                end)
              end)
            end,
            function(data, menu)
              menu.close()
            end
          )
        end)
      end

      if data.current.value == 'menuKeys' then
        menuKeys(property)
      end

      if data.current.value == 'enableRing' then
        enableRing(property)
      end

      if data.current.value == 'room_inventory' then
        OpenRoomInventoryMenu(property, owner)
      end

      if data.current.value == 'player_inventory' then
        OpenPlayerInventoryMenu(property, owner)
      end
    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'room_menu'
      CurrentActionMsg  = _U('press_to_menu')
      CurrentActionData = {property = property, owner = owner}
    end
  )
end

function OpenRoomInventoryMenu(property, owner)

  ESX.TriggerServerCallback('esx_appartement:getPropertyInventory', function(inventory)

    local elements = {}

    table.insert(elements, {label = _U('dirty_money') .. inventory.blackMoney, type = 'item_account', value = 'black_money'})

    for i=1, #inventory.items, 1 do

      local item = inventory.items[i]

      if item.count > 0 then
        table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
      end
    end

    for i=1, #inventory.weapons, 1 do
      local weapon = inventory.weapons[i]
      table.insert(elements, {label = ESX.GetWeaponLabel(weapon.name) .. ' [' .. weapon.ammo .. ']', type = 'item_weapon', value = weapon.name, ammo = weapon.ammo})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'room_inventory',
      {
        title    = property.label .. ' - ' .. _U('inventory'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        if data.current.type == 'item_weapon' then

          menu.close()

          TriggerServerEvent('esx_appartement:getItem', owner, data.current.type, data.current.value, data.current.ammo)

          ESX.SetTimeout(300, function()
            OpenRoomInventoryMenu(property, owner)
          end)
        else

          ESX.UI.Menu.Open(
            'dialog', GetCurrentResourceName(), 'get_item_count',
            {
              title = _U('amount'),
            },
            function(data2, menu)

              local quantity = tonumber(data2.value)

              if quantity == nil then
                ESX.ShowNotification(_U('amount_invalid'))
              else

                menu.close()

                TriggerServerEvent('esx_appartement:getItem', owner, data.current.type, data.current.value, quantity)

                ESX.SetTimeout(300, function()
                  OpenRoomInventoryMenu(property, owner)
                end)
              end
            end,
            function(data2,menu)
              menu.close()
            end
          )
        end
      end,
      function(data, menu)
        menu.close()
      end
    )
  end, owner)
end

function OpenPlayerInventoryMenu(property, owner)

  ESX.TriggerServerCallback('esx_appartement:getPlayerInventory', function(inventory)

    local elements = {}

    table.insert(elements, {label = _U('dirty_money') .. inventory.blackMoney, type = 'item_account', value = 'black_money'})

    for i=1, #inventory.items, 1 do

      local item = inventory.items[i]

      if item.count > 0 then
        table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
      end
    end

    local playerPed  = GetPlayerPed(-1)
    local weaponList = ESX.GetWeaponList()

    for i=1, #weaponList, 1 do

      local weaponHash = GetHashKey(weaponList[i].name)

      if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
        local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
        table.insert(elements, {label = weaponList[i].label .. ' [' .. ammo .. ']', type = 'item_weapon', value = weaponList[i].name, ammo = ammo})
      end
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'player_inventory',
      {
        title    = property.label .. ' - ' .. _U('inventory'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        if data.current.type == 'item_weapon' then

          menu.close()

          TriggerServerEvent('esx_appartement:putItem', owner, data.current.type, data.current.value, data.current.ammo)

          ESX.SetTimeout(300, function()
            OpenPlayerInventoryMenu(property, owner)
          end)
        else

          ESX.UI.Menu.Open(
            'dialog', GetCurrentResourceName(), 'put_item_count',
            {
              title = _U('amount'),
            },
            function(data2, menu)

              menu.close()

              TriggerServerEvent('esx_appartement:putItem', owner, data.current.type, data.current.value, tonumber(data2.value))

              ESX.SetTimeout(300, function()
                OpenPlayerInventoryMenu(property, owner)
              end)
            end,
            function(data2,menu)
              menu.close()
            end
          )
        end
      end,
      function(data, menu)
        menu.close()
      end
    )
  end)
end

-- Instance
AddEventHandler('instance:loaded', function()

  TriggerEvent('instance:registerType', 'property',
    function(instance)
      EnterProperty(instance.data.property, instance.data.owner)
    end,
    function(instance)
      ExitProperty(instance.data.property)
    end
  )
end)

RegisterNetEvent('instance:onCreate')
AddEventHandler('instance:onCreate', function(instance)

  if instance.type == 'property' then
    TriggerEvent('instance:enter', instance)
  end
end)

RegisterNetEvent('instance:onEnter')
AddEventHandler('instance:onEnter', function(instance)

  if instance.type == 'property' then

    local property = GetProperty(instance.data.property)
    local isHost   = GetPlayerFromServerId(instance.host) == PlayerId()
    local isOwned  = false

    if PropertyIsOwned(property) == true then
      isOwned = true
    end

    if(isOwned or not isHost) then
      HasChest = true
    else
      HasChest = false
    end
  end
end)

RegisterNetEvent('instance:onPlayerLeft')
AddEventHandler('instance:onPlayerLeft', function(instance, player)
  if player == instance.host then
    TriggerEvent('instance:leave')
  end
end)
--
function menuKeys(property)
  TriggerServerEvent('esx_appartement:createKey', function (menuKeys)

    local elements = {}

    if PropertyIsOwned(property) then

      if PropertyIsOwned(property) >= 3 then

        table.insert(elements, {label = 'Vous : level 3 (max)', value = 'privetimuseless'})
        table.insert(elements, {label = 'Ajouter des clés', value = 'addKeys'})

        for k, item in pairs(PropertyIsOwned(property)) do
          if item.level < 3 then
            table.insert(elements, {label = item.pseudo .. ' : ' .. item.level, value = 'delKey'})
          end
        end
      end
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'appart_key',
      {
      title    = 'Clés',
      elements = elements
      },
      function(data, menu)
        menu.close()

        MenuCallFunction(data.current.value, data.current.dt)
      end,
      function(data, menu)

        menu.close()
      end
    )
  end)
end

function addKeys(property)
  DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "ID du joueur (ex: 8)", "", "", "", 120)

  while UpdateOnscreenKeyboard() == 0 do
    DisableAllControlActions(0)
    Wait(0)
  end

  if (GetOnscreenKeyboardResult()) then

    local txt = GetOnscreenKeyboardResult()

    if (string.len(txt) > 0) then
      DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "Level de la clé :  1 => juste rentrer et sortir  |  2 => accès au coffre", "", "", "", 120)

      while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0);
      end

      if (GetOnscreenKeyboardResult()) then

        local txt2 = GetOnscreenKeyboardResult()

        TriggerServerEvent('esx_appartement:createKey', property, tonumber(txt) or -5, tonumber(txt2) or 0)
        CloseMenu()
      end
    end
  end
end

function delKey(z)
  TriggerServerEvent("esx_appartement:delkey", z.a, z.b)
  CloseMenu()
end

function enableRing(property)

  TriggerServerEvent('esx_appartement:setRing', property, true)
  Citizen.CreateThread(function()
    Wait(10000) -- attendre 10s
    TriggerServerEvent('esx_appartement:setRing', property, false)
  end)
end

function privetimuseless()
end

--[[ TP
AddEventHandler('esx_appartement:teleportMarkers', function(position)
  SetEntityCoords(GetPlayerPed(-1), position.x, position.y, position.z)
end)

function TeleportFadeEffect(entity, coords)

  Citizen.CreateThread(function()

    DoScreenFadeOut(800)

    while not IsScreenFadedOut() do
      Citizen.Wait(0)
    end

    ESX.Game.Teleport(GetPlayerPed(-1), Config.Appartement, function()
        DoScreenFadeIn(800)
      end)
    end)
end]]

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerLoaded = true
end)

AddEventHandler('esx_appartement:getAppartement', function(cb)
  cb(GetAppartement())
end)

AddEventHandler('esx_appartement:getProperty', function(name, cb)
  cb(GetProperty(name))
end)

AddEventHandler('esx_appartement:getGateway', function(property, cb)
  cb(GetGateway(property))
end)

RegisterNetEvent('esx_appartement:setPropertyOwned')
AddEventHandler('esx_appartement:setPropertyOwned', function(name, owned)
  SetPropertyOwned(name, owned)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)

  ESX.TriggerServerCallback('esx_appartement:getOwnedAppartement', function(ownedAppartement)
    for i=1, #ownedAppartement, 1 do
      SetPropertyOwned(ownedAppartement[i], true)
    end
  end)
end)

AddEventHandler('esx_appartement:hasEnteredMarker', function(name, part)

  local property = GetProperty(name)

  if part == 'entering' then

    if property.isSingle then
      CurrentAction     = 'property_menu'
      CurrentActionMsg  = _U('press_to_menu')
      CurrentActionData = {property = property}
    else
      CurrentAction     = 'gateway_menu'
      CurrentActionMsg  = _U('press_to_menu')
      CurrentActionData = {property = property}
    end
  end

  if part == 'exit' then
    CurrentAction     = 'room_exit'
    CurrentActionMsg  = _U('press_to_exit')
    CurrentActionData = {propertyName = name}
  end

  if part == 'roomMenu' then
    CurrentAction     = 'room_menu'
    CurrentActionMsg  = _U('press_to_menu')
    CurrentActionData = {property = property, owner = CurrentPropertyOwner}
  end
end)

AddEventHandler('esx_appartement:hasExitedMarker', function(name, part)
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)

-- Init
Citizen.CreateThread(function()

  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end

  ESX.TriggerServerCallback('esx_appartement:getAppartement', function(Appartement)
    Config.Appartement = Appartement
    CreateBlips()
  end)
end)

-- Display markers
Citizen.CreateThread(function()
  while true do
    Wait(0)

    local coords = GetEntityCoords(GetPlayerPed(-1))

    for i=1, #Config.Appartement, 1 do

      local property = Config.Appartement[i]
      local isHost   = false

      if(property.entering ~= nil and not property.disabled and GetDistanceBetweenCoords(coords, property.entering.x, property.entering.y, property.entering.z, true) < Config.DrawDistance) then
        DrawMarker(Config.MarkerType, property.entering.x, property.entering.y, property.entering.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
      end

      if(property.exit ~= nil and not property.disabled and GetDistanceBetweenCoords(coords, property.exit.x, property.exit.y, property.exit.z, true) < Config.DrawDistance) then
        DrawMarker(Config.MarkerType, property.exit.x, property.exit.y, property.exit.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
      end

      if(property.roomMenu ~= nil and HasChest and not property.disabled and GetDistanceBetweenCoords(coords, property.roomMenu.x, property.roomMenu.y, property.roomMenu.z, true) < Config.DrawDistance) then
        DrawMarker(Config.MarkerType, property.roomMenu.x, property.roomMenu.y, property.roomMenu.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.RoomMenuMarkerColor.r, Config.RoomMenuMarkerColor.g, Config.RoomMenuMarkerColor.b, 100, false, true, 2, false, false, false, false)
      end
    end
  end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
  while true do
    Wait(0)

    local coords          = GetEntityCoords(GetPlayerPed(-1))
    local isInMarker      = false
    local currentProperty = nil
    local currentPart     = nil

    for i=1, #Config.Appartement, 1 do

      local property = Config.Appartement[i]

      if (property.entering ~= nil and not property.disabled and GetDistanceBetweenCoords(coords, property.entering.x, property.entering.y, property.entering.z, true) < Config.MarkerSize.x) then
        isInMarker      = true
        currentProperty = property.name
        currentPart     = 'entering'
      end

      if (property.exit ~= nil and not property.disabled and GetDistanceBetweenCoords(coords, property.exit.x, property.exit.y, property.exit.z, true) < Config.MarkerSize.x) then
        isInMarker      = true
        currentProperty = property.name
        currentPart     = 'exit'
      end

      if (property.inside ~= nil and not property.disabled and GetDistanceBetweenCoords(coords, property.inside.x, property.inside.y, property.inside.z, true) < Config.MarkerSize.x) then
        isInMarker      = true
        currentProperty = property.name
        currentPart     = 'inside'
      end

      if (property.outside ~= nil and not property.disabled and GetDistanceBetweenCoords(coords, property.outside.x, property.outside.y, property.outside.z, true) < Config.MarkerSize.x) then
        isInMarker      = true
        currentProperty = property.name
        currentPart     = 'outside'
      end

      if (property.roomMenu ~= nil and HasChest and not property.disabled and GetDistanceBetweenCoords(coords, property.roomMenu.x, property.roomMenu.y, property.roomMenu.z, true) < Config.MarkerSize.x) then
        isInMarker      = true
        currentProperty = property.name
        currentPart     = 'roomMenu'
      end
    end

    if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastProperty ~= currentProperty or LastPart ~= currentPart)) then

      HasAlreadyEnteredMarker = true
      LastProperty            = currentProperty
      LastPart                = currentPart

      TriggerEvent('esx_appartement:hasEnteredMarker', currentProperty, currentPart)
    end

    if not isInMarker and HasAlreadyEnteredMarker then

      HasAlreadyEnteredMarker = false

      TriggerEvent('esx_appartement:hasExitedMarker', LastProperty, LastPart)
    end
  end
end)

-- Key controls
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)

    if CurrentAction ~= nil then

      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)

      if IsControlPressed(0, 38) and (GetGameTimer() - GUI.Time) > 300 then

        if CurrentAction == 'property_menu' then
          OpenPropertyMenu(CurrentActionData.property)
        end

        if CurrentAction == 'gateway_menu' then

          if Config.EnablePlayerManagement then
            OpenGatewayOwnedAppartementMenu(CurrentActionData.property)
          else
            OpenGatewayMenu(CurrentActionData.property)
          end
        end

        if CurrentAction == 'room_menu' then
          OpenRoomMenu(CurrentActionData.property, CurrentActionData.owner)
        end

        if CurrentAction == 'room_exit' then
          TriggerEvent('instance:leave')
        end

        CurrentAction = nil
        GUI.Time      = GetGameTimer()
      end
    end
  end
end)
