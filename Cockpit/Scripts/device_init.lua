dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."supported.lua")																					--Call lua file to detect current aircraft
dofile(LockOn_Options.common_script_path.."tools.lua")

if      supported == true  then																										--Mod launching logic.
MainPanel = {"ccMainPanel",LockOn_Options.script_path.."mainpanel_init.lua", {} }
creators = {}
creators[devices.CLICKABLE]	 		        = {"avLuaDevice"                ,LockOn_Options.script_path.."SYSTEMS/clickable.lua"}
creators[devices.PNT_UPD] 					= {"avLuaDevice"				,LockOn_Options.script_path.."SYSTEMS/PNT_update.lua"}
creators[devices.LIGHT_CONTROL]				= {"avLuaDevice"				,LockOn_Options.script_path.."SYSTEMS/light_control.lua"}
creators[devices.RADAR_CONTROL]				= {"avLuaDevice"				,LockOn_Options.script_path.."SYSTEMS/radar_control.lua"}
end