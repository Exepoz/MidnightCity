name "Jim-Mechanic"
author "Jimathy"
version "3.2.3"
description "Mechanic Script By Jimathy"
fx_version "cerulean"
game "gta5"
lua54 'yes'

shared_scripts { 'config.lua', 'locales/*.lua', 'shared/*.lua', }
client_scripts { '@PolyZone/client.lua', '@PolyZone/BoxZone.lua', '@PolyZone/EntityZone.lua', '@PolyZone/CircleZone.lua', '@PolyZone/ComboZone.lua', 'client/*.lua', 'html/drawtext.lua', }
server_scripts { '@oxmysql/lib/MySQL.lua', 'server/*.lua', }
files { 'html/**', 'html/img/**', 'html/snd/**', "data/carcols_gen9.meta", "data/carmodcols_gen9.meta", 'stream/*.ytyp' }
ui_page 'html/index.html'
data_file "CARCOLS_GEN9_FILE" "data/carcols_gen9.meta"
data_file "CARMODCOLS_GEN9_FILE" "data/carmodcols_gen9.meta"
data_file 'DLC_ITYP_REQUEST' 'stream/*.ytyp'

escrow_ignore {
	'*.lua',
	'client/*.lua',
	'server/functionserver.lua', 'server/main.lua',
	'locales/*.lua',
	'html/*.lua', 'html/*.css', 'html/*.html', 'html/*.js',
	'shared/functions.lua', 'shared/recipes.lua', 'shared/locations.lua'
}
dependency '/assetpacks'