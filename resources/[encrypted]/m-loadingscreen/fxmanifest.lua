fx_version 'adamant'
game 'gta5'
author "Lucid#3604"

client_scripts {
    'client/main.lua',
}

server_scripts {
    'config.lua',
    'server/main.lua',
}

loadscreen 'html/index.html'
loadscreen_cursor 'yes'
loadscreen_manual_shutdown 'yes'


files {
    'html/index.html',
    'html/fonts/*.ttf',
    'html/fonts/*.otf',
    'html/js/*.js',
    'html/assets/**/*.png',
    'html/assets/**/*.ttf',
    'html/assets/img/*.png',
    'html/assets/video/*.mp4',
    'html/assets/video/*.webm',
    'html/assets/background/*.mp4',
    'html/assets/background/*.webm',


    'html/assets/background/*.ogg',
    'html/assets/background/*.png',

    'html/assets/**/*.otf',
    'html/assets/**/*.mp3',
    'html/assets/**/*.mp4',
    'html/assets/**/*.ogg',
    'html/assets/**/**/*.png',
    'html/assets/*.png',
    'config.lua',
    'server/main.lua',
}


escrow_ignore {
	'config.lua',

}

lua54 'yes'
dependency '/assetpacks'