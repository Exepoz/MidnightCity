fx_version "cerulean"
games { 'gta5' }

author 'G&N_s Studio'
description 'Sandy Shore Mapdata - Clinic Center + Burgershot + Sheriff Dept + Motel + Strip Mall'
version '3.0.0'

dependencies {
    '/server:4960',
    '/gameBuild:2189',
}

this_is_a_map 'yes'

escrow_ignore {
    'stream/ybn/*.ybn',
    'stream/ydr/*.ydr',
    'stream/ymap/*.ymap'
}
dependency '/assetpacks'