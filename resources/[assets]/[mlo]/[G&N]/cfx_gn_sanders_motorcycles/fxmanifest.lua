fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

author 'G&N_s Studio'
description 'Sanders Motorcycles'
version '5.0.0'

dependencies {
  '/server:4960',
  '/gameBuild:2189',
  'cfx_gn_collection'
}

this_is_a_map 'yes'

client_script 'entityset_color.lua'

data_file 'AUDIO_GAMEDATA' 'audio/sanders_game.dat'

files {
  'audio/sanders_game.dat151.rel'
}

escrow_ignore {
  'stream/replace/*.ydr',
  'stream/replace/*.ybn',
  'stream/replace/*.ydd',
  'stream/replace/*.ymap'
}

dependency '/assetpacks'