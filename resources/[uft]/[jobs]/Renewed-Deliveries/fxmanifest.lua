fx_version 'cerulean'
game 'gta5'

description 'Renewed Delivery Script'
version '1.0.0'

lua54 'yes' -- Add in case you want to use lua 5.4 (https://www.lua.org/manual/5.4/manual.html)

shared_script {
    "@qb-shops/config.lua",
    'shared/*.lua'
}

client_scripts {
    --'@ox_lib/init.lua', -- Remove if not using ox_lib
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/*.lua' -- Globbing method for multiple files
}

server_scripts {
    'server/*.lua' -- Globbing method for multiple files
}

escrow_ignore {
    'client/*.lua',
    'server/*.lua',
    'shared/*.lua',
    '*.*'
}
dependency '/assetpacks'
dependency '/assetpacks'