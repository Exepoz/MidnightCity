fx_version "cerulean"
game "gta5"

name "QBCore Paleto Bank Robbery"
author "Constant Development"
description "Paleto Bank Robbery using Gabz, & K4MB1's Paleto Bank"
version '1.0.0'

ui_page 'html/index.html'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'locales/en.lua',
    'sounds/*',
}

client_scripts {
    'client/cl_framework.lua',
    'client/cl_extra.lua',
    'client/cl_targets.lua',
    'client/drilling.lua',
    'client/cl_main.lua'
}

server_scripts {
    'server/sv_framework.lua',
    'server/sv_main.lua'
}

files {
    'html/index.html',
    'html/script.js',
    'html/style.css',
    'html/reset.css'
}

escrow_ignore {
    'server/sv_framework.lua',
    'client/cl_framework.lua',
    'client/cl_extra.lua',
    'client/cl_targets.lua',
    'client/drilling.lua',
    'doorlocks/qb-doorlock/*.lua',
    'config.lua',
    'README.md',
    'fxmanifest.lua',
    'locales/*',
}

dependencies {'ox_lib',}

lua54 'yes'
dependency '/assetpacks'