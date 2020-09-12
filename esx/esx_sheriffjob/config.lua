Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerType                 = 1
Config.MarkerSize                 = { x = 2.0, y = 2.0, z = 0.6 }
Config.MarkerColor                = { r = 136, g = 66, b = 29 }
Config.EnablePlayerManagement     = false
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = false -- only turn this on if you are using esx_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableSocietyOwnedVehicles = false
Config.EnableLicenses             = true
Config.MaxInService               = -1
Config.Locale                     = 'fr'

Config.SheriffStations = {

  sherif = {

    Blip = {
      Pos     = { x = -446.27230, y = 6013.4052, z = 31.7163 },
      Sprite  = 60,
      Display = 4,
      Scale   = 1.0,
      Colour  = 3,
    },

    Cloakrooms = {
      { x = -448.933013, y = 6012.180175, z = 30.716373 },
    },

    Vehicles = {
      {
        Spawner    = { x = -451.7637, y = 6005.796875, z = 30.830 },
        SpawnPoint = { x = -454.78030395508, y = 6000.9672, z = 30.3405 },
        Heading    = 90.0,
      }
    },

    Helicopters = {
      {
        Spawner      = { x = -447.214, y = 6001.299, z = 30.685},
        SpawnPoint   = { x = -474.822, y = 5989.203, z = 30.336},
        Heading      = 0.0,
      }
    },

    VehicleDeleters = {
      { x = -461.173889, y = 6047.377441, z = 30.340528 },
      { x = -458.132647, y = 6044.204101, z = 30.340528 },
      { x = -454.976790, y = 6040.916992, z = 30.340528 },
      { x = -474.822,    y = 5989.203,    z = 30.336}, -- Helico
    },
  },
}
