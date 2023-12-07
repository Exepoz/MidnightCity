fx_version 'cerulean'
games {'gta5'}

shared_script {
    'config.lua',
    'shared/*.lua',
    '@ox_lib/init.lua',
}

server_scripts {'server/*.lua', '@oxmysql/lib/MySQL.lua'}

client_scripts {'client/*.lua'}


lua54 'yes'