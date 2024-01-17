
fx_version 'cerulean'
game 'gta5'
version 'v2.1.0'

client_scripts {
    'locale/*.lua',
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

shared_scripts {
    'shared/config.lua'
}

lua54 'yes'


escrow_ignore {
    'locale/*.lua',
    'client/main.lua',
    'server/main.lua',
    'shared/config.lua'
}

dependency '/assetpacks'