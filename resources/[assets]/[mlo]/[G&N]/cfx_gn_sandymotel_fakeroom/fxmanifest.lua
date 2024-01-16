fx_version "cerulean"
games { 'gta5' }

author 'G&N_s Studio'
description 'Sandy Shores Motel - FakeRoom'
version '2.0.0'

dependencies {
  '/server:4960',
  '/gameBuild:2189',
  'cfx_gn_collection',
  'cfx_gn_sandy_mapdata'
}

this_is_a_map 'yes'

data_file 'AUDIO_GAMEDATA' 'audio/sm_lobby_game.dat'
data_file 'AUDIO_GAMEDATA' 'audio/sandymotel_game.dat'
--data_file 'AUDIO_GAMEDATA' 'audio/room_game.dat'

files {
  'audio/sm_lobby_game.dat151.rel',
  'audio/sandymotel_game.dat151.rel',
  --'audio/room_game.dat151.rel',
}

escrow_ignore {
  'stream/interior/*.ytd'
}
dependency '/assetpacks'