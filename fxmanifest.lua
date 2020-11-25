fx_version 'cerulean'
games { 'gta5' }

author 'Jeesus Krisostoomus#7737'
description 'https://github.com/JeesusKrisostoomus/Kyk-WarnSystem'


ui_page {
	'html/ui.html'
}

files {
	'html/ui.html',
	'html/js/app.js', 
	'html/css/style.css'
}

client_scripts {
	'client.lua'
}

server_scripts {
    '@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
    'server.lua'
}

dependencies {
	'async',
	'mysql-async'
}