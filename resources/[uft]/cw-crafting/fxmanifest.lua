
fx_version 'adamant'
game 'gta5'

author 'Coffeelot and Wuggie'
description 'CW crafting system'
version '1.69'

lua54 'yes'

client_scripts{
    'config.lua',
    'client/*.lua',
}

server_scripts{
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server/*.lua',
}

shared_scripts {
    'config.lua','@ox_lib/init.lua',
}

exports {
    'giveRandomBlueprint',
    'giveBlueprintItem',
}

dependency 'oxmysql'

