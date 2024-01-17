fx_version 'cerulean'
games      { 'gta5' }
lua54 'yes'

author 'Prime Developments | Swizz'
description 'Cleaning script by Prime Developments'
version '1.3.3'
--
-- Server
--

server_scripts {
    'locale/local.lua',
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'server/server.lua',
    'server/editable/esx.lua',
    'server/editable/qb.lua'
}

--
-- Client
--

client_scripts {
    'locale/local.lua',
    'config.lua',
    'client/editable/qb.lua',
    'client/editable/esx.lua',
    'client/client.lua',
    'client/editable/policeAlert.lua',
}

escrow_ignore {
    'server/editable/*.lua',
    'client/editable/*.lua',
    'config.lua',
    'database.sql',
    'stream/*',
    'locale/*.lua',
}
dependency '/assetpacks'