fx_version 'cerulean'
games { 'gta5' }

author 'Jeesus Krisostoomus#7737'
description 'https://github.com/JeesusKrisostoomus/Kyk-WarnSystem'

client_scripts {
	'client.lua'
}

server_scripts {
    '@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
    'server.lua'

}

dependencies {
	'async',
	'mysql-async'
}
