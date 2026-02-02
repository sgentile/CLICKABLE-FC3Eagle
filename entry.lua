declare_plugin("Clickable-FC3Eagle",
{
	installed 	  	= 	true,
	dirName		  	= 	current_mod_path,
	displayName   	= 	"Clickable FC3 Eagle",
	shortName	  	= 	"Clickable-FC3Eagle",
	fileMenuName  	= 	"Clickable FC3 Eagle",
	version			=	"v1.1.5",
	state		  	= 	"installed",
	developerName 	= 	"RedK0d/SGentile",
	info		  	= 	"Clickable cockpit mod for F-15C",

	load_immediately = true,
	Skins	=
	{
		{
			name	= ("Clickable-FC3Eagle"),
			dir		= "Skins"
		},
	},
	Options =
	{
		{
			name		= ("Clickable FC3 Eagle"),
            nameId		= "Clickable-FC3Eagle",
            dir			= "Options",
            CLSID		= "{FC3 CLICKABLE}"
		},
	},

})


local path 		= current_mod_path..'/Cockpit/Scripts/'
mount_vfs_texture_path  (current_mod_path ..  "/Textures")
mount_vfs_model_path    (current_mod_path ..  "/Shapes")

		

		
add_plugin_systems('CLICKABLE-FC3_Module','*',path,
	{
	["F-15C"]					= {enable_options_key_for_unit = 'F15c_enabled'},
	}
)

plugin_done()
