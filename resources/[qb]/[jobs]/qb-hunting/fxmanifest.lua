fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Lionh34rt'
description 'Hunting script for QBCore'
version '2.0'

dependencies {
    'ox_lib'
}

files {
    'locales/*.json'
}

shared_scripts {
    '@ox_lib/init.lua',
    'shared/sh_config.lua',
    'shared/locales.lua'
}

client_scripts {
    'client/cl_utils.lua',
    'client/cl_main.lua',
    'client/cl_aimblock.lua'
}

server_scripts {
    'server/sv_utils.lua',
    'server/sv_main.lua',
}
