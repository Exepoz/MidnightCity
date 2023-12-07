fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'CDev Development Team'
description 'An advanced premium chat resource with multiple channels and other features'
version '1.0.5'

client_scripts {
    -- Dependencies
    '@cdev_lib/shared/external.lua',
    '@cdev_lib/shared/menu.lua',

    -- Public scripts
    'public/config/config.lua',
    'public/client/api.lua',

    -- Escrowed scripts
    'client/main.lua',
    'client/manager.lua',
    'client/ui.lua',
    'client/events.lua',
    'data/languages/*.lua',
}

server_scripts {
    -- Dependencies
    '@cdev_lib/shared/external.lua',

    -- Public scripts
    'public/config/config.lua',
    'public/server/api.lua',

    -- Escrowed scripts
    'server/main.lua',
    'server/events.lua',
    'server/manager.lua',
    'data/languages/*.lua',
}

escrow_ignore {
    'public/config/config.lua',
    'public/client/api.lua',
    'public/server/api.lua',
    'data/languages/*.lua',
}

dependencies {
    '/server:4752',
    'cdev_lib',
}

files {
    'data/icons/*',
}

provide 'chat'
dependency '/assetpacks'