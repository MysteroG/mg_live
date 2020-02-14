resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

files {
	'vehicles.meta',
	'carvariations.meta',
	--'carcols.meta',
	'handling.meta'
}

client_script {
	'client/main.lua',
	'GUI.lua',
	'config.lua',
	'vehicle_names.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua',
}

data_file 'HANDLING_FILE' 'handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'vehicles.meta'
--data_file 'CARCOLS_FILE' 'carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'carvariations.meta'