Config                 = {}
Config.DrawDistance    = 100.0
Config.MarkerType      = 1
Config.Locale          = 'fr'

Config.Zones = {
    FillBottle = {
    Pos   = {x = -1605.7326660156, y = 2096.3154296875, z = 64.166157531738},
    Size  = { x = 1.5, y = 1.5, z = 1.0 },
    Color = { r = 204, g = 204, b = 0 },
    Type  = 1,
  },
}


Config.Fontaine = {
  Pos = {x = 436.2,     y = -978.505,  z = 30.105},  -- Comico
  Pos = {x = 1850.250,  y = 3684.995,  z = 33.705},  -- Sheriff Sandy
  Pos = {x = -443.790,  y = 6010.95,   z = 31.105},  -- Sheriff North
  Pos = {x = 269.955,   y = -1354.295, z = 24.205},  -- Hopital
  Pos = {x = 921.205,   y = 1240.995,  z = 373.555}, -- Gouvernement
  Pos = {x = -1063.955, y = -243.455,  z = 39.155},  -- Pole emploie
  Pos = {x = -30.455,   y = -1110.155, z = 25.955},  -- Concessionaire
  Pos = {x = 251.045,   y = 207.255,   z = 105.905}, -- Banque Centrale
}

for i=1, #Config.Fontaine, 1 do
  Config.Zones['Fontaine' .. i] = {
    Pos   = Config.Fontaine[i],
    Size  = { x = 1.5, y = 1.5, z = 1.0 },
    Color = { r = 204, g = 204, b = 0 },
    Type  = 1
  }
end
