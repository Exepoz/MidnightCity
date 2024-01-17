fx_version 'cerulean'
game 'gta5'

description 'wert-ambulancejob'
version '1.0.0'

ui_page {'html/index.html'}

files {
	'data.json',
    'html/index.html',
    'html/js/*',
    'html/css/*',
    'html/images/*.png',
}

shared_scripts {
    'config.lua',
    'lang.lua',
    '@ox_lib/init.lua',
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
	'client.lua',
    'target.lua',
    'garage.lua',
    'npcdoctor.lua',
    'blood.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
	'server.lua',
}

escrow_ignore {
    'data.json',
    'html/index.html',
    'html/js/*',
    'html/css/*',
    'client.lua',
    'target.lua',
    'garage.lua',
    'npcdoctor.lua',
    'blood.lua',
    'config.lua',
    'lang.lua',
    'server.lua',
}

lua54 'yes'
dependency '/assetpacks'