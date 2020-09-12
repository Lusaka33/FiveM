-- function to open Bureau ==> openBureau ( menu )
local grades = {
    {id = 1, name = 'formation', abr = 'Frm'},
    {id = 2, name = 'stagiaire', abr = 'Stag'},
    {id = 3, name = 'sapeur', abr = 'Sap'},
    {id = 4, name = 'caporal', abr = 'Cap'},
    {id = 5, name = 'lieutenant', abr = 'Ltn'},
    {id = 6, name = 'chef', abr = 'Chef'}
}


function RequestPDGinfo ()
    TriggerServerEvent('PDG_pompier:getAllInfo')
    Citizen.Trace("Asking server ...")
end

RegisterNetEvent('PDG_pompier:renderPDG')
AddEventHandler('PDG_pompier:renderPDG', function(datas)
    Citizen.Trace("Server answering ...")

    local Employesmenu = {
        {
            ['Title'] = 'Embaucher le joueur [ID]',
            ['Event'] = "patron:rectrute",
            inJob = 20,
            ['Close'] = true
        }
    }
    local compteur = 1
    local display_grade = ""
    for nb,value in pairs(datas.employers) do
        compteur = compteur + 1
        if grades[value.grade] then
            display_grade = grades[value.grade].name
        else
            display_grade = "unknow"
        end
        Employesmenu[compteur] = {
            ['Title'] = display_grade .. " " .. value.prenom .. " " .. value.nom,
            ['SubMenu'] = {
                ['Title'] = "Gestion employer",
                ['Items'] = {
                    {
                        ['Title'] = 'Prenom : ' .. value.prenom
                    },
                    {
                        ['Title'] = 'Nom : ' .. value.nom
                    },
                    {
                        ['Title'] = 'Grade : ' .. display_grade .. " (" .. value.grade .. ")"
                    },
                    {
                        ['Title'] = 'Telephone : ' .. value.phone_number
                    },
                    {
                        ['Title'] = 'Passer au grade supérieur',
                        ['Event'] = "patron:setgrade",
                        steam = value.identifier,
                        new_grade = value.grade + 1,
                        ['Close'] = true
                    },
                    {
                        ['Title'] = 'Passer au grade inferieur',
                        ['Event'] = "patron:setgrade",
                        steam = value.identifier,
                        new_grade = value.grade - 1,
                        ['Close'] = true
                    },
                    {
                        ['Title'] = '/!\\ Virer',
                        ['Event'] = "patron:virer",
                        steam = value.identifier,
                        ['Close'] = true
                    }
                }
            }
        }
    end

    local rapport_nonlu = {
        ['Title'] = 'Rapport non lu',
        ['Items'] = {}
    }
    local compteur1 = 0
    local rapport_archive = {
        ['Title'] = 'Rapport archivés',
        ['Items'] = {}
    }
    local compteur2 = 0
    for nb,value in pairs(datas.rapport) do
        if value.IsSigned == 0 then
            compteur1 = compteur1 + 1
            rapport_nonlu.Items[compteur1] = {
                ['Title'] = "Rapport " .. value.ID,
                ['SubMenu'] = {
                    ['Title'] = 'Rapport' .. value.ID,
                    ['Items'] = {
                        {
                            ['Title'] = "Par : " .. value.Writer
                        },
                        {
                            ['Title'] = "Inter : " .. value.Inter_ID
                        },
                        {
                            ['Title'] = "Voir les participant",
                            ['Event'] = "patron:seeText",
                            text = value.Participant
                        },
                        {
                            ['Title'] = "Voir le lieux",
                            ['Event'] = "patron:seeText",
                            text = value.Lieu
                        },
                        {
                            ['Title'] = "Voir la raison",
                            ['Event'] = "patron:seeText",
                            text = value.Raison
                        },
                        {
                            ['Title'] = "Voir le rapport",
                            ['Event'] = "patron:seeText",
                            text = value.Text
                        },
                        {
                            ['Title'] = "Signer le rapport",
                            ['Event'] = "patron:signerRapportLSFD",
                            id = value.ID,
                            ['Close'] = true
                        }
                    }
                }
            }
        else
            compteur2 = compteur2 + 1
            rapport_archive.Items[compteur2] = {
                ['Title'] = "Rapport " .. value.ID,
                ['SubMenu'] = {
                    ['Title'] = 'Rapport ' .. value.ID,
                    ['Items'] = {
                        {
                            ['Title'] = "Par : " .. value.Writer
                        },
                        {
                            ['Title'] = "Inter : " .. value.Inter_ID
                        },
                        {
                            ['Title'] = "Voir les participant",
                            ['Event'] = "patron:seeText",
                            text = value.Participant
                        },
                        {
                            ['Title'] = "Voir le lieux",
                            ['Event'] = "patron:seeText",
                            text = value.Lieu
                        },
                        {
                            ['Title'] = "Voir la raison",
                            ['Event'] = "patron:seeText",
                            text = value.Raison
                        },
                        {
                            ['Title'] = "Voir le rapport",
                            ['Event'] = "patron:seeText",
                            text = value.Text
                        }
                    }
                }
            }
        end
    end

    local postitmenu = {
        ['Title'] = 'Post-it',
        ['Items'] = {
            {
                ['Title'] = "Nouveau post-it",
                ['Event'] = "patron:newPostit",
                inJob = 20,
                ['Close'] = true
            }
        }
    }
    local compteur3 = 1
    for nb,value in pairs(datas.postit) do
        compteur3 = compteur3 + 1
        postitmenu.Items[compteur3] = {
            ['Title'] = "Post-it de : " .. value.writer,
            ['SubMenu'] = {
                ['Title'] = 'Post-it  ' .. value.ID,
                ['Items'] = {
                    {
                        ['Title'] = "De : " .. value.writer
                    },
                    {
                        ['Title'] = "Voir le message",
                        ['Event'] = "patron:seeText",
                        text = value.text
                    },
                    {
                        ['Title'] = "Supprimer le post-it",
                        ['Event'] = "patron:delPostit",
                        id = value.ID,
                        ['Close'] = true
                    }
                }
            }
        }
    end

    local candidmenu = {}
    local compteur4 = 0
    for nb,value in pairs(datas.candids) do
        compteur4 = compteur4 + 1
        candidmenu[compteur4] = {
            ['Title'] = "Candidature " .. value.ID,
            ['SubMenu'] = {
                ['Title'] = "Candidature " .. value.ID,
                ['Items'] = {
                    {
                        ['Title'] = "Prenom : " .. value.prenom
                    },
                    {
                        ['Title'] = "Nom : " .. value.nom
                    },
                    {
                        ['Title'] = "Tel : " .. value.telephone
                    },
                    {
                        ['Title'] = "Métier : " .. value.metier_name
                    },
                    {
                        ['Title'] = "Voir la motivation",
                        ['Event'] = "patron:seeText",
                        text = value.motivation
                    },
                    {
                        ['Title'] = "Voir le parcours pro",
                        ['Event'] = "patron:seeText",
                        text = value.parcours
                    },
                    {
                        ['Title'] = "Supprimer la candidature",
                        ['Event'] = "patron:delCandidature",
                        id = value.ID,
                        ['Close'] = true
                    }
                }
            }
        }
    end

    local menu = {
        ['Title'] = 'Bureau - pompier',
        ['Items'] = {
            {
                ['Title'] = 'Coffres',
                ['SubMenu'] = {
                    ['Title'] = 'Coffres',
                    ['Items'] = {
                        {
                            ['Title'] = 'Argent propre : ' .. datas.coffre_propre .. ' $'
                        },
                        {
                            ['Title'] = 'Déposer argent propre',
                            ['Event'] = "coffre:deposerPropre",
                            job_id = 20,
                            ['Close'] = true

                        },
                        {
                            ['Title'] = 'Retirer argent propre',
                            ['Event'] = "coffre:retirerPropre",
                            job_id = 20,
                            ['Close'] = true
                        },
                        {
                            ['Title'] = 'Argent sale : ' .. datas.coffre_sale .. ' $'
                        },
                        {
                            ['Title'] = 'Déposer argent sale',
                            ['Event'] = "coffre:deposerSale",
                            job_id = 20,
                            ['Close'] = true
                        },
                        {
                            ['Title'] = 'Retirer argent sale',
                            ['Event'] = "coffre:retirerSale",
                            job_id = 20,
                            ['Close'] = true
                        },
                        {
                            ['Title'] = 'Blanchiment',
                            ['Event'] = "coffre:blanchir",
                            job_id = 20,
                            ['Close'] = true
                        },
                        {
                            ['Title'] = 'Retour',
                            ['ReturnBtn'] = true
                        }
                    }
                }
            },
            {
                ['Title'] = 'Employés',
                ['SubMenu'] = {
                    ['Title'] = 'Employés',
                    ['Items'] = Employesmenu
                }
            },
            {
                ['Title'] = 'Gestion des salaires',
                ['SubMenu'] = {
                    ['Title'] = 'Gestion des salaires',
                    ['Items'] = {
                        {
                            ['Title'] = 'Voir / Modifier',
                            ['Event'] = "patron:salaires",
                            job_id = 20,
                            text = datas.salaires,
                            ['Close'] = true
                        }
                    }
                }
            },
            {
                ['Title'] = 'Rapports',
                ['SubMenu'] = {
                    ['Title'] = 'Rapports',
                    ['Items'] = {
                        {
                            ['Title'] = 'Faire un rapport',
                            ['Event'] = "patron:DoLSFDrapport",
                            ['Close'] = true
                        },
                        {
                            ['Title'] = 'Rapport non lu',
                            ['SubMenu'] = rapport_nonlu
                        },
                        {
                            ['Title'] = 'Rapport archivés',
                            ['SubMenu'] = rapport_archive
                        }
                    }
                }
            },
            {
                ['Title'] = 'Candidatures',
                ['SubMenu'] = {
                    ['Title'] = 'Candidatures',
                    ['Items'] = candidmenu
                }
            },
            {
                ['Title'] = 'Post-it',
                ['SubMenu'] = postitmenu
            }
        }
    }
    Citizen.Trace("Ask open PDG")

    openBureau(menu)
end)


RegisterNetEvent('PDG_pompier:renderEmp')
AddEventHandler('PDG_pompier:renderEmp', function(datas)
    Citizen.Trace("Server answering ...")

    local display_grade = "unknow"
    if grades[datas.user.grade] then
        display_grade = grades[datas.user.grade].name
    end

    local postitmenu = {
        ['Title'] = 'Post-it',
        ['Items'] = {
            {
                ['Title'] = "Nouveau post-it",
                ['Event'] = "patron:newPostit",
                inJob = 20,
                ['Close'] = true
            }
        }
    }
    local compteur3 = 1
    for nb,value in pairs(datas.postit) do
        compteur3 = compteur3 + 1
        postitmenu.Items[compteur3] = {
            ['Title'] = "Post-it de : " .. value.writer,
            ['SubMenu'] = {
                ['Title'] = 'Post-it  ' .. value.ID,
                ['Items'] = {
                    {
                        ['Title'] = "De : " .. value.writer
                    },
                    {
                        ['Title'] = "Voir le message",
                        ['Event'] = "patron:seeText",
                        text = value.text
                    },
                    {
                        ['Title'] = "Supprimer le post-it",
                        ['Event'] = "patron:delPostit",
                        id = value.ID,
                        ['Close'] = true
                    }
                }
            }
        }
    end

    local menu = {
        ['Title'] = 'Bureau - pompier',
        ['Items'] = {
            {
                ['Title'] = 'Coffres',
                ['SubMenu'] = {
                    ['Title'] = 'Coffres',
                    ['Items'] = {
                        {
                            ['Title'] = 'Déposer argent propre',
                            ['Event'] = "coffre:deposerPropre",
                            job_id = 20,
                            ['Close'] = true

                        },
                        {
                            ['Title'] = 'Retour',
                            ['ReturnBtn'] = true
                        }
                    }
                }
            },
            {
                ['Title'] = 'Mon contrat',
                ['SubMenu'] = {
                    ['Title'] = 'Mon contrat',
                    ['Items'] = {
                        {
                            ['Title'] = "Prenom : " .. datas.user.prenom
                        },
                        {
                            ['Title'] = "Nom : " .. datas.user.nom
                        },
                        {
                            ['Title'] = "Metier : Pompier"
                        },
                        {
                            ['Title'] = "Grade : " .. display_grade
                        },
                        {
                            ['Title'] = "Section : 32"
                        }
                    }
                }
            },
            {
                ['Title'] = 'Faire un rapport',
                ['Event'] = "patron:DoLSFDrapport",
                ['Close'] = true
            },
            {
                ['Title'] = 'Post-it',
                ['SubMenu'] = postitmenu
            }
        }
    }
    Citizen.Trace("Ask open PDG")

    openBureau(menu)
end)


RegisterNetEvent('PDG_pompier:renderVis')
AddEventHandler('PDG_pompier:renderVis', function()
    Citizen.Trace("Server answering ...")

    local menu = {
        ['Title'] = 'Bureau - pompier',
        ['Items'] = {
            {
                ['Title'] = 'Faire un don',
                ['Event'] = "coffre:deposerPropre",
                job_id = 20,
                ['Close'] = true

            },
            {
                ['Title'] = "Déposer une lettre",
                ['Event'] = "patron:newPostit",
                inJob = 20,
                ['Close'] = true
            },
            {
                ['Title'] = 'Faire une candidature',
                ['Event'] = "patron:newCandidature",
                inJob = 20,
                ['Close'] = true

            }
        }
    }
    Citizen.Trace("Ask open PDG")

    openBureau(menu)
end)