fx_version 'cerulean'
game 'gta5'

description 'an-TowJob'
version '1.0.0'

shared_scripts {
    'config.lua',
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
}

client_script 'client/*.lua'
server_script 'server/*.lua'

lua54 'yes'
