declare_plugin("ClickableF15CMod",
{
	installed 	  	= 	true,
	dirName		  	= 	current_mod_path,
	displayName   	= 	"Clickable F15C Mod",
	shortName	  	= 	"ClickableF15CMod",
	fileMenuName  	= 	"Clickable F15C Mod",
	version			=	"v1.1.6",
	state		  	= 	"installed",
	developerName 	= 	"RedK0d/SGentile",
	info		  	= 	"Clickable cockpit mod for F-15C",

	load_immediately = true,
	Skins	=
	{
		{
			name	= ("ClickableF15CMod"),
			dir		= "Skins"
		},
	},
	Options =
	{
		{
			name		= ("Clickable F15C Mod"),
            nameId		= "ClickableF15CMod",
            dir			= "Options",
            CLSID		= "{F15C CLICKABLE}"
		},
	},

})


local path 		= current_mod_path..'/Cockpit/Scripts/'
mount_vfs_texture_path  (current_mod_path ..  "/Textures")
mount_vfs_model_path    (current_mod_path ..  "/Shapes")




add_plugin_systems('ClickableF15C_Module','*',path,
	{
	["F-15C"]					= {enable_options_key_for_unit = 'F15c_enabled'},
	}
)

plugin_done()
