Config = Config or {}
Config.Moonshine = {}

Config.Moonshine.Grapes = {
    ['mplum'] = "Plum",
    ['mgrape'] = "Marlow",
    ['mgrape2'] = "Sauvignon",
    ['mgrape3'] = "Pinot",
    ['mgrape4'] = "Cabarnet",
}

Config.Moonshine.WineRecipes = {
    ['uncork']        = { ['mplum'] = 100,    ['sugar'] = 100,    ['yeast'] = 5, label =  'Uncork & Unwind'},
    ['cabalspec']     = { ['mgrape'] = 200,   ['sugar'] = 150,    ['yeast'] = 20, label =  'The Cabal Special' },
    ['wineotaur']     = { ['mgrape3'] = 110,  ['sugar'] = 76,     ['yeast'] = 10, label =  'Wine-otaur'},
    ['grapescape']    = { ['mgrape4'] = 80,   ['sugar'] = 120,    ['yeast'] = 12, label =  'The Grape Escape' },
    ['sauvignon']     = { ['mgrape2'] = 130,  ['sugar'] = 50,     ['yeast'] = 8, label =  'Sauvignon Blanc-out'},
}