fx_version 'cerulean'
game 'gta5'

name "NoPixel Inspired Oxy Run"
author "Made with love by Samuel#0008"
Version "1.6.0"

client_scripts {
	'@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
	'client/main.lua',
}

shared_scripts {
    '@sd_lib/shared/lang.lua',
    -- '@ox_lib/init.lua', -- uncomment this if you want to use the robbery mechanic
    'locales/en.lua', -- change en to your language
    'config.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
	'server/main.lua',
}

lua54 'yes'

escrow_ignore { 
    '**/*.lua', 
    'config.lua',
}
dependency '/assetpacks'