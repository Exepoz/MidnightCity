name "jixel-farming"
author "Taylor"
version "2.5.2"
description "Farming Script by Taylor, Zero, and Jim"
fx_version "cerulean"
game "gta5"
lua54 'yes'

shared_scripts {
    'configs/*.lua',
    'escrowed/functions.lua',
    'shared/utils.lua',
    'locales/*.lua*',
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/*.lua',
    'escrowed/cl_main.lua'
}

server_scripts {
    'server/*.lua',
    'escrowed/sv_main.lua',
    'shared/vercheck.lua'
}
escrow_ignore {
    '*.lua*',
    'content/*.lua',
    'configs/*.lua',
    'client/*.lua',
    'server/*.lua',
    'locales/*.lua*',
    'shared/utils.lua',
    'install/**.lua',
    'install/**/*.lua'
}

dependency '/assetpacks'