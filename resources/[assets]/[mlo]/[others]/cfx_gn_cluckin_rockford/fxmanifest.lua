lua54 'yes'
fx_version "cerulean"
games { 'gta5' }

author 'G&N_s Studio'
description 'Cluckin Bell - Rockford Plaza'
version '1.0.0'

dependencies {
    '/server:4960',
    '/gameBuild:2189'
}

this_is_a_map 'yes'

data_file 'AUDIO_GAMEDATA' 'audio/int_gn_cluckin_game.dat'
data_file 'AUDIO_DYNAMIXDATA' 'audio/int_gn_cluckin_mix.dat'

files {
  'audio/int_gn_cluckin_game.dat151.rel',
  'audioint_gn_cluckin_mix.dat15.rel',
}

escrow_ignore {
    'stream/interior/*.ytd',
    'stream/base/*.ydr',
    'stream/base/*.ymap',
    'stream/base/*.ybn',
    'stream/meta/*.ymap'
}
dependency '/assetpacks'