fx_version 'cerulean'
games { 'gta5' }

author 'AS MLO - Azzox X Swarex'
description 'AS MLO Rex Diner & Al\'s Garage'
version '1.2'
lua54 'yes'
replace_level_meta 'gta5'
this_is_a_map 'yes'

client_script 'staticEmitter.lua'

files { "sp_manifest.ymt",
        "staticEmitter.lua",
        "audio/as_rex_diner_game.dat151.rel",
        "audio/as_rex_garage_game.dat151.rel",
	    "gta5.meta",
 	    "as_rex_doortuning.ymt"
}

data_file "SCENARIO_POINTS_OVERRIDE_PSO_FILE" "sp_manifest.ymt"
data_file "AUDIO_GAMEDATA" "audio/as_rex_diner_game.dat"
data_file "AUDIO_GAMEDATA" "audio/as_rex_garage_game.dat"

escrow_ignore {
    'stream/**/*.ytd',
    'stream/**/*.ymap',
    'stream/**/*.ybn',
    'stream/**/*.ynv',
    'stream/**/*.ymt',
    'stream/**/*.ytyp'
}
dependency '/assetpacks'