fx_version 'cerulean'
game'gta5'
name 'mrw_minigolf'
lua54 'yes'
description 'script for patoche golf mapping'
author 'Morow'

client_scripts{
    'client/*.lua'
}

server_script{
    'server/*.lua'
}

shared_scripts {
    '@es_extended/imports.lua',
    'shared/*.lua',
    'shared/translation/*.lua'
}

files{
    'ui/ui.html',
    'ui/script/app.js',
    'ui/css/app.css',
    'ui/font/*.woff'
}

ui_page 'ui/ui.html'

escrow_ignore {
    "shared/**/*",
  }
dependency '/assetpacks'