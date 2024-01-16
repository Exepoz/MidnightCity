fx_version "cerulean"
games { 'gta5' }

author 'G&N_s Studio'
description 'Sheriff_Department_DLC'
version '1.3.0'

dependencies {
  '/server:4960',
  '/gameBuild:2189',
  'cfx_gn_collection'
}

this_is_a_map 'yes'

data_file 'AUDIO_GAMEDATA' 'audio/gn_sheriff_door_game.dat'
data_file 'AUDIO_GAMEDATA' 'audio/sheriff_game.dat'
data_file 'TIMECYCLEMOD_FILE' 'gn_sheriff_timecycle.xml'

files {
  'audio/gn_sheriff_door_game.dat151.rel',
  'audio/sheriff_game.dat151.rel',
  'gn_sheriff_timecycle.xml',
}

escrow_ignore {
  'stream/unlock_file/interior/*.ytd',
  'stream/unlock_file/interior/*.ydr',
  'stream/unlock_file/interior/sandy/*.ytd',
  'stream/unlock_file/interior/sandy/*.ydr',
  'stream/unlock_file/interior/davis/*.ytd',
  'stream/unlock_file/interior/davis/*.ydr',
  'stream/unlock_file/exterior/*.ytd',
  'stream/unlock_file/exterior/*.ydr',
}
dependency '/assetpacks'