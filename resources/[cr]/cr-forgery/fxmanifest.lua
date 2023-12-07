-- Copyright (C) 2022 Constant Development

fx_version 'cerulean'
game 'gta5'

author 'Constant Development'
description 'Forgery System for QBCore'
version '1.0.4'

shared_scripts {
    '@ox_lib/init.lua',
    -- Un-Comment the line above to enable ox_lib
    'config.lua',
    'locales/en.lua'
}

client_scripts {
    'client/cl_extras.lua',
    'client/cl_main.lua',
}

server_scripts {
    'server/sv_extras.lua',
    'server/sv_main.lua',
}

dependencies {
    'qb-core',
    'qb-target',
    'qb-input',
}

escrow_ignore {
    'client/cl_extras.lua',
    'config.lua',
    'README.md',
    'fxmanifest.lua'
}

lua54 'yes'