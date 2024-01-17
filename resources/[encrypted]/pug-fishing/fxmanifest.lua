lua54 'yes'
fx_version 'cerulean'
game 'gta5'

author 'Pug'
description 'Discord: Pug#8008'
version '1.4.1'

dependencies {
    "PolyZone"
}

client_script {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    '@ox_lib/init.lua', -- This can be hashed out if you are not using ox_lib
    'client/client.lua',
    'client/open.lua',
}

server_script {
    '@oxmysql/lib/MySQL.lua',
	'server/server.lua',
    'server/sv_open.lua',
}

shared_script {
    'config.lua',
    'locales/en.lua'
}

ui_page 'html/index.html'

files {
    'html/*.html',
    'html/*.css',
    'html/*.js',
    'html/img/*'
}

-- 'client/client.lua',
-- 'server/server.lua',

escrow_ignore {
    'config.lua',
    'client/open.lua',
    'server/sv_open.lua',
    'locales/en.lua',
    'minigames/qb-lock/client/client.lua',
    'minigames/qb-skillbar/client/main.lua',
}
dependency '/assetpacks'