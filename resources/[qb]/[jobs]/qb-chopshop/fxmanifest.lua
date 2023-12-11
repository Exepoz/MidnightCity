fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Lionh34rt'
description 'Chop Shopping Script for QBCore'
version '2.1'

dependencies {
    'oxmysql',
	'ox_lib'
}

files {
    'locales/*.json'
}

shared_scripts {
    '@ox_lib/init.lua',
    'shared/locales.lua',
    'shared/sh_shared.lua'
}

client_scripts {
    'client/cl_utils.lua',
    'client/cl_main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/sv_utils.lua',
    'server/sv_main.lua'
}
