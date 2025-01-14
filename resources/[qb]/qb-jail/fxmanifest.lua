fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Lionh34rt#4305'
description 'Jail Management System for Gabz MLO - QBCore'
version '1.1'

dependencies {
    'ox_lib',
    'qb-powerplant'
}

files {
    'locales/*.json'
}

shared_scripts {
    '@ox_lib/init.lua',
    'shared/sh_config.lua',
    'shared/locales.lua'
}

client_scripts {
    'client/cl_utils.lua',
    'client/cl_main.lua',
    'client/cl_jobhandler.lua',
    'client/cl_jobs.lua',
    'client/cl_econ.lua',
    'client/cl_jailbreak.lua',
    'client/cl_doc.lua'
}

server_scripts {
    'server/sv_utils.lua',
    'server/sv_main.lua',
    'server/sv_jobs.lua',
    'server/sv_econ.lua',
    'server/sv_jailbreak.lua',
    'server/sv_doc.lua'
}
