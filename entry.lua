declare_plugin("RedK0d Clickable",
{
	installed 	  	= 	true,
	dirName		  	= 	current_mod_path,
	displayName   	= 	"RedK0d Clickable",
	shortName	  	= 	"RedK0d Clickable",
	fileMenuName  	= 	"RedK0d Clickable",
	version			=	"v1.1.5",
	state		  	= 	"installed",
	developerName 	= 	"RedK0d",
	info		  	= 	"RedK0d Clickable",

	load_immediately = true,
	Skins	=
	{
		{
			name	= ("RedK0d Clickable"),
			dir		= "Skins"
		},
	},
	Options =
	{
		{
			name		= ("RedK0d Clickable"),
            nameId		= "RedK0d Clickable",
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
