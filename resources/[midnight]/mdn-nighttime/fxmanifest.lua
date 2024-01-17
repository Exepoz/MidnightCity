fx_version 'cerulean'
games {'gta5'}

shared_script {
    'config.lua',
    '@ox_lib/init.lua',
}

server_scripts {
    'server/core.lua',
    'server/functions.lua',
    '@oxmysql/lib/MySQL.lua',
    'server/hunt.lua'
}

client_scripts {
    'client/core.lua',
    'client/functions.lua',
    'client/zones.lua',
    'client/hunt.lua',
}


lua54 'yes'