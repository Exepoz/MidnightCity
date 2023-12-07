resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'
fx_version 'cerulean'
version '1.0.0'
this_is_a_map 'yes'
games { 'gta5' }
lua54 'yes'

client_scripts {
	'chiraq_dist_scenario.lua',
}

file "sp_manifest.ymt"
data_file "SCENARIO_POINTS_OVERRIDE_PSO_FILE" "sp_manifest.ymt"


files {
	'scenario.meta',
	'plchicago_scenario.dat'
}

data_file 'FIVEM_LOVES_YOU_4B38E96CC036038F' 'scenario.meta'
dependency '/assetpacks'