fx_version 'adamant'
games { 'gta5' }

author 'NVE Team'
description 'nopixel 4.0 - Vehicle Overhaul'
version '1.0.0'

this_is_a_map 'yes'

lua54 'yes'
  
files {
	'stream/meta_files/blista2/carcols.meta',
	'stream/meta_files/blista2/carvariations.meta',
	'stream/meta_files/boxville2/carvariations.meta',
	'stream/meta_files/buffalo4/vehicles.meta',
	'stream/meta_files/bus/carvariations.meta',
}

data_file 'CARCOLS_FILE' 'stream/meta_files/blista2/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'stream/meta_files/blista2/carvariations.meta'
data_file 'VEHICLE_VARIATION_FILE' 'stream/meta_files/boxville2/carvariations.meta'
data_file 'VEHICLE_METADATA_FILE' 'stream/meta_files/buffalo4/vehicles.meta'
data_file 'VEHICLE_VARIATION_FILE' 'stream/meta_files/bus/carvariations.meta'

escrow_ignore {
  'stream/**/*.ytd'
}
dependency '/assetpacks'