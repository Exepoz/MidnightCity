fx_version 'cerulean'
games {'gta5'}

author 'Constant Development'
description 'Meth-Run System similar to NoPixel'
version '1.5'

shared_scripts {
    'config.lua',
    'locales/en.lua'
}

client_scripts {
    'client/cl_extra.lua',
    'client/cl_main.lua',
}
server_scripts {
    'server/sv_extra.lua',
    'server/sv_main.lua',
}

escrow_ignore {
    'client/cl_extra.lua',
    'server/sv_extra.lua',
    'locales/*',
    'config.lua',
    'README.md'
}

lua54 'yes'