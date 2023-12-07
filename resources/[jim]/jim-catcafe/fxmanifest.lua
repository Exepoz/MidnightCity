name "Jim-CatCafe"
author "Jimathy"
version "1.8.6hotfix"
description "CatCafe Script By Jimathy - Props by idRP - ZenKat"
fx_version "cerulean"
game "gta5"
lua54 'yes'

shared_scripts { 'config.lua', 'shared/*.lua', 'locales/*.lua*' }
server_scripts { 'server/*.lua', }
client_scripts { '@PolyZone/client.lua', '@PolyZone/BoxZone.lua', '@PolyZone/EntityZone.lua', '@PolyZone/CircleZone.lua', '@PolyZone/ComboZone.lua', 'client/*.lua', }
escrow_ignore { '*.lua*', 'client/*.lua*', 'server/*.lua*', 'locales/*.lua*', }

file 'stream/**.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/**.ytyp'
dependency '/assetpacks'