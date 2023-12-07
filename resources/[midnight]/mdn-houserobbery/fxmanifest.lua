fx_version 'cerulean'
game 'gta5'
description 'Midnight City House Robberies made by xoraphox'
version '1.0.0'
ui_page 'nui/index.html'

lua54 'yes'

files {
  "nui/index.html",
  "nui/scripts.js",
  "nui/css/style.css",
}

client_scripts {
	'config.lua',
	'client/*.lua'
}

server_scripts {
	'config.lua',
	'server/*.lua'
}

shared_scripts {
	'@ox_lib/init.lua',
}
