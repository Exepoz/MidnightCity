fx_version 'cerulean'
game 'gta5'

Author 'Samuel#0008'
Version '1.5.5'

client_scripts {
    '@PolyZone/client.lua',
    'client/*.lua',
}

shared_scripts {
    '@sd_lib/shared/lang.lua',
    'locales/en.lua', -- change en to your language
    'config.lua',
}

server_scripts {
    'server/*.lua',
} 

lua54 'yes'

escrow_ignore { 
    '**/*.lua', 
    'config.lua',
    'doorlock/qb-nui_doorlock/*.lua',
}
dependency '/assetpacks'