fx_version "cerulean"
games { 'gta5' }

author 'G&N_s Studio'
description 'Sandy Shores - Strip Mall'
version '1.0.2'

dependencies {
  '/server:4960',
  '/gameBuild:2189',
  'cfx_gn_collection',
  'cfx_gn_sandy_mapdata'
}

this_is_a_map 'yes'

data_file 'AUDIO_GAMEDATA' 'audio/bettercall_game.dat'
data_file 'TIMECYCLEMOD_FILE' 'gn_bettercall_timecycle.xml'

files {
  'audio/bettercall_game.dat151.rel',
  'gn_bettercall_timecycle.xml',
}

escrow_ignore {
  'stream/int_better_call/*.ytd',
  'stream/stripmall/*.ytd'
}
dependency '/assetpacks'