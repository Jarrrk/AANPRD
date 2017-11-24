resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'AANPRD'

server_scripts {
	'includes/global_functions.lua',
	
	'config.lua',
	
	'server/server.lua'
}

client_scripts {
	'includes/global_functions.lua',

	'config.lua',

	'client/anpr.lua',
	'client/update_cl.lua'
}

ui_page('client/ui/index.html')

files({
    'client/ui/index.html',
    'client/ui/AANPRD.css',
    'client/ui/AANPRD.js',
    'client/ui/cursor.png'
})