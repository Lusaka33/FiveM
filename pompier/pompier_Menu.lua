--====================================================================================
-- #Author: Jonathan D @ Gannon
--
-- Développée pour la communauté n3mtv
--      https://www.twitch.tv/n3mtv
--      https://twitter.com/n3m_tv
--      https://www.facebook.com/lan3mtv
--====================================================================================

local Menu = {}

local ListVehicle1 = {
    {
        ['Title'] = 'Suprimer le véhicule',
        ['CustomAction'] = "deleteCar",
        GradeNeed = 1
    },
    {
        ['Title'] = 'VL',
        ['CustomAction'] = "SpawnCar1",
        name = 'fbi2',
        fifisay = "~o~Fifi : ~w~Si c'est le chef qui le dit, alors pas de soucis",
        GradeNeed = 4
    },
    {
        ['Title'] = 'FPT',
        ['CustomAction'] = "SpawnCar1",
        name = 'firetruk',
        fifisay = "~o~Fifi : ~w~Calme toi, y a pas le feu au lac",
        GradeNeed = 2
    },
    {
        ['Title'] = 'VSAV',
        ['CustomAction'] = "SpawnCar1",
        name = 'ambulance',
        fifisay = "~o~Fifi : ~w~Fait y gaffe, je viens de le réparer",
        GradeNeed = 2
    },
    {
        ['Title'] = 'Dragon',
        ['CustomAction'] = "SpawnHeli1",
        name = "supervolito",
        fifisay = "~o~Fifi : ~w~Arrete de jouer avec, sa coute cher ce truc",
        GradeNeed = 3
    },
    {
        ['Title'] = 'CargoBob',
        ['CustomAction'] = "SpawnHeli1",
        name = "cargobob2",
        fifisay = "~o~Jery : ~w~Fifi je t'encule il est a moi !",
        GradeNeed = 5
    },
    {
        ['Title'] = 'Camion Technique',
        ['CustomAction'] = "SpawnCar1",
        name = 'rallytruck',
        fifisay = "~o~Fifi : ~w~Putain je l'ai pas vu dehors depuis les années 2000 !",
        GradeNeed = 3
    },
    {
        ['Title'] = '4*4 Lifeguard',
        ['CustomAction'] = "SpawnCar1",
        name = 'lguard',
        fifisay = "~o~Fifi : ~w~Pin Pon, PIN PON !",
        GradeNeed = 1
    }
}

local ListVehicle2 = {
    {
        ['Title'] = 'Suprimer le véhicule',
        ['CustomAction'] = "deleteCar",
        GradeNeed = 1
    },
    {
        ['Title'] = 'VSAV',
        ['CustomAction'] = "SpawnCar2",
        name = 'ambulance',
        GradeNeed = 2
    },
    {
        ['Title'] = 'Dragon',
        ['CustomAction'] = "SpawnHeli2",
        name = "supervolito",
        GradeNeed = 3
    },
    {
        ['Title'] = '4*4 Lifeguard',
        ['CustomAction'] = "SpawnCar2",
        name = 'lguard',
        GradeNeed = 1
    },
    {
        ['Title'] = 'quad Lifeguard',
        ['CustomAction'] = "SpawnCar2",
        name = 'blazer2',
        GradeNeed = 3
    }
}

local MenuGaragePompier = {
    ['Title'] = 'Garage pompier',
    ['Items'] = {
        {
            ['Title'] = 'Loading ...'
        },
        {
            ['Title'] = 'Fermer',
            ['Close'] = true
        }
    }
}

local MenuGarageLifeGuard = {
    ['Title'] = 'Garage pompier',
    ['Items'] = {
        {
            ['Title'] = 'Loading ...'
        },
        {
            ['Title'] = 'Fermer',
            ['Close'] = true
        }
    }
}

local MenuMetierPompier = {
    ['Title'] = 'Pompier',
    ['Items'] = {
        --[[{
            ['Title'] = 'Intervention',
            ['SubMenu'] = {
                ['Title'] = 'Intervention',
                ['Items'] = {
                    {
                        ['Title'] = 'Loading inters ...',
                        ['SubMenu'] = {
                            ['Title'] = 'Interventions : 0',
                            ['Items'] = {
                                {
                                    ['Title'] = 'Raison'
                                },
                                {
                                    ['Title'] = 'playerID : 0'
                                },
                                {
                                    ['Title'] = 'Distance : 0m'
                                },
                                {
                                    ['Title'] = "Prendre l'appel",
                                    ['CustomAction'] = "start_call",
                                    inter_id = 0
                                },
                                {
                                    ['Title'] = "Finir l'appel",
                                    ['CustomAction'] = "end_call",
                                    ['Close'] = true,
                                    inter_id = 0
                                },
                                {
                                    ['Title'] = 'Retour',
                                    ['ReturnBtn'] = true
                                }
                            }
                        }
                    },
                    {
                        ['Title'] = 'Retour',
                        ['ReturnBtn'] = true
                    }
                }
            }
        },]]
        {
            ['Title'] = 'Dispatch 911',
            ['Event'] = 'dispatch:openUnit',
            ['Close'] = true
        },
        {
            ['Title'] = 'Tenues',
            ['SubMenu'] = {
                ['Title'] = 'Tenues',
                ['Items'] = {
                    {
                        ['Title'] = 'Tenue de feu',
                        ['CustomAction'] = "Tenues",
                        name = "S_M_Y_Fireman_01"
                    },
                    {
                        ['Title'] = 'Tenue paramedic',
                        ['CustomAction'] = "Tenues",
                        name = "S_M_M_Paramedic_01"
                    },
                    {
                        ['Title'] = 'Tenue lifeguard (H)',
                        ['CustomAction'] = "Tenues",
                        name = "S_M_Y_BayWatch_01"
                    },
                    {
                        ['Title'] = 'Tenue lifeguard (F)',
                        ['CustomAction'] = "Tenues",
                        name = "S_F_Y_Baywatch_01"
                    },
                    {
                        ['Title'] = 'Tenue détente (1/2)',
                        ['CustomAction'] = "Tenues",
                        name = "CUSTOM_01"
                    },
                    {
                        ['Title'] = 'Tenue détente (2/2)',
                        ['CustomAction'] = "Tenues",
                        name = "CUSTOM_02"
                    },
                    {
                        ['Title'] = 'Retour',
                        ['ReturnBtn'] = true
                    }
                }
            }
        },
        {
            ['Title'] = 'Accessoires',
            ['SubMenu'] = {
                ['Title'] = 'Accessoires',
                ['Items'] = {
                    {
                        ['Title'] = 'F1 : tenue sale',
                        ['CustomAction'] = "ACC",
                        name = "F1sale"
                    },
                    {
                        ['Title'] = 'F1 : ARI',
                        ['CustomAction'] = "ACC",
                        name = "F1ari"
                    },
                    {
                        ['Title'] = 'MEDIC : logo',
                        ['CustomAction'] = "ACC",
                        name = "MEDlogo"
                    },
                    {
                        ['Title'] = 'MEDIC : gilet',
                        ['CustomAction'] = "ACC",
                        name = "MEDgilet"
                    },
                    {
                        ['Title'] = 'MEDIC : gants',
                        ['CustomAction'] = "ACC",
                        name = "MEDgants"
                    },
                    {
                        ['Title'] = 'MEDIC : stétoscope',
                        ['CustomAction'] = "ACC",
                        name = "MEDmatos"
                    },
                    {
                        ['Title'] = 'LG H : T-shirt',
                        ['CustomAction'] = "ACC",
                        name = "LGHhaut"
                    },
                    {
                        ['Title'] = 'LG H : ceinture',
                        ['CustomAction'] = "ACC",
                        name = "LGHceinture"
                    },
                    {
                        ['Title'] = 'LG H : gilet de sauvetage',
                        ['CustomAction'] = "ACC",
                        name = "LGHgilet"
                    },
                    {
                        ['Title'] = 'LG F : T-shirt',
                        ['CustomAction'] = "ACC",
                        name = "LGFhaut"
                    },
                    {
                        ['Title'] = 'Retour',
                        ['ReturnBtn'] = true
                    }
                }
            }
        },
        --[[{
            ['Title'] = 'Equipement',
            ['SubMenu'] = {
                ['Title'] = 'Equipement',
                ['Items'] = {
                    {
                        ['Title'] = 'Tous',
                        ['CustomAction'] = "tool",
                        name = "ALL"
                    },
                    {
                        ['Title'] = 'Pied de biche',
                        ['CustomAction'] = "tool",
                        name = "weapon_crowbar"
                    },
                    {
                        ['Title'] = 'Hache',
                        ['CustomAction'] = "tool",
                        name = "weapon_hatchet"
                    },
                    {
                        ['Title'] = 'Lampe torche',
                        ['CustomAction'] = "tool",
                        name = "weapon_flashlight"
                    },
                    {
                        ['Title'] = 'Molotov',
                        ['CustomAction'] = "tool",
                        name = "weapon_molotov"
                    },
                    {
                        ['Title'] = 'Extincteur',
                        ['CustomAction'] = "tool",
                        name = "weapon_fireextinguisher"
                    },
                    {
                        ['Title'] = 'Signalisation',
                        ['CustomAction'] = "tool",
                        name = "weapon_flare"
                    },
                    {
                        ['Title'] = 'Retour',
                        ['ReturnBtn'] = true
                    }
                }
            }
        },]]
        --[[{
            ['Title'] = 'Actions',
            ['SubMenu'] = {
                ['Title'] = 'Actions',
                ['Items'] = {
                    {
                        ['Title'] = 'Soigner la victime',
                        ['CustomAction'] = "action",
                        name = "soigner"
                    },
                    {
                        ['Title'] = 'Réanimer la victime',
                        ['CustomAction'] = "action",
                        name = "reanimer"
                    },
                    {
                        ['Title'] = 'Réanimer de force',
                        ['CustomAction'] = "action",
                        name = "reanimer2"
                    },
                    {
                        ['Title'] = 'Réanimer et TP (noyade)',
                        ['CustomAction'] = "action",
                        name = "reanimer2"
                    },
                    {
                        ['Title'] = 'Attacher le treuil',
                        ['CustomAction'] = "action",
                        name = "saveV"
                    },
                    {
                        ['Title'] = 'Remonter le treuil',
                        ['CustomAction'] = "action",
                        name = "gotoV"
                    },
                    {
                        ['Title'] = 'Faire monter everyone',
                        ['CustomAction'] = "action",
                        name = "tpAllV"
                    },
                    {
                        ['Title'] = 'Faire sortir everyone',
                        ['CustomAction'] = "action",
                        name = "leaveAllV"
                    },
                    {
                        ['Title'] = 'repair (HRP)',
                        ['CustomAction'] = "action",
                        name = "repair"
                    },
                    {
                        ['Title'] = 'Désincarcérer',
                        ['CustomAction'] = "action",
                        name = "opendoor"
                    },
                    {
                        ['Title'] = 'Supprimer le véhicule (HRP)',
                        ['CustomAction'] = "deleteCar"
                    },
                    {
                        ['Title'] = 'Placer un cone',
                        ['CustomAction'] = "action",
                        name = "Newcone"
                    },
                    {
                        ['Title'] = 'Supprimer un cone',
                        ['CustomAction'] = "action",
                        name = "Delcone"
                    },
                    {
                        ['Title'] = 'Retour',
                        ['ReturnBtn'] = true
                    }
                }
            }
        },]]
        {
            ['Title'] = 'Secourisme',
            ['SubMenu'] = {
                ['Title'] = 'Secourisme',
                ['Items'] = {
                    {
                        ['Title'] = 'Soigner la victime',
                        ['CustomAction'] = "action",
                        name = "soigner"
                    },
                    {
                        ['Title'] = 'Réanimer la victime (2m)',
                        ['CustomAction'] = "action",
                        name = "reanimer"
                    },
                    {
                        ['Title'] = 'Réanimer de force',
                        ['CustomAction'] = "action",
                        name = "reanimer2"
                    },
                    {
                        ['Title'] = 'Réanimer et TP (noyade)',
                        ['CustomAction'] = "action",
                        name = "reanimer3"
                    },
                    {
                        ['Title'] = 'camisole : monter de force',
                        ['CustomAction'] = "action",
                        name = "tpAllV"
                    },
                    {
                        ['Title'] = 'camisole : sortir de force',
                        ['CustomAction'] = "action",
                        name = "leaveAllV"
                    },
                    {
                        ['Title'] = 'Retour',
                        ['ReturnBtn'] = true
                    }
                }
            }
        },
        {
            ['Title'] = 'Accident / Treuil',
            ['SubMenu'] = {
                ['Title'] = 'Accident / Treuil',
                ['Items'] = {
                    {
                        ['Title'] = 'Attacher le treuil',
                        ['CustomAction'] = "action",
                        name = "saveV"
                    },
                    {
                        ['Title'] = 'Remonter le treuil',
                        ['CustomAction'] = "action",
                        name = "gotoV"
                    },
                    {
                        ['Title'] = 'Faire monter everyone (25m)',
                        ['CustomAction'] = "action",
                        name = "tpAllV"
                    },
                    {
                        ['Title'] = 'Faire sortir everyone',
                        ['CustomAction'] = "action",
                        name = "leaveAllV"
                    },
                    {
                        ['Title'] = 'Désincarcérer',
                        ['CustomAction'] = "action",
                        name = "opendoor"
                    },
                    {
                        ['Title'] = 'repair (HRP)',
                        ['CustomAction'] = "action",
                        name = "repair"
                    },
                    {
                        ['Title'] = 'Supprimer le véhicule (HRP)',
                        ['CustomAction'] = "deleteCar"
                    },
                    {
                        ['Title'] = 'Retour',
                        ['ReturnBtn'] = true
                    }
                }
            }
        },
        {
            ['Title'] = 'Objets',
            ['SubMenu'] = {
                ['Title'] = 'Objets',
                ['Items'] = {
                    {
                        ['Title'] = 'placer : cone',
                        ['CustomAction'] = "place",
                        name = "prop_roadcone02a"
                    },
                    {
                        ['Title'] = 'supprimer : cone',
                        ['CustomAction'] = "remove",
                        name = "prop_roadcone02a"
                    },
                    {
                        ['Title'] = 'placer : Stopped Vhc',
                        ['CustomAction'] = "place",
                        name = "prop_consign_02a"
                    },
                    {
                        ['Title'] = 'supprimer : Stopped Vhc',
                        ['CustomAction'] = "remove",
                        name = "prop_consign_02a"
                    },
                    {
                        ['Title'] = 'placer : barriere',
                        ['CustomAction'] = "place",
                        name = "prop_mp_arrow_barrier_01"
                    },
                    {
                        ['Title'] = 'supprimer : barriere',
                        ['CustomAction'] = "remove",
                        name = "prop_mp_arrow_barrier_01"
                    },
                    {
                        ['Title'] = 'placer : tente blanche',
                        ['CustomAction'] = "place",
                        name = "prop_parasol_02"
                    },
                    {
                        ['Title'] = 'supprimer : tente blanche',
                        ['CustomAction'] = "remove",
                        name = "prop_parasol_02"
                    },
                    {
                        ['Title'] = 'placer : brancard',
                        ['CustomAction'] = "place",
                        name = "prop_patio_lounger1b"
                    },
                    {
                        ['Title'] = 'supprimer : brancard',
                        ['CustomAction'] = "remove",
                        name = "prop_patio_lounger1b"
                    },
                    {
                        ['Title'] = 'Retour',
                        ['ReturnBtn'] = true
                    }
                }
            }
        },
        --[[{
            ['Title'] = 'GPS',
            ['SubMenu'] = {
                ['Title'] = 'GPS',
                ['Items'] = {
                    {
                        ['Title'] = 'Caserne',
                        ['CustomAction'] = "setGPS",
                        x = tonumber('1174.3010'),
                        y = tonumber('-1457.5612')
                    },
                    {
                        ['Title'] = 'Hopital',
                        ['CustomAction'] = "setGPS",
                        x = tonumber('403.738'),
                        y = tonumber('-1417.889')
                    },
                    {
                        ['Title'] = 'Commisariat',
                        ['CustomAction'] = "setGPS",
                        x = tonumber('426.003'),
                        y = tonumber('-980.379')
                    },
                    {
                        ['Title'] = 'FBI',
                        ['CustomAction'] = "setGPS",
                        x = tonumber('64.5357'),
                        y = tonumber('-735.898')
                    },
                    {
                        ['Title'] = 'Dépanneur',
                        ['CustomAction'] = "setGPS",
                        x = tonumber('-184.394'),
                        y = tonumber('-1293.94')
                    },
                    {
                        ['Title'] = 'Retour',
                        ['ReturnBtn'] = true
                    }
                }
            }
        },
        {
            ['Title'] = 'Radio',
            ['SubMenu'] = {
                ['Title'] = 'Radio',
                ['Items'] = {
                    {
                        ['Title'] = 'Entrer votre prénom',
                        ['Event'] = "radioLSFD_name"
                    },
                    {
                        ['Title'] = 'Retour',
                        ['ReturnBtn'] = true
                    }
                }
            }
        },]]
        {
            ['Title'] = 'Mission auto',
            ['SubMenu'] = {
                ['Title'] = 'Mission auto',
                ['Items'] = {
                    {
                        ['Title'] = 'Course hyppique',
                        ['SubMenu'] = {
                            ['Title'] = 'Course hyppique',
                            ['Items'] = {
                                {
                                    ['Title'] = "Lancer l'intervention",
                                    ['CustomAction'] = "Lauch_Mission",
                                    text = "Course hyppique",
                                    x = tonumber('1149.1'),
                                    y = tonumber('125.1')
                                },
                                {
                                    ['Title'] = 'Activer',
                                    ['CustomAction'] = "Start_Mission",
                                    nb = 1
                                },
                                {
                                    ['Title'] = 'Desactiver',
                                    ['CustomAction'] = "End_Mission",
                                    nb = 1
                                }
                            }
                        }
                    },
                    {
                        ['Title'] = 'Spécial : FBI',
                        ['SubMenu'] = {
                            ['Title'] = 'Spécial : FBI',
                            ['Items'] = {
                                {
                                    ['Title'] = "Lancer l'intervention",
                                    ['CustomAction'] = "Lauch_Mission",
                                    text = "Spécial : FBI",
                                    x = tonumber('111.1'),
                                    y = tonumber('111.1')
                                },
                                {
                                    ['Title'] = 'Activer',
                                    ['CustomAction'] = "Start_Mission",
                                    nb = 2
                                },
                                {
                                    ['Title'] = 'Desactiver',
                                    ['CustomAction'] = "End_Mission",
                                    nb = 2
                                }
                            }
                        }
                    },
                    {
                        ['Title'] = 'Maison de Lester',
                        ['SubMenu'] = {
                            ['Title'] = 'Maison de Lester',
                            ['Items'] = {
                                {
                                    ['Title'] = "Lancer l'intervention",
                                    ['CustomAction'] = "Lauch_Mission",
                                    text = "Maison de Lester",
                                    x = tonumber('1274.08'),
                                    y = tonumber('-1711.43')
                                },
                                {
                                    ['Title'] = 'Activer',
                                    ['CustomAction'] = "Start_Mission",
                                    nb = 3
                                },
                                {
                                    ['Title'] = 'Desactiver',
                                    ['CustomAction'] = "End_Mission",
                                    nb = 3
                                }
                            }
                        }
                    },
                    {
                        ['Title'] = 'Stade de foot',
                        ['SubMenu'] = {
                            ['Title'] = 'Stade de foot',
                            ['Items'] = {
                                {
                                    ['Title'] = "Lancer l'intervention",
                                    ['CustomAction'] = "Lauch_Mission",
                                    text = "Stade de foot",
                                    x = tonumber('772.01'),
                                    y = tonumber('-233.01')
                                },
                                {
                                    ['Title'] = 'Activer',
                                    ['CustomAction'] = "Start_Mission",
                                    nb = 4
                                },
                                {
                                    ['Title'] = 'Desactiver',
                                    ['CustomAction'] = "End_Mission",
                                    nb = 4
                                }
                            }
                        }
                    },
                    {
                        ['Title'] = 'AVP sur parking',
                        ['SubMenu'] = {
                            ['Title'] = 'AVP sur parking',
                            ['Items'] = {
                                {
                                    ['Title'] = "Lancer l'intervention",
                                    ['CustomAction'] = "Lauch_Mission",
                                    text = "AVP sur parking",
                                    x = tonumber('704.9'),
                                    y = tonumber('-288.9')
                                },
                                {
                                    ['Title'] = 'Activer',
                                    ['CustomAction'] = "Start_Mission",
                                    nb = 5
                                },
                                {
                                    ['Title'] = 'Desactiver',
                                    ['CustomAction'] = "End_Mission",
                                    nb = 5
                                }
                            }
                        }
                    },
                    {
                        ['Title'] = 'Terain de tennis',
                        ['SubMenu'] = {
                            ['Title'] = 'Terain de tennis',
                            ['Items'] = {
                                {
                                    ['Title'] = "Lancer l'intervention",
                                    ['CustomAction'] = "Lauch_Mission",
                                    text = "Terain de tennis",
                                    x = tonumber('485.1'),
                                    y = tonumber('-225.9')
                                },
                                {
                                    ['Title'] = 'Activer',
                                    ['CustomAction'] = "Start_Mission",
                                    nb = 6
                                },
                                {
                                    ['Title'] = 'Desactiver',
                                    ['CustomAction'] = "End_Mission",
                                    nb = 6
                                }
                            }
                        }
                    },
                    {
                        ['Title'] = 'Buisness center',
                        ['SubMenu'] = {
                            ['Title'] = 'Buisness center',
                            ['Items'] = {
                                {
                                    ['Title'] = "Lancer l'intervention",
                                    ['CustomAction'] = "Lauch_Mission",
                                    text = "Buisness center",
                                    x = tonumber('205.7'),
                                    y = tonumber('-719.9')
                                },
                                {
                                    ['Title'] = 'Activer',
                                    ['CustomAction'] = "Start_Mission",
                                    nb = 7
                                },
                                {
                                    ['Title'] = 'Desactiver',
                                    ['CustomAction'] = "End_Mission",
                                    nb = 7
                                }
                            }
                        }
                    },
                    {
                        ['Title'] = 'Cargo en feu',
                        ['SubMenu'] = {
                            ['Title'] = 'Cargo en feu',
                            ['Items'] = {
                                {
                                    ['Title'] = "Lancer l'intervention",
                                    ['CustomAction'] = "Lauch_Mission",
                                    text = "Cargo en feu",
                                    x = tonumber('-90.9'),
                                    y = tonumber('-2366.1')
                                },
                                {
                                    ['Title'] = 'Activer',
                                    ['CustomAction'] = "Start_Mission",
                                    nb = 8
                                },
                                {
                                    ['Title'] = 'Desactiver',
                                    ['CustomAction'] = "End_Mission",
                                    nb = 8
                                }
                            }
                        }
                    },
                    {
                        ['Title'] = "Stockage d'essence",
                        ['SubMenu'] = {
                            ['Title'] = "Stockage d'essence",
                            ['Items'] = {
                                {
                                    ['Title'] = "Lancer l'intervention",
                                    ['CustomAction'] = "Lauch_Mission",
                                    text = "Stockage d'essence",
                                    x = tonumber('540.8'),
                                    y = tonumber('-1846.2')
                                },
                                {
                                    ['Title'] = 'Activer',
                                    ['CustomAction'] = "Start_Mission",
                                    nb = 9
                                },
                                {
                                    ['Title'] = 'Desactiver',
                                    ['CustomAction'] = "End_Mission",
                                    nb = 9
                                }
                            }
                        }
                    },
                    {
                        ['Title'] = 'Remorque en feu',
                        ['SubMenu'] = {
                            ['Title'] = 'Remorque en feu',
                            ['Items'] = {
                                {
                                    ['Title'] = "Lancer l'intervention",
                                    ['CustomAction'] = "Lauch_Mission",
                                    text = "Remorque en feu",
                                    x = tonumber('866.1'),
                                    y = tonumber('-905.8')
                                },
                                {
                                    ['Title'] = 'Activer',
                                    ['CustomAction'] = "Start_Mission",
                                    nb = 10
                                },
                                {
                                    ['Title'] = 'Desactiver',
                                    ['CustomAction'] = "End_Mission",
                                    nb = 10
                                }
                            }
                        }
                    },
                    {
                        ['Title'] = 'Retour',
                        ['ReturnBtn'] = true
                    }
                }
            }
        }
    }
}

--[[
function updateCall(new_menu)
    -- afin d'eviter les bugs, on n'actualise pas temps que le menu est ouvert
    if Menu.isOpen == false then
        MenuMetierPompier.Items[1].SubMenu.Items = new_menu
    end
end

function updateRadio(new_menu)
    MenuMetierPompier.Items[7].SubMenu.Items = new_menu
end
]]
function openMenuPompier()
    Menu.item = MenuMetierPompier
    Menu.isOpen = true
    Menu.initMenu()
end
function openMenuGaragePompier()
    Menu.item = MenuGaragePompier
    Menu.isOpen = true
    Menu.initMenu()
end
function openMenuGarageLifeGuard()
    Menu.item = MenuGarageLifeGuard
    Menu.isOpen = true
    Menu.initMenu()
end

function openBureau (new_menu)
    Citizen.Trace("Opening menu")
    Menu.item = new_menu
    Menu.isOpen = true
    Menu.initMenu()
end

function openCustomMenu()

end

--====================================================================================
--  Option Menu
--====================================================================================
Menu.backgroundColor = { 52, 73, 94, 196 }
Menu.backgroundColorActive = {192, 57, 43, 255}
Menu.tileTextColor = {192, 57, 43, 255}
Menu.tileBackgroundColor = { 255,255,255, 255 }
Menu.textColor = { 255,255,255,255 }
Menu.textColorActive = { 255,255,255, 255 }

Menu.keyOpenMenu = 170 -- N+
Menu.keyUp = 172 -- PhoneUp
Menu.keyDown = 173 -- PhoneDown
Menu.keyLeft = 174 -- PhoneLeft || Not use next release Maybe
Menu.keyRight =	175 -- PhoneRigth || Not use next release Maybe
Menu.keySelect = 176 -- PhoneSelect
Menu.KeyCancel = 177 -- PhoneCancel
Menu.IgnoreNextKey = false
Menu.posX = 0.05
Menu.posY = 0.05

Menu.ItemWidth = 0.20
Menu.ItemHeight = 0.03

Menu.isOpen = false   -- /!\ Ne pas toucher
Menu.currentPos = {1} -- /!\ Ne pas toucher

--====================================================================================
--  Menu System
--====================================================================================

function Menu.drawRect(posX, posY, width, heigh, color)
    DrawRect(posX + width / 2, posY + heigh / 2, width, heigh, color[1], color[2], color[3], color[4])
end

function Menu.initText(textColor, font, scale)
    font = font or 0
    scale = scale or 0.35
    SetTextFont(font)
    SetTextScale(0.0,scale)
    SetTextCentre(true)
    SetTextDropShadow(0, 0, 0, 0, 0)
    SetTextEdge(0, 0, 0, 0, 0)
    SetTextColour(textColor[1], textColor[2], textColor[3], textColor[4])
    SetTextEntry("STRING")
end

function Menu.draw()
    -- Draw Rect
    local pos = 0
    local menu = Menu.getCurrentMenu()
    local selectValue = Menu.currentPos[#Menu.currentPos]
    local nbItem = #menu.Items
    -- draw background title & title
    Menu.drawRect(Menu.posX, Menu.posY , Menu.ItemWidth, Menu.ItemHeight * 2, Menu.tileBackgroundColor)
    Menu.initText(Menu.tileTextColor, 4, 0.7)
    AddTextComponentString(menu.Title)
    DrawText(Menu.posX + Menu.ItemWidth/2, Menu.posY)

    -- draw bakcground items
    Menu.drawRect(Menu.posX, Menu.posY + Menu.ItemHeight * 2, Menu.ItemWidth, Menu.ItemHeight + (nbItem-1)*Menu.ItemHeight, Menu.backgroundColor)
    -- draw all items
    for pos, value in pairs(menu.Items) do
        if pos == selectValue then
            Menu.drawRect(Menu.posX, Menu.posY + Menu.ItemHeight * (1+pos), Menu.ItemWidth, Menu.ItemHeight, Menu.backgroundColorActive)
            Menu.initText(Menu.textColorActive)
        else
            Menu.initText(value.TextColor or Menu.textColor)
        end
        AddTextComponentString(value.Title)
        DrawText(Menu.posX + Menu.ItemWidth/2, Menu.posY + Menu.ItemHeight * (pos+1))
    end

end

function Menu.getCurrentMenu()
    local currentMenu = Menu.item
    for i=1, #Menu.currentPos - 1 do
        local val = Menu.currentPos[i]
        currentMenu = currentMenu.Items[val].SubMenu
    end
    return currentMenu
end

function Menu.initMenu()
    Menu.currentPos = {1}
    Menu.IgnoreNextKey = true
end

function Menu.keyControl()
    if Menu.IgnoreNextKey == true then
        Menu.IgnoreNextKey = false
        return
    end
    if IsControlJustPressed(1, Menu.keyDown) then
        local cMenu = Menu.getCurrentMenu()
        local size = #cMenu.Items
        local slcp = #Menu.currentPos
        Menu.currentPos[slcp] = (Menu.currentPos[slcp] % size) + 1

    elseif IsControlJustPressed(1, Menu.keyUp) then
        local cMenu = Menu.getCurrentMenu()
        local size = #cMenu.Items
        local slcp = #Menu.currentPos
        Menu.currentPos[slcp] = ((Menu.currentPos[slcp] - 2 + size) % size) + 1

    elseif IsControlJustPressed(1, Menu.KeyCancel) then
        table.remove(Menu.currentPos)
        if #Menu.currentPos == 0 then
            Menu.isOpen = false
        end

    elseif IsControlJustPressed(1, Menu.keySelect)  then
        local cSelect = Menu.currentPos[#Menu.currentPos]
        local cMenu = Menu.getCurrentMenu()
        if cMenu.Items[cSelect].SubMenu ~= nil then
            Menu.currentPos[#Menu.currentPos + 1] = 1
        else
            if cMenu.Items[cSelect].ReturnBtn == true then
                table.remove(Menu.currentPos)
                if #Menu.currentPos == 0 then
                    Menu.isOpen = false
                end
            else
                if cMenu.Items[cSelect].Function ~= nil then
                    cMenu.Items[cSelect].Function(cMenu.Items[cSelect])
                end
                if cMenu.Items[cSelect].Event ~= nil then
                    TriggerEvent(cMenu.Items[cSelect].Event, cMenu.Items[cSelect])
                end
                if cMenu.Items[cSelect].CustomAction ~= nil then
                    Menu_doIt(cMenu.Items[cSelect])
                end
                if --[[cMenu.Items[cSelect].Close == nil or]] cMenu.Items[cSelect].Close == true then
                    Menu.isOpen = false
                end
            end
        end
    end

end
--[[
function do_update_dist()
    for nb,value in pairs(MenuMetierPompier.Items[1].SubMenu.Items)
        if value.SubMenu.Items[3].IsInter == true then
            local pos = GetEntityCoords(GetPlayerPed(-1), 1)
            local dist = GetDistance(pos.x, pos.y, value.SubMenu.Items[3].pox, value.SubMenu.Items[3].poy)
            MenuMetierPompier.Items[1].SubMenu.Items[nb].SubMenu.Items[3].Title = "Distance : " .. dist .. "m"
        end
    end
end
]]

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
        --if IsControlJustPressed(1, Menu.keyOpenMenu) then
        --    Menu.isOpen = false
        --end
        if Menu.isOpen then
            Menu.draw()
            Menu.keyControl()
        end

        --do_update_dist()
	end
end)
