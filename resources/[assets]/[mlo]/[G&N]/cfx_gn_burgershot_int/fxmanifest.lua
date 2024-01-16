fx_version "cerulean"
games { 'gta5' }

author 'G&N_s Studio'
description 'BurgerShot Int'
version '1.0.0'

dependencies {
    '/server:4960',
    '/gameBuild:2189',
    'cfx_gn_collection'
}

this_is_a_map 'yes'

data_file 'AUDIO_GAMEDATA' 'audio/gnstudio_game.dat'
data_file 'TIMECYCLEMOD_FILE' 'gn_burgershot_timecycle.xml'

files {
  'audio/gnstudio_game.dat151.rel',
  'gn_burgershot_timecycle.xml',
}
dependency '/assetpacks'