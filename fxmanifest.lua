fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

game 'rdr3'
lua54 'yes'
author 'BCC Team'

shared_scripts {
    'shared/configs/*.lua',
	'shared/locale.lua',
	'shared/languages/*.lua'
}

client_scripts {
    'client/client_init.lua',
	'client/dataview.lua',
    'client/main.lua',
    'client/functions.lua',
    'client/menus/input.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server_init.lua',
    'server/database.lua',
	'server/main.lua'
}

version '2.4.2'
