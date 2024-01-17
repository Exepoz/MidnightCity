name 'Jixel-CluckinBell'
author 'Taylor'
version '2.0.4'
description 'CluckinBell Script By Taylor'
fx_version 'cerulean'
game 'gta5'

data_file 'DLC_ITYP_REQUEST' 'stream/*.ytyp'

shared_scripts {
    'config.lua',
    'escrowed/shared.lua',
    'shared/*.lua',
    'locations/*.lua',
    'locales/*.lua',
}

server_scripts {
    'server/*.lua',
    'escrowed/vercheck.lua',
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/*.lua',
    'ui/main.lua',
}

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'stream/*.ytyp',
}

lua54 'yes'

escrow_ignore {
    'ui/main.lua',
    'config.lua',
    'client/*.lua',
    'locations/*.lua',
    'server/*.lua',
    'locales/*.lua',
    'shared/*.lua',
}

dependency '/assetpacks'

dependency '/assetpacks'