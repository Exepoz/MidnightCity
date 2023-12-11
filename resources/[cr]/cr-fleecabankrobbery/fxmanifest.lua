fx_version "cerulean"
game "gta5"

name "QBCore Fleeca Bank Robbery"
author "Constant Development"
description "Fleeca Bank Robbery for Gabz and K4MB1's Fleeca Bank MLOs"
version '1.5.1'

ui_page 'html/index.html'

shared_scripts {
    '@ox_lib/init.lua',
    -- Un-Comment the line above to enable ox_lib
    'config.lua',
    'locales/en.lua', -- Change this to your preffered language. (Currently en.lua or fr.lua)
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
    'server/sv_extra.lua',
    'server/sync.lua',
    'server/sv_main.lua',
}

files {
    'html/index.html',
    'html/script.js',
    'html/style.css',
    'html/reset.css'
}

escrow_ignore {
    'client/cl_extra.lua',
    'client/cl_targets.lua',
    'client/cl_framework.lua',
    'client/drilling.lua',
    'server/sv_extra.lua',
    'server/sv_framework.lua',
    'config.lua',
    'README.md',
    'fxmanifest.lua',
    'locales/*',
    'doorlocks/qb-doorlock/*.lua',
    'doorlocks/nui_doorlock/*.lua',
}

lua54 'yes'
dependency '/assetpacks'