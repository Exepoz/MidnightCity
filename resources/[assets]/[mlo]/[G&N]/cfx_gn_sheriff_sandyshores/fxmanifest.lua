fx_version "cerulean"
games { 'gta5' }

author 'G&N_s Studio'
description 'Sheriff_Sandy_Shores'
version '1.1.0'

dependencies {
    '/server:4960',
    '/gameBuild:2189',
    'cfx_gn_sheriff_dlc',
    'cfx_gn_sandy_mapdata'
  }

this_is_a_map 'yes'

escrow_ignore {
  'stream/unlock_file/*.ydr'
}
dependency '/assetpacks'