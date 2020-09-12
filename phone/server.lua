ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('phone:load_Data')
AddEventHandler('phone:load_Data', function()
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]
    local phone_number = "666"
    local temp_phone_number = "666"
    MySQL.Async.fetchAll("SELECT * FROM users WHERE `identifier` = @identifier", {['@identifier'] = identifier}, function(result1)
        if result1[1] then
            if ((result1[1].phone_number == "0") or (result1[1].phone_number == "666")) or (result1[1].phone_number == nil) then
                -- user don't have phone number
                MySQL.Async.fetchAll("SELECT phone_number FROM users", {}, function(result2)
                    local temp_try = false
                    while phone_number == "666" do
                        temp_try = false
                        temp_phone_number = "0" .. math.random(600000000,699999999)
                        for nb,value in pairs(result2) do
                            if value.phone_number == temp_phone_number then
                                temp_try = true
                            end
                        end
                        if temp_try == false then
                            phone_number = temp_phone_number
                        end
                    end
                    MySQL.Async.execute("UPDATE users SET phone_number = @phone, phone_zoom = 10, phone_fond = 8 WHERE identifier = @identifier", {['@phone'] = phone_number, ['@identifier'] = identifier})
                    TriggerClientEvent('phone:loaded', src, phone_number, 10, 8, {}, {})
                end)
            else
                -- user have a phone
                phone_number = result1[1].phone_number
                MySQL.Async.fetchAll("SELECT * FROM phone_message WHERE phone_1 = @myphone", {['@myphone'] = phone_number}, function(result3)
                    MySQL.Async.fetchAll("SELECT * FROM phone_contact WHERE owner = @myphone", {['@myphone'] = phone_number}, function(result4)
                        TriggerClientEvent('phone:loaded', src, phone_number, result1[1].phone_zoom or 10, result1[1].phone_fond or 8, result3 or {}, result4 or {})
                    end)
                end)
            end
        else
            -- user not created
            phone_number = "666"
            TriggerClientEvent('phone:loaded', src, phone_number, 10, 8, {}, {})
        end
    end)
end)

RegisterServerEvent('phone:deleteContact')
AddEventHandler('phone:deleteContact', function(tel)
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]
    local phone_number = "666"
    MySQL.Async.fetchAll("SELECT * FROM users WHERE `identifier` = @identifier", {['@identifier'] = identifier}, function(result1)
        if result1[1] then
            if result1[1].phone_number == "666" then
                -- user don't have phone number
            else
                -- user have a phone
                phone_number = result1[1].phone_number
                MySQL.Async.execute("DELETE FROM phone_message WHERE phone_1 = @myphone AND phone_2 = @other", {['@myphone'] = phone_number, ['@other'] = tel})
                MySQL.Async.execute("DELETE FROM phone_contact WHERE owner = @myphone AND phone = @other", {['@myphone'] = phone_number, ['@other'] = tel})
            end
        else
            -- user not created
        end
    end)
end)

RegisterServerEvent('phone:addContact')
AddEventHandler('phone:addContact', function(tel, name)
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]
    local phone_number = "666"
    MySQL.Async.fetchAll("SELECT * FROM users WHERE `identifier` = @identifier", {['@identifier'] = identifier}, function(result1)
        if result1[1] then
            if result1[1].phone_number == "666" then
                -- user don't have phone number
            else
                -- user have a phone
                phone_number = result1[1].phone_number
                MySQL.Async.execute("INSERT INTO phone_contact(owner,phone,name) VALUES (@a,@b,@c)", {['@a'] = phone_number, ['@b'] = tel, ['@c'] = name})
            end
        else
            -- user not created
        end
    end)
end)

RegisterServerEvent('phone:modifyContact')
AddEventHandler('phone:modifyContact', function(original, tel, name)
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]
    local phone_number = "666"
    MySQL.Async.fetchAll("SELECT * FROM users WHERE `identifier` = @identifier", {['@identifier'] = identifier}, function(result1)
        if result1[1] then
            if result1[1].phone_number == "666" then
                -- user don't have phone number
            else
                -- user have a phone
                phone_number = result1[1].phone_number
                MySQL.Async.execute("UPDATE phone_contact SET phone = @b, name = @c WHERE owner = @a AND phone = @d", {['@a'] = phone_number, ['@b'] = tel, ['@c'] = name, ['@d'] = original})
            end
        else
            -- user not created
        end
    end)
end)

RegisterServerEvent('phone:deleteMessage')
AddEventHandler('phone:deleteMessage', function(tel, message, date)
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]
    local phone_number = "666"
    MySQL.Async.fetchAll("SELECT * FROM users WHERE `identifier` = @identifier", {['@identifier'] = identifier}, function(result1)
        if result1[1] then
            if result1[1].phone_number == "666" then
                -- user don't have phone number
            else
                -- user have a phone
                phone_number = result1[1].phone_number
                MySQL.Async.execute("DELETE FROM phone_message WHERE phone_1 = @myphone AND phone_2 = @other AND message = @msg AND date = @date", {['@myphone'] = phone_number, ['@other'] = tel, ['@msg'] = message, ['@date'] = date})
            end
        else
            -- user not created
        end
    end)
end)

RegisterServerEvent('phone:deleteConversation')
AddEventHandler('phone:deleteConversation', function(tel)
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]
    local phone_number = "666"
    MySQL.Async.fetchAll("SELECT * FROM users WHERE `identifier` = @identifier", {['@identifier'] = identifier}, function(result1)
        if result1[1] then
            if result1[1].phone_number == "666" then
                -- user don't have phone number
            else
                -- user have a phone
                phone_number = result1[1].phone_number
                MySQL.Async.execute("DELETE FROM phone_message WHERE phone_1 = @myphone AND phone_2 = @other", {['@myphone'] = phone_number, ['@other'] = tel})
            end
        else
            -- user not created
        end
    end)
end)

RegisterServerEvent('phone:addMessage')
AddEventHandler('phone:addMessage', function(tel, message, anonyme, date)
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]
    local phone_number = "666"
    MySQL.Async.fetchAll("SELECT * FROM users WHERE `identifier` = @identifier", {['@identifier'] = identifier}, function(result1)
        if result1[1] then
            if result1[1].phone_number == "666" then
                -- user don't have phone number
            else
                -- user have a phone
                phone_number = result1[1].phone_number
                MySQL.Async.execute("INSERT INTO phone_message(phone_1,phone_2,is1Sender,message,isRead,isAnonyme,date) VALUES (@a,@b,1,@d,0,@f,@g)", {['@a'] = phone_number, ['@b'] = tel, ['@d'] = message, ['@f'] = anonyme, ['@g'] = date})
                MySQL.Async.execute("INSERT INTO phone_message(phone_1,phone_2,is1Sender,message,isRead,isAnonyme,date) VALUES (@b,@a,0,@d,0,@f,@g)", {['@a'] = phone_number, ['@b'] = tel, ['@d'] = message, ['@f'] = anonyme, ['@g'] = date})
                TriggerClientEvent('phone:newMessage', -1, phone_number, tel, message, anonyme, date)
            end
        else
            -- user not created
        end
    end)
end)

RegisterServerEvent('phone:resetSMS')
AddEventHandler('phone:resetSMS', function()
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]
    local phone_number = "666"
    MySQL.Async.fetchAll("SELECT * FROM users WHERE `identifier` = @identifier", {['@identifier'] = identifier}, function(result1)
        if result1[1] then
            if result1[1].phone_number == "666" then
                -- user don't have phone number
            else
                -- user have a phone
                phone_number = result1[1].phone_number
                MySQL.Async.execute("DELETE FROM phone_message WHERE phone_1 = @myphone", {['@myphone'] = phone_number})
            end
        else
            -- user not created
        end
    end)
end)

RegisterServerEvent('phone:resetTel')
AddEventHandler('phone:resetTel', function()
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]
    local phone_number = "666"
    MySQL.Async.fetchAll("SELECT * FROM users WHERE `identifier` = @identifier", {['@identifier'] = identifier}, function(result1)
        if result1[1] then
            if result1[1].phone_number == "666" then
                -- user don't have phone number
            else
                -- user have a phone
                phone_number = result1[1].phone_number
                MySQL.Async.execute("DELETE FROM phone_message WHERE phone_1 = @myphone", {['@myphone'] = phone_number})
                MySQL.Async.execute("DELETE FROM phone_contact WHERE owner = @myphone", {['@myphone'] = phone_number})
                MySQL.Async.execute("UPDATE users SET phone_zoom = 1, phone_fond = 8 WHERE phone_number = @phone", {['@phone'] = phone_number})
            end
        else
            -- user not created
        end
    end)
end)

RegisterServerEvent('phone:saveData')
AddEventHandler('phone:saveData', function(zoom, fond)
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]
    local phone_number = "666"
    MySQL.Async.fetchAll("SELECT * FROM users WHERE `identifier` = @identifier", {['@identifier'] = identifier}, function(result1)
        if result1[1] then
            if result1[1].phone_number == "666" then
                -- user don't have phone number
            else
                -- user have a phone
                phone_number = result1[1].phone_number
                MySQL.Async.execute("UPDATE users SET phone_zoom = @a, phone_fond = @b WHERE phone_number = @phone", {['@phone'] = phone_number, ['@a'] = zoom, ['@b'] = fond})
            end
        else
            -- user not created
        end
    end)
end)
