fx_version 'cerulean'
game 'gta5'

author 'Grudge & Snipe'
description 'Script for Planting Weed Plants anywhere in the soil'
version '1.1.0'

lua54 'yes'

ui_page "html/index.html"

shared_scripts{
	'@ox_lib/init.lua',
	'config.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua',
	'server/server_customise.lua',
}

client_scripts {
	'@PolyZone/client.lua', -- Remove if you don't use PolyZone
    '@PolyZone/BoxZone.lua', -- Remove if you don't use PolyZone
    '@PolyZone/ComboZone.lua', -- Remove if you don't use PolyZone
    '@PolyZone/EntityZone.lua', -- Remove if you don't use PolyZone
	'client/main.lua',
}

files {
    'html/index.html',
    'html/assets/css/*.css',
    'html/assets/js/*.js',
}

-- data_file 'DLC_ITYP_REQUEST' 'stream/bzzz_prop_plant_weed_pot.ytyp'
-- data_file 'DLC_ITYP_REQUEST' 'stream/bzzz_plants_weed_props.ytyp'

escrow_ignore{
	'config.lua',
	'client/main.lua',
	'server/main.lua',
	'server/server_customise.lua',
}
dependency '/assetpacks'