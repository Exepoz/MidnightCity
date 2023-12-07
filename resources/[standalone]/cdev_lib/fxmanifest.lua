fx_version "cerulean"
game "gta5"
lua54 "yes"

author "CDev Development Team"
description "CDev core library for resource development"
version "2.3.5"

client_scripts {
    -- Public scripts
    'shared/external.lua', -- Escrowed,
    'shared/keys.lua', -- Escrowed
    'shared/menu.lua', -- Escrowed,
    'public/config/config.lua',
    'public/config/custom/custom_config.lua',
    'public/config/qbcore/qbcore_config.lua',
    'public/config/esx/esx_config.lua',
    'shared/config_init.lua', -- Escrowed
    'public/client/api.lua',

    -- Escrowed scripts
    'client/types.lua',
    'client/nui.lua',
    'client/menu.lua',
    'client/alert.lua',
    'client/wrappers.lua',
    'client/events.lua',
    'client/tools.lua',
    'client/notification.lua',
    'client/shop.lua',

    "shared/localizer.lua",
    "data/languages/*.lua", -- Not escrowed

    "client/main.lua",
}

server_scripts {
    -- Dependencies
    "@oxmysql/lib/MySQL.lua",

    -- Public scripts
    'shared/external.lua', -- Escrowed,
    'public/config/config.lua',
    'public/config/custom/custom_config.lua',
    'public/config/qbcore/qbcore_config.lua',
    'public/config/esx/esx_config.lua',
    'shared/config_init.lua', -- Escrowed
    'public/server/api.lua',

    -- Escrowed scripts
    'server/db.lua',
    'client/wrappers.lua',
    'server/events.lua',
    'server/jobs.lua',
    'server/settings.lua',

    "shared/localizer.lua",
    "data/languages/*.lua", -- Not escrowed

    "server/main.lua",
}

escrow_ignore {
    "public/config/config.lua",
    "public/config/custom/custom_config.lua",
    "public/config/qbcore/qbcore_config.lua",
    "public/config/esx/esx_config.lua",
    "public/client/api.lua",
    "public/server/api.lua",
    "data/languages/*.lua",
}

files {
    "nui/dist/**"
}

ui_page "nui/dist/index.html"

dependencies {
    "/server:4752"
}

dependency '/assetpacks'