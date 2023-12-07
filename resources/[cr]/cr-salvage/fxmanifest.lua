-- Copyright (C) 2022 Constant Development
fx_version 'cerulean'
game 'gta5'

author 'Constant Development'
description 'Salvage System for FiveM QBCore & ESX'
version '1.2.3'

shared_scripts {
    -- '@ox_lib/init.lua',
    -- Un-Comment the line above to enable ox_lib
    'config.lua',
    'locales/en.lua', -- Change this to the desired language file (Only 1 at a time.)
}

client_scripts {
    '@PolyZone/client.lua', -- Remove if you don't use PolyZone
    '@PolyZone/BoxZone.lua', -- Remove if you don't use PolyZone
    '@PolyZone/ComboZone.lua', -- Remove if you don't use PolyZone
    '@PolyZone/EntityZone.lua', -- Remove if you don't use PolyZone
    'client/cl_framework.lua',
    'client/cl_extras.lua',
    'client/cl_targets.lua',
    'client/cl_main.lua',
}

server_scripts {
    'server/sv_framework.lua',
    'server/sv_extras.lua',
    'server/sv_main.lua',
}

escrow_ignore {
    'config.lua',
    'README.md',
    'SQL/*.sql',
    'server/sv_extras.lua',
    'server/sv_framework.lua',
    'client/cl_extras.lua',
    'client/cl_framework.lua',
    'client/cl_targets.lua',
    'fxmanifest.lua',
    'locales/*.lua'
}

lua54 'yes'