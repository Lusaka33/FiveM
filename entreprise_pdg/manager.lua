RegisterServerEvent('entreprise:deposerPropre')
AddEventHandler('entreprise:deposerPropre', function(job, money)
    money = money or 0
    local xPlayer = ESX.GetPlayerFromId(source)
    if (xPlayer.getMoney() or 0) >= money then
        Entreprises[job].Sdata.general.propre = Entreprises[job].Sdata.general.propre + money
        xPlayer.removeMoney(money)
        TriggerClientEvent('esx:showNotification', source, "Vous avez déposer " .. money .. " $")
        MySQL.Async.execute("UPDATE entreprises SET `propre` = `propre` + @a WHERE job = @job", {['@job'] = job, ['@a'] = money})
    else
        TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas assez d'argent")
    end
end)

RegisterServerEvent('entreprise:retirerPropre')
AddEventHandler('entreprise:retirerPropre', function(job, money)
    money = money or 0
    local xPlayer = ESX.GetPlayerFromId(source)
    if Entreprises[job].Sdata.general.propre >= money then
        Entreprises[job].Sdata.general.propre = Entreprises[job].Sdata.general.propre - money
        xPlayer.addMoney(money)
        TriggerClientEvent('esx:showNotification', source, "Vous avez retirer " .. money .. " $")
        MySQL.Async.execute("UPDATE entreprises SET `propre` = `propre` - @a WHERE job = @job", {['@job'] = job, ['@a'] = money})
    else
        TriggerClientEvent('esx:showNotification', source, "Il n'y a pas assez d'argent dans le coffre")
    end
end)

RegisterServerEvent('entreprise:deposerSale')
AddEventHandler('entreprise:deposerSale', function(job, money)
    money = money or 0
    local xPlayer = ESX.GetPlayerFromId(source)
    if (xPlayer.getAccount('black_money').money or 0) >= money then
        Entreprises[job].Sdata.general.sale = Entreprises[job].Sdata.general.sale + money
        xPlayer.removeAccountMoney('black_money', money)
        TriggerClientEvent('esx:showNotification', source, "Vous avez déposer " .. money .. " $")
        MySQL.Async.execute("UPDATE entreprises SET `sale` = `sale` + @a WHERE job = @job", {['@job'] = job, ['@a'] = money})
    else
        TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas assez d'argent sale")
    end
end)

RegisterServerEvent('entreprise:retirerSale')
AddEventHandler('entreprise:retirerSale', function(job, money)
    money = money or 0
    local xPlayer = ESX.GetPlayerFromId(source)
    if Entreprises[job].Sdata.general.sale >= money then
        Entreprises[job].Sdata.general.sale = Entreprises[job].Sdata.general.sale - money
        xPlayer.addAccountMoney('black_money', money)
        TriggerClientEvent('esx:showNotification', source, "Vous avez retirer " .. money .. " $")
        MySQL.Async.execute("UPDATE entreprises SET `sale` = `sale` - @a WHERE job = @job", {['@job'] = job, ['@a'] = money})
    else
        TriggerClientEvent('esx:showNotification', source, "Il n'y a pas assez d'argent sale dans le coffre")
    end
end)

RegisterServerEvent('entreprise:blanchir')
AddEventHandler('entreprise:blanchir', function(job, money)
    money = money or 0
    if Entreprises[job].Sdata.general.sale >= money then
        Entreprises[job].Sdata.general.sale = Entreprises[job].Sdata.general.sale - money
        Entreprises[job].Sdata.general.propre = Entreprises[job].Sdata.general.propre + money
        TriggerClientEvent('esx:showNotification', source, "Vous avez blanchit " .. money .. " $")
        MySQL.Async.execute("UPDATE entreprises SET `sale` = `sale` - @a, `propre` = `propre` + @a WHERE job = @job", {['@job'] = job, ['@a'] = money})
    else
        TriggerClientEvent('esx:showNotification', source, "Il n'y a pas assez d'argent sale dans le coffre")
    end
end)

RegisterServerEvent('entreprise:setGrade')
AddEventHandler('entreprise:setGrade', function(job, steam, newgrade)
    for k,v in pairs(Entreprises[job].Sdata.employers) do
        if v.identifier == steam then
            Entreprises[job].Sdata.employers[k].job_grade = newgrade
        end
    end
    local players = GetPlayers()
    for k,v in pairs(players) do
        if GetPlayerIdentifiers(v)[1] == steam then
            local xPlayer = ESX.GetPlayerFromId(v)
            xPlayer.setJob(job, newgrade)
            TriggerClientEvent('esx:showNotification', v, "Votre grade à était changer par votre patron")
        end
    end
    MySQL.Async.execute("UPDATE users SET `job_grade` = @a WHERE identifier = @b", {['@b'] = steam, ['@a'] = newgrade})
end)

RegisterServerEvent('entreprise:virer')
AddEventHandler('entreprise:virer', function(job, steam)
    for k,v in pairs(Entreprises[job].Sdata.employers) do
        if v.identifier == steam then
            Entreprises[job].Sdata.employers[k] = nil
        end
    end
    local players = GetPlayers()
    for k,v in pairs(players) do
        if GetPlayerIdentifiers(v)[1] == steam then
            local xPlayer = ESX.GetPlayerFromId(v)
            xPlayer.setJob('unemployed', 0)
            TriggerClientEvent('esx:showNotification', v, "Votre patron vous à virez")
        end
    end
    MySQL.Async.execute("UPDATE users SET `job` = 'unemployed', `job_grade` = 0 WHERE identifier = @b", {['@b'] = steam})
end)

RegisterServerEvent('entreprise:recruter')
AddEventHandler('entreprise:recruter', function(job, ID)
    MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @a", {['@a'] = GetPlayerIdentifiers(ID)[1]}, function(result1)
        if result1[1] ~= nil then
            result1[1].job = job
            result1[1].job_grade = 0
            table.insert(Entreprises[job].Sdata.employers, result1[1])
            local xPlayer = ESX.GetPlayerFromId(ID)
            xPlayer.setJob(job, 0)
            TriggerClientEvent('esx:showNotification', ID, "Vous venez d'être embaucher")

            MySQL.Async.execute("UPDATE users SET `job` = @a, `job_grade` = 0 WHERE identifier = @b", {['@b'] = GetPlayerIdentifiers(ID)[1], ['@a'] = job})
        else
            TriggerClientEvent('esx:showNotification', ID, "ERREUR PDG : critical error while collecting data for" .. GetPlayerIdentifiers(ID)[1] .. " in users")
        end
    end)
end)

RegisterServerEvent('entreprise:remCandid')
AddEventHandler('entreprise:remCandid', function(job, ID)
    MySQL.Async.execute("DELETE FROM candidatures WHERE `id` = @a", {['@a'] = ID})
    for k,v in pairs(Entreprises[job].Sdata.candids) do
        if v.id == ID then
            Entreprises[job].Sdata.candids[k] = nil
        end
    end
end)

RegisterServerEvent('entreprise:addCandid')
AddEventHandler('entreprise:addCandid', function(job, mot, par)
    MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @a", {['@a'] = GetPlayerIdentifiers(source)[1]}, function(result1)
        if result1[1] ~= nil then
            --valid
            MySQL.Sync.execute("INSERT INTO candidatures (`job`, `nom`, `prenom`, `telephone`, `metier`, `motivation`, `parcours`) VALUES (@a, @b, @c, @d, @e, @f, @g)", {['@a'] = job, ['@b'] = result1[1].nom, ['@c'] = result1[1].prenom, ['@d'] = result1[1].phone_number, ['@e'] = result1[1].job, ['@f'] = mot, ['@g'] = par})
            MySQL.Async.fetchAll("SELECT * FROM candidatures WHERE job = @a", {['@a'] = job}, function(result2)
                Entreprises[job].Sdata.candids = result2
            end)
        end
    end)
end)

RegisterServerEvent('entreprise:remPostit')
AddEventHandler('entreprise:remPostit', function(job, ID)
    MySQL.Async.execute("DELETE FROM post_it WHERE `id` = @a", {['@a'] = ID})
    for k,v in pairs(Entreprises[job].Sdata.post_it) do
        if v.id == ID then
            Entreprises[job].Sdata.post_it[k] = nil
        end
    end
end)

RegisterServerEvent('entreprise:addPostit')
AddEventHandler('entreprise:addPostit', function(job, text)
    MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @a", {['@a'] = GetPlayerIdentifiers(source)[1]}, function(result1)
        if result1[1] ~= nil then
            --valid
            MySQL.Sync.execute("INSERT INTO post_it (`writer`, `job`, `content`) VALUES (@a, @b, @c)", {['@a'] = result1[1].prenom .. " " .. result1[1].nom, ['@b'] = job, ['@c'] = text})
            MySQL.Async.fetchAll("SELECT * FROM post_it WHERE job = @a", {['@a'] = job}, function(result2)
                Entreprises[job].Sdata.post_it = result2
            end)
        end
    end)
end)

RegisterServerEvent('entreprise:buyWeapon')
AddEventHandler('entreprise:buyWeapon', function(job, weap)
    local weapdata = false
    local weapnb = 0
    for k,v in pairs(Entreprises[job].Sdata.armurerie) do
        if v.name == weap then
            weapdata = v
            weapnb = k
        end
    end
    if weapdata.total < weapdata.limit then
        if Entreprises[job].Sdata.general.propre >= weapdata.price then
            Entreprises[job].Sdata.armurerie[weapnb].total = Entreprises[job].Sdata.armurerie[weapnb].total + 1
            Entreprises[job].Sdata.armurerie[weapnb].dispo = Entreprises[job].Sdata.armurerie[weapnb].dispo + 1
            Entreprises[job].Sdata.general.propre = Entreprises[job].Sdata.general.propre - weapdata.price
            MySQL.Async.execute("UPDATE entreprises SET `propre` = `propre` - @a WHERE job = @job", {['@job'] = job, ['@a'] = weapdata.price})
            MySQL.Async.execute("UPDATE entreprise_weapons SET `total` = `total` + 1, `dispo` = `dispo` + 1 WHERE job = @job AND name = @a", {['@job'] = job, ['@a'] = weap})
        else
            TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas assez d'argent dans le coffre, le livreur est repartit avec l'arme")
        end
    else
        TriggerClientEvent('esx:showNotification', source, "Limite atteinte pour l'arme, le livreur est repartit avec")
    end
end)
-------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

--[[
------------- COFFRE
RegisterServerEvent('coffre:AddPropre')
RegisterServerEvent('coffre:AddPropre2')
RegisterServerEvent('coffre:RemPropre')
RegisterServerEvent('coffre:AddSale')
RegisterServerEvent('coffre:RemSale')
RegisterServerEvent('coffre:Doblanchir')
RegisterServerEvent('coffre:transfert')

AddEventHandler('coffre:AddPropre', function(job, toadd)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local user_id = user.getIdentifier()
        if (user.getMoney() - toadd) >= 0 then
            MySQL.Async.fetchAll("SELECT * FROM entreprises WHERE job_id = @myjob", {['@myjob'] = job}, function(job_res)
                local temp_money = job_res[1].argent_propre + toadd
                user.removeMoney(toadd)
                MySQL.Async.execute("UPDATE entreprises SET `argent_propre` = @newmoney WHERE job_id = @myjob", {['@myjob'] = job, ['@newmoney'] = temp_money})
            end)
        else
            TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Pas assez d'argent")
        end
    end)
end)

AddEventHandler('coffre:AddPropre2', function(job, toadd)
    MySQL.Async.fetchAll("SELECT * FROM entreprises WHERE job_id = @myjob", {['@myjob'] = job}, function(job_res)
        local temp_money = job_res[1].argent_propre + toadd
        MySQL.Async.execute("UPDATE entreprises SET `argent_propre` = @newmoney WHERE job_id = @myjob", {['@myjob'] = job, ['@newmoney'] = temp_money})
    end)
end)

AddEventHandler('coffre:RemPropre', function(job, toadd)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local user_id = user.getIdentifier()
        MySQL.Async.fetchAll("SELECT * FROM entreprises WHERE job_id = @myjob", {['@myjob'] = job}, function(job_res)
            if job_res[1].argent_propre - toadd >= 0 then
                local temp_money = job_res[1].argent_propre - toadd
                user.addMoney(toadd)
                MySQL.Async.execute("UPDATE entreprises SET `argent_propre` = @newmoney WHERE job_id = @myjob", {['@myjob'] = job, ['@newmoney'] = temp_money})
            else
                TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Pas assez d'argent")
            end
        end)
    end)
end)

AddEventHandler('coffre:AddSale', function(job, toadd)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local user_id = user.getIdentifier()
        if (user.getDirtyMoney() - toadd) >= 0 then
            MySQL.Async.fetchAll("SELECT * FROM entreprises WHERE job_id = @myjob", {['@myjob'] = job}, function(job_res)
                local temp_money = job_res[1].argent_sale + toadd
                user.removeDirtyMoney(toadd)
                MySQL.Async.execute("UPDATE entreprises SET `argent_sale` = @newmoney WHERE job_id = @myjob", {['@myjob'] = job, ['@newmoney'] = temp_money})
            end)
        else
            TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Pas assez d'argent")
        end
    end)
end)

AddEventHandler('coffre:RemSale', function(job, toadd)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local user_id = user.getIdentifier()
        MySQL.Async.fetchAll("SELECT * FROM entreprises WHERE job_id = @myjob", {['@myjob'] = job}, function(job_res)
            if job_res[1].argent_sale - toadd >= 0 then
                local temp_money = job_res[1].argent_sale - toadd
                user.addDirtyMoney(toadd)
                MySQL.Async.execute("UPDATE entreprises SET `argent_sale` = @newmoney WHERE job_id = @myjob", {['@myjob'] = job, ['@newmoney'] = temp_money})
            else
                TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Pas assez d'argent")
            end
        end)
    end)
end)

AddEventHandler('coffre:Doblanchir', function(job, toadd)
    MySQL.Async.fetchAll("SELECT * FROM entreprises WHERE job_id = @myjob", {['@myjob'] = job}, function(job_res)
        if job_res[1].argent_sale - toadd >= 0 then
            local temp_money = job_res[1].argent_sale - toadd
            local temp_money2 = job_res[1].argent_propre + toadd
            MySQL.Async.execute("UPDATE entreprises SET `argent_propre` = @clean, `argent_sale` = @sale WHERE job_id = @myjob", {['@myjob'] = job, ['@clean'] = temp_money2, ['@sale'] = temp_money})
        else
            TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Pas assez d'argent")
        end
    end)
end)



AddEventHandler('coffre:transfert', function(from, to, add)
    local mysrc = source
    MySQL.Async.fetchAll("SELECT * FROM entreprises WHERE job_id = @myjob", {['@myjob'] = from}, function(job_res1)
        MySQL.Async.fetchAll("SELECT * FROM entreprises WHERE job_id = @myjob", {['@myjob'] = to}, function(job_res2)
            if job_res1[1] then
                if job_res2[1] then
                    if job_res1[1].argent_propre >= add then
                        local temp_money1 = job_res1[1].argent_propre - add
                        local temp_money2 = job_res2[1].argent_propre + add
                        MySQL.Async.execute("UPDATE entreprises SET `argent_propre` = @newmoney WHERE job_id = @myjob", {['@myjob'] = from, ['@newmoney'] = temp_money1})
                        MySQL.Async.execute("UPDATE entreprises SET `argent_propre` = @newmoney WHERE job_id = @myjob", {['@myjob'] = to, ['@newmoney'] = temp_money2})
                        TriggerClientEvent("es_freeroam:notify", mysrc, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Virement de " .. add .. "~g~$~s~ effectue")
                    else
                        TriggerClientEvent("es_freeroam:notify", mysrc, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Pas assez d'argent")
                    end
                end
            end
        end)
    end)
end)

-------------------------------- RAPPORTS
RegisterServerEvent('patron:signeRapportLSFD')
RegisterServerEvent('patron:NewRapportLSFD')
RegisterServerEvent('patron:signeRapportMedic')
RegisterServerEvent('patron:NewRapportMedic')

AddEventHandler('patron:signeRapportLSFD', function(rapportID)
    MySQL.Async.execute("UPDATE pompier_rapport SET `IsSigned` = 1 WHERE ID = @myid", {['@myid'] = rapportID})
end)
AddEventHandler('patron:signeRapportMedic', function(rapportID)
    MySQL.Async.execute("UPDATE ambu_rapport SET `IsSigned` = 1 WHERE ID = @myid", {['@myid'] = rapportID})
end)

AddEventHandler('patron:NewRapportLSFD', function(a, b, c, d, e)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local user_id = user.getIdentifier()
        MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @steam", {['@steam'] = user_id}, function(user_res)
            if user_res[1] then
                MySQL.Async.execute("INSERT INTO pompier_rapport (`Writer`, `IsSigned`, `Participant`, `Raison`, `Inter_ID`, `Text`, `Lieu`) VALUES (@aa, '0', @bb, @cc, @dd, @ee, @ff)", {['@aa'] = user_res[1].prenom .. " " .. user_res[1].nom, ['@bb'] = a, ['@cc'] = b, ['@dd'] = c, ['@ee'] = d, ['@ff'] = e})
            else
                MySQL.Async.execute("INSERT INTO pompier_rapport (`Writer`, `IsSigned`, `Participant`, `Raison`, `Inter_ID`, `Text`, `Lieu`) VALUES ('Unknow', '0', @bb, @cc, @dd, @ee, @ff)", {['@bb'] = a, ['@cc'] = b, ['@dd'] = c, ['@ee'] = d, ['@ff'] = e})
            end
        end)
    end)
end)

AddEventHandler('patron:NewRapportMedic', function(a, b, c, d)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local user_id = user.getIdentifier()
        MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @steam", {['@steam'] = user_id}, function(user_res)
            if user_res[1] then
                MySQL.Async.execute("INSERT INTO ambu_rapport (`Writer`, `Patient`, `Geste_1`, `Geste_2`, `Suivi`, `IsSigned`) VALUES (@aa, @bb, @cc, @dd, @ee, 0)", {['@aa'] = user_res[1].prenom .. " " .. user_res[1].nom, ['@bb'] = a, ['@cc'] = b, ['@dd'] = c, ['@ee'] = d})
            else
                MySQL.Async.execute("INSERT INTO ambu_rapport (`Writer`, `Patient`, `Geste_1`, `Geste_2`, `Suivi`, `IsSigned`) VALUES ('Unknow', @bb, @cc, @dd, @ee, 0)", {['@bb'] = a, ['@cc'] = b, ['@dd'] = c, ['@ee'] = d})
            end
        end)
    end)
end)


-------------------------------- POST-IT
RegisterServerEvent('patron:addPostit')
RegisterServerEvent('patron:remPostit')

AddEventHandler('patron:addPostit', function(job_id, text)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local user_id = user.getIdentifier()
        MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @steam", {['@steam'] = user_id}, function(user_res)
            if user_res[1] then
                MySQL.Async.execute("INSERT INTO post_it (`writer`, `job_id`, `text`) VALUES (@a, @b, @c)", {['@a'] = user_res[1].prenom .. " " .. user_res[1].nom, ['@b'] = job_id, ['@c'] = text})
            else
                MySQL.Async.execute("INSERT INTO post_it (`writer`, `job_id`, `text`) VALUES ('unknow', @b, @c)", {['@b'] = job_id, ['@c'] = text})
            end
        end)
    end)
end)

AddEventHandler('patron:remPostit', function(id)
    MySQL.Async.execute("DELETE FROM post_it WHERE `ID` = @a", {['@a'] = id})
end)


-------------------------------- CANDIDATURES
RegisterServerEvent('patron:addCandidature')
RegisterServerEvent('patron:remCandidature')

AddEventHandler('patron:addCandidature', function(job_id, a, b)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local user_id = user.getIdentifier()
        MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @steam", {['@steam'] = user_id}, function(user_res)
            if user_res[1] then
                local ud = user_res[1]
                MySQL.Async.fetchAll("SELECT * FROM jobs WHERE job_id = @a", {['@a'] = ud.job}, function(jobname)
                    MySQL.Async.execute("INSERT INTO candidature (`job_id`, `prenom`, `nom`, `telephone`, `motivation`, `metier_name`, `metier`, `parcours`) VALUES (@a, @b, @c, @d, @e, @f, @g, @h);", {['@a'] = job_id, ['@b'] = ud.prenom, ['@c'] = ud.nom, ['@d'] = ud.phone_number, ['@e'] = a, ['@f'] = jobname[1].job_name, ['@g'] = ud.job, ['@h'] = b})
                end)
            end
        end)
    end)
end)


AddEventHandler('patron:remCandidature', function(id)
    MySQL.Async.execute("DELETE FROM candidature WHERE `ID` = @a", {['@a'] = id})
end)


-------------------------------- SALAIRES
RegisterServerEvent('patron:Newsalaires')

AddEventHandler('patron:Newsalaires', function(job_id, salaires)
    MySQL.Async.execute("UPDATE entreprises SET `salaires` = @a WHERE `job_id` = @b", {['@a'] = salaires, ['@b'] = job_id})
end)]]
