Config                            = {}
Config.DrawDistance               = 100.0
Config.Locale                     = 'fr'

Config.Zones = {
  -- SHOPS

  Flacons = {
    Pos   = { x = -2955.242, y = 385.897, z = 14.041 },
    Size  = { x = 1.6, y = 1.6, z = 1.0 },
    Color = { r = 238, g = 0, b = 0 },
    Type  = 23,
    Items = {
      { name = 'jager',      label = 'Jägermeister',  price = 3 },
      { name = 'vodka',      label = 'Vodka',         price = 4 },
      { name = 'rhum',       label = 'Rhum',          price = 2 },
      { name = 'whisky',     label = 'Whisky',        price = 7 },
      { name = 'tequila',    label = 'Tequila',       price = 2 },
      { name = 'martini',    label = 'Martini blanc', price = 5 }
    },
  },

  NoAlcool = {
    Pos   = { x = 178.028, y = 307.467, z = 104.392 },
    Size  = { x = 1.6, y = 1.6, z = 1.0 },
    Color = { r = 238, g = 110, b = 0 },
    Type  = 23,
    Items = {
      { name = 'soda',        label = 'Soda',          price = 4 },
      { name = 'jusfruit',    label = 'Jus de fruits', price = 3 },
      { name = 'icetea',      label = 'Ice Tea',       price = 4 },
      { name = 'energy',      label = 'Energy Drink',  price = 7 },
      { name = 'drpepper',    label = 'Dr. Pepper',    price = 2 },
      { name = 'limonade',    label = 'Limonade',      price = 1 }
    },
  },

  Apero = {
    Pos   = { x = 98.675, y = -1809.498, z = 26.095 },
    Size  = { x = 1.6, y = 1.6, z = 1.0 },
    Color = { r = 142, g = 125, b = 76 },
    Type  = 23,
    Items = {
      { name = 'bolcacahuetes',   label = 'Bol de cacahuètes',    price = 7 },
      { name = 'bolnoixcajou',    label = 'Bol de noix de cajou', price = 10 },
      { name = 'bolpistache',     label = 'Bol de pistache',      price = 15 },
      { name = 'bolchips',        label = 'Bol de chips',         price = 5 },
      { name = 'saucisson',       label = 'Saucisson',            price = 25 },
      { name = 'grapperaisin',    label = 'Grappe de raisin',     price = 15 }
    },
  },
}
