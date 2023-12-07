fx_version 'cerulean'
games {'gta5'}

shared_script {
    'config.lua',
    '@ox_lib/init.lua',
}

server_scripts {'@oxmysql/lib/MySQL.lua', 'server/*.lua'}

client_scripts {'client/*.lua'}


lua54 'yes'