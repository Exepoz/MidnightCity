-- Copyright (C) 2022 Constant Development

fx_version 'cerulean'
game 'gta5'

author 'Constant Development'
description 'BurnerPhones for QBCore & ESX'
version '1.4.1'

shared_scripts {
    --'@ox_lib/init.lua',
    -- Un-Comment the line above to enable ox_lib
    'config.lua',
    'locales/en.lua',
}

client_scripts {
    'client/cl_framework.lua',
    'client/cl_extras.lua',
    'client/main.lua'
}

server_scripts {
    'server/sv_framework.lua',
    'server/main.lua'
}

escrow_ignore {
    'config.lua',
    'README.md',
    'client/cl_framework.lua',
    'server/sv_framework.lua',
    'client/cl_extras.lua',
    'client/sv_extras.lua',
    'fxmanifest.lua'
}
lua54 'yes'