fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Samuel#0008 & ZF Labo'
description 'Advanced Beekeeping System for QBCore and ESX'
Version '1.0.4'

client_script 'client/*.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    '@sd_lib/shared/lang.lua',
    'locales/en.lua', -- change en to your language
    'config.lua'
}

escrow_ignore { 
    '**/*.lua',  
    'config.lua',
}

dependency '/assetpacks'