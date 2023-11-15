fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'Advanced Garages for FiveM'
version '2.1.2'
author 'JG Scripts'

shared_scripts {'config.lua', 'locales/*.lua', 'main.lua', 'framework/main.lua', '@ox_lib/init.lua',}

client_scripts {'framework/**/cl-*.lua', 'config-cl.lua', 'client/cl-main.lua', 'client/*.lua'}

server_scripts {'@oxmysql/lib/MySQL.lua', 'framework/**/sv-*.lua', 'config-sv.lua', 'server/sv-main.lua', 'server/*.lua'}

ui_page 'web/build/index.html'

files {'web/build/index.html', 'web/build/**/*'}

escrow_ignore {'config.lua', 'config-cl.lua', 'config-sv.lua', 'framework/**/*', 'locales/*.lua', 'client/cl-deformation.lua'}

dependency '/assetpacks'