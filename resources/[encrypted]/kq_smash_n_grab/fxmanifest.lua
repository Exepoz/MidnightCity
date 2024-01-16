fx_version 'cerulean'
games      { 'gta5' }
lua54 'yes'

author 'KuzQuality | Kuzkay'
description 'Smash n grab by KuzQuality'
version '1.2.0'

--
-- Server
--

server_scripts {
    'config.lua',
    'locale.lua',
    'server/server.lua',
    'server/editable/esx.lua',
    'server/editable/qb.lua',
}

--
-- Client
--

client_scripts {
    'config.lua',
    'locale.lua',
    'client/functions.lua',
    'client/cache.lua',
    'client/client.lua',
    'client/editable/client.lua',
    'client/editable/dispatch.lua',
    'client/editable/esx.lua',
    'client/editable/qb.lua',
}

escrow_ignore {
    'config.lua',
    'locale.lua',
    'client/editable/*.lua',
    'server/editable/*.lua',
}

dependency '/assetpacks'