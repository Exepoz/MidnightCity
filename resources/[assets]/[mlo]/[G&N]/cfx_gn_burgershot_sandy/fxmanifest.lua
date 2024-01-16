lua54 'yes'
fx_version "cerulean"
games { 'gta5' }

author 'G&N_s Studio'
description 'Sandy BurgerShot'
version '2.0.0'

dependencies {
    '/server:4960',
    '/gameBuild:2189',
    'cfx_gn_sandy_mapdata',
    'cfx_gn_collection',
    'cfx_gn_burgershot_int'
}

this_is_a_map 'yes'

client_script {
    'gn_bs_sandy_entityset.lua',
}
escrow_ignore {
    'stream/base/*.ydr',
}
dependency '/assetpacks'