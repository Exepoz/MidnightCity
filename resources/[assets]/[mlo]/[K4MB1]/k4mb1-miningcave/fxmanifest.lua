lua54 'yes'

fx_version 'cerulean'
game 'gta5'

this_is_a_map 'yes'

files {
      'stream/k4mb1_caveprops.ytyp'
}

data_file 'DLC_ITYP_REQUEST' 'stream/k4mb1_caveprops.ytyp'
dependency '/assetpacks'

client_scripts {
	'client.lua'
}

escrow_ignore {
  'client.lua',  -- Only ignore one file
  'stream/extra/*.ydr'   -- Ignore all .ydr files in any subfolder
}
dependency '/assetpacks'