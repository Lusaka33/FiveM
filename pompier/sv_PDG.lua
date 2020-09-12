RegisterServerEvent('PDG_pompier:getAllInfo')
AddEventHandler('PDG_pompier:getAllInfo', function()
    Citizen.Trace("Server proccessing ...")
    local mysource = source
    local identifiers = GetPlayerIdentifiers(mysource)
    local steamid = identifiers[1]
    MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @mysteam", {['@mysteam'] = steamid}, function(user_res)
        Citizen.Trace("First request ...")
        if user_res[1] then
            -- joueur ok
            local user_data = user_res[1]
            if user_data.job == 20 then
                MySQL.Async.fetchAll("SELECT * FROM entreprises WHERE job_id = @myjob", {['@myjob'] = user_data.job}, function(job_res)
                    Citizen.Trace("Second request ...")
                    if job_res[1] then
                        -- entreprise ok
                        local job_data = job_res[1]
                        local temp_grade = job_data.grade_PDG - 1
                        if user_data.grade > temp_grade then
                            Citizen.Trace("Load PDG ...")
                            loadPDG(mysource, user_data, job_data)
                        elseif user_data.grade > 0 then
                            loadEmployer(mysource, user_data, job_data)
                            Citizen.Trace("Load Employer ...")
                        else
                            Citizen.Trace("nothing to load ...")
                            -- grade = 0
                        end 
                    else
                        -- entreprise inexistante
                    end
                end)
            else
                -- pas pompier = visiteur
                loadVisiteur(mysource)
            end
        else
            -- joueur inexistant
        end
    end)
end)

function loadPDG (src, user_data, job_data)
    MySQL.Async.fetchAll("SELECT * FROM users WHERE job = 20 ORDER BY `grade` ASC", {}, function(employer_res)
        MySQL.Async.fetchAll("SELECT * FROM pompier_rapport ORDER BY `ID` DESC LIMIT 20", {}, function(rapport_res)
            MySQL.Async.fetchAll("SELECT * FROM post_it WHERE job_id = 20", {}, function(postit_res)
                MySQL.Async.fetchAll("SELECT * FROM candidature WHERE job_id = 20", {}, function(candid_res)
                    local Datas = {
                        coffre_propre = job_data.argent_propre,
                        coffre_sale = job_data.argent_sale,
                        salaires = job_data.salaires,
                        employers = employer_res,
                        rapport = rapport_res,
                        postit = postit_res,
                        candids = candid_res
                    }
                    Citizen.Trace("Call render PDG ...")
                    TriggerClientEvent('PDG_pompier:renderPDG', src, Datas)
                end)
            end)
        end)
    end)
end

function loadEmployer (src, user_data, job_data)
    MySQL.Async.fetchAll("SELECT * FROM post_it WHERE job_id = 20", {}, function(postit_res)
        local Datas = {
            user = user_data,
            postit = postit_res
        }
        Citizen.Trace("Call render Emp ...")
        TriggerClientEvent('PDG_pompier:renderEmp', src, Datas)
    end)
end

function loadVisiteur (src)
    Citizen.Trace("Call render Emp ...")
    TriggerClientEvent('PDG_pompier:renderVis', src)
end