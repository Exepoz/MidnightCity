fx_version 'cerulean'
game 'gta5'

Author 'Samuel#0008'
Description 'A library of functions used to ease the bridge between SD Scripts'
Version '1.3.2'

client_scripts { 'client/cl_framework.lua', 'client/cl_utils.lua', 'client/menu/cl_menu.lua', }
server_scripts { 'sv_config.lua', 'server/sv_framework.lua', 'server/sv_utils.lua', 'shared/logs.lua',  'server/version.lua', } 
shared_scripts { --[[ '@ox_lib/init.lua', ]] 'sh_config.lua', 'shared/sh_utils.lua', 'shared/lang.lua', 'export/export.lua' }

ui_page 'client/menu/html/index.html'

files { 'client/menu/html/index.html', 'client/menu/html/script.js', 'client/menu/html/style.css', }

lua54 'yes'

escrow_ignore { 'client/*.lua', 'server/*.lua', 'shared/*.lua', 'export/export.lua', 'sh_config.lua', 'sv_config.lua', 'client/menu/cl_menu.lua' }
dependency '/assetpacks'