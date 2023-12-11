fx_version 'cerulean'
game 'gta5'

author 'Renewed Scripts'
description 'Renewed Garbagejob, made by Renewed Scripts with a lot of features such as group jobs, level system and Renewed Banking support'
version '1.0.0'

lua54 'yes'

shared_script {
    'shared/shared.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    'shared/server.lua',
    'server/*.lua'
}

escrow_ignore {
    'client/*.lua',
    'server/*.lua',
    'shared/*.lua',
    '*.*'
  }
dependency '/assetpacks'