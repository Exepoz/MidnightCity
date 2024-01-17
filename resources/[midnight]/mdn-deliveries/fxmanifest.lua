fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'Kloud Development'
description 'Advanced Fast Food Delivery by Kloud Development'
discord 'https://discord.gg/DbqC2SWzJk'

version '1.0.1'


shared_scripts {
    '@ox_lib/init.lua',
    'shared/*.lua',
    'target/*.lua'
}

client_scripts {
    'init.lua',
    'modules/**/*.lua',
    'framework/client/**.lua',
    'inventory/client/**.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua',
    'framework/server/**.lua',
    'inventory/server/**.lua'
}

files {
    "locales/*.json"
}
dependencies {
    'oxmysql',
    'ox_lib'
}