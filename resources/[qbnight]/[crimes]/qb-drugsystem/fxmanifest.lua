fx_version 'cerulean'
game 'gta5'
lua54 'yes'

version '1.0'
description 'Drugsproduction and selling script for QBCore'
author 'Lionh34rt'

ui_page 'nui/index.html'
files {
    "nui/index.html",
    "nui/scripts.js",
    "nui/css/style.css",
}

dependencies {
    'PolyZone',
	'qb-target'
}

shared_scripts {
    'shared/sh_shared.lua',
    'shared/locales.lua',
    '@ox_lib/init.lua',
}

client_scripts{
    '@PolyZone/client.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    '@PolyZone/BoxZone.lua',

    'client/cl_main.lua',
    'client/cl_druglabs.lua',
    'client/cl_missions.lua',
    'client/cl_drugruns.lua',
    'client/cl_cornerselling.lua',
    'client/cl_methcamper.lua',
    'client/cl_quarry.lua',
    'client/cl_weedfarming.lua',
    'client/cl_barrels.lua'
}

server_script {
    '@oxmysql/lib/MySQL.lua',
    'server/sv_main.lua',
    'server/sv_druglabs.lua',
    'server/sv_missions.lua',
    'server/sv_drugruns.lua',
    'server/sv_cornerselling.lua',
    'server/sv_methcamper.lua',
    'server/sv_quarry.lua',
    'server/sv_weedfarming.lua',
    'server/sv_barrels.lua'

}
