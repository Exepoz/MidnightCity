resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

server_scripts {
	'server.lua'
}

client_scripts {
	'client.lua'
}

files {
    'ui/app.js',
    'ui/index.html',
    'ui/style.css',
    'ui/*.png',
}

ui_page {
    'ui/index.html'
}

lua54 'yes'