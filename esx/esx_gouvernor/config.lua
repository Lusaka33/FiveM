Config              							= {}
Config.DrawDistance 							= 100.0

Config.MarkerColor  							= {r = 120, g = 120, b = 240}
Config.EnableSocietyOwnedVehicles = false
Config.EnablePlayerManagement     = true
Config.EnableVaultManagement      = true
Config.EnableHelicopters          = true
Config.MaxInService               = -1
Config.Locale 										= 'fr'

Config.AuthorizedVehicles = {
  { name = 'schafter2',  label = 'Berline' },
}

Config.Blips = {

	Blip = {
		Pos     = { x = -418.589, y = 1151.792, z = 326.873 },
		Sprite  = 419,
		Display = 4,
		Scale   = 0.9,
		Colour  = 37,
	},
}

Config.Zones = {

	Cloakrooms = { --Vestaire
		Pos   = {x = -412.4992, y = 1111.2126, z = 324.8664},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 0, g = 204, b = 3},
		Type  = 1
	},

	Vaults = {
		Pos   = { x = 93.406, y = -1291.753, z = 28.288 },
		Size  = { x = 1.3, y = 1.3, z = 1.0 },
		Color = { r = 30, g = 144, b = 255 },
		Type  = 1,
	},

	Vehicles = {
		Pos          = { x = -404.450, y = 1076.162, z = 322.887 },
		SpawnPoint   = { x = -406.800, y = 1062.834, z = 322.841 },
		Size         = { x = 1.8, y = 1.8, z = 1.0 },
		Color        = { r = 255, g = 255, b = 0 },
		Type         = 1,
		Heading      = 207.43,
	},

	VehicleDeleters = {
		Pos   = { x = -406.800, y = 1062.834, z = 322.841 },
		Size  = { x = 3.0, y = 3.0, z = 0.2 },
		Color = { r = 255, g = 255, b = 0 },
		Type  = 1,
	},

	Helicopters = {
		Pos          = {x = -445.760, y = 1093.718, z = 331.538},
		SpawnPoint   = {x = -447.218, y = 1107.4344, z = 331.5314},
		Size         = { x = 1.8, y = 1.8, z = 1.0 },
		Color        = { r = 255, g = 255, b = 0 },
		Type         = 1,
		Heading      = 291.4347,
	},

	HelicopterDeleters = {
		Pos   = {x = -447.218, y = 1107.060, z = 331.5314},
		Size  = { x = 3.0, y = 3.0, z = 0.2 },
		Color = { r = 255, g = 255, b = 0 },
		Type  = 1,
	},

	BossActions = {
		Pos   = {x = -449.4055, y = -339.9173, z = 90.0076},
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Color = { r = 0, g = 100, b = 0 },
		Type  = 1,
	},
}

-- TELEPORTERS
Config.TeleportZones = {
  EnterBuilding = {
    Pos       = {x = -429.0690612793, y = 1110.7834472656, z = 326.69631958008},
    Size      = { x = 1.2, y = 1.2, z = 0.1 },
    Color     = { r = 128, g = 128, b = 128 },
    Marker    = 1,
    Blip      = false,
    Name      = "Héliport : entrée",
    Type      = "teleport",
    Hint      = "Appuyez sur ~INPUT_PICKUP~ pour monter sur le toit.",
    Teleport  = {x = -434.96423339844, y = 1089.8627929688, z = 331.53582763672},
  },

  ExitBuilding = {
    Pos       = {x = -434.96423339844, y = 1089.8627929688, z = 331.53582763672},
    Size      = { x = 1.2, y = 1.2, z = 0.1 },
    Color     = { r = 128, g = 128, b = 128 },
    Marker    = 1,
    Blip      = false,
    Name      = "Héliport : sortie",
    Type      = "teleport",
    Hint      = "Appuyez sur ~INPUT_PICKUP~ pour descendre dans les bureaux.",
    Teleport  = {x = -429.0690612793, y = 1110.7834472656, z = 326.69631958008},
  },


  EnterHeliport = {
    Pos       = {x = -459.17309570313, y = -338.62091064453, z = 90.007537841797},
    Size      = { x = 2.0, y = 2.0, z = 0.2 },
    Color     = {x = -429.0690612793, y = 1111.2126464844, z = 331.53558349609},
    Marker    = 1,
    Blip      = false,
    Name      = "Gouvernement : entrée",
    Type      = "teleport",
    Hint      = "Appuyez sur ~INPUT_PICKUP~ pour monter sur le toit.",
    Teleport  = { x = -65.944, y = -818.589, z =  320.801 }
  },

  ExitHeliport = {
    Pos       = {x = -429.0690612793, y = 1111.2126464844, z = 331.53558349609},
    Size      = { x = 2.0, y = 2.0, z = 0.2 },
    Color     = { r = 204, g = 204, b = 0 },
    Marker    = 1,
    Blip      = false,
    Name      = "Gouvernement : sortie",
    Type      = "teleport",
    Hint      = "Appuyez sur ~INPUT_PICKUP~ pour descendre dans les bureaux.",
    Teleport  = {x = -459.17309570313, y = -338.62091064453, z = 90.007537841797},
  },
}
