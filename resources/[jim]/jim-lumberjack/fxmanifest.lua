name "Jim-LumberJack"
author "Jimathy"
version "1.2.4"
description "LumberJack Script By Jimathy"
fx_version "cerulean"
game "gta5"
lua54 'yes'

shared_scripts { 'config.lua', 'locales/*.lua', 'shared/*.lua' }
server_scripts { 'server/*.lua' }
client_scripts { '@PolyZone/client.lua', '@PolyZone/BoxZone.lua', '@PolyZone/EntityZone.lua', '@PolyZone/CircleZone.lua', '@PolyZone/ComboZone.lua', 'client/*.lua', }
escrow_ignore { '*.lua', 'client/*.lua', 'server/*.lua', 'locales/*.lua', 'shared/recipes.lua' }
dependency '/assetpacks'