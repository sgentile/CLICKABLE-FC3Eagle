dofile(lfs.writedir().."Config\\options.lua")
local   rep_source_utils    =   get_dcs_plugin_path("RedK0d Clickable").."\\DATA\\"

local   rep_dest_FC3        =   lfs.currentdir().."Mods\\aircraft\\Flaming Cliffs\\"                                   --lfs.currentdir().."Mods\\aircraft\\Flaming Cliffs\\Cockpit\\KneeboardRight\\"
local   rep_dest_F15C       =   lfs.currentdir().."Mods\\aircraft\\F-15C\\"                                            --lfs.currentdir().."Mods\\aircraft\\F-15C\\Cockpit\\KneeboardRight\\"
local   rep_input_F15C      =   lfs.currentdir().."Mods\\aircraft\\F-15C\\Input\\"
local   rep_input_FC3       =   lfs.currentdir().."Mods\\aircraft\\Flaming Cliffs\\Input\\F-15C\\"
local   mod_version         =   get_plugin_option_value("RedK0d Clickable", "Version", "local")
local   present_FC3         =   options.plugins["FC3"]
local   present_F15C        =   options.plugins["F-15C"]
local   device_init         =   "--[[CLICKABLE-FC3 ".. mod_version  .."]]"
local   date                =   os.date()
local   modified            =   "--[[Modified " .. date .. "]]"
local   entry_f15c          =   "MAC_flyable('F-15C', current_mod_path..'/Cockpit/KneeboardRight/',F15FM, current_mod_path..'/Comm/F-15C.lua')"
local   entry_fc3           =   "make_flyable('F-15C'	, current_mod_path..'/Cockpit/KneeboardRight/',F15FM, current_mod_path..'/Comm/F-15C.lua')"
local   FC3,F15C,up_to_date_fc3,up_to_date_f15c,first_run
local   blink_timer         = 0
local   blink_timer_s       = 1
---------------------------------------------------------------------------------------
-- File manipulation functions
local io, os, error = io, os, error
local filemanip = {}
function filemanip.exists(path)
    local file = io.open(path, 'rb')
    if file then
      file:close()
    end
    return file ~= nil
end
function filemanip.read(path, mode)
    mode = mode or '*a'
    local file, err = io.open(path, 'rb')
    if err then
      error(err)
    end
    local content = file:read(mode)
    file:close()
    return content
end
function filemanip.write(path, content, mode)
    mode = mode or 'w'
    local file, err = io.open(path, mode)
    if err then
      error(err)
    end
    file:write(content)
    file:close()
end
function filemanip.copy(src, dest)
    local content = filemanip.read(src)
    filemanip.write(dest, content)
end
function filemanip.move(src, dest)
    os.rename(src, dest)
end
function filemanip.remove(path)
    os.remove(path)
end
function        restart_dcs()
    dofile(LockOn_Options.script_path.."UTILS\\show_restart_window.lua")
end
--Editing input files
function F15C_editinput_k()
    local path = rep_input_F15C.."keyboard\\default.lua"
    local file = io.open(path, 'r')
    local fileContent = {}
    for line in file:lines() do
        table.insert (fileContent, line)
    end
    io.close(file)
        if          fileContent[6]  ~=  '--[[Edited file by RedK0d]]'                                              then   
                    fileContent[4]  =  '})\n\n--[[Edited file by RedK0d]]\n\nlocal CMD_ONOFF    = 10000\n'
                    fileContent[78]  =   '\n-- RedK0d Countermeasures Custom Program\n{down = CMD_ONOFF,name = _(\'Countermeasures Custom Program\'),category = _(\'Countermeasures\'),features = {"Countermeasures"}},\n})\n'
        end
    file = io.open(path, 'w')
    for index, value in ipairs(fileContent) do
        file:write(value..'\n')
    end
    io.close(file)
end
function F15C_editinput_j()
    local path = rep_input_F15C.."joystick\\default.lua"
    local file = io.open(path, 'r')
    local fileContent = {}
    for line in file:lines() do
        table.insert (fileContent, line)
    end
    io.close(file)
        if          fileContent[6]  ~=  '--[[Edited file by RedK0d]]'                                              then   
                    fileContent[4]  =  '})\n\n--[[Edited file by RedK0d]]\n\nlocal CMD_ONOFF    = 10000\n'
                    fileContent[76]  =   '\n-- RedK0d Countermeasures Custom Program\n{down = CMD_ONOFF,name = _(\'Countermeasures Custom Program\'),category = _(\'Countermeasures\'),features = {"Countermeasures"}},\n})\n'
        end
    file = io.open(path, 'w')
    for index, value in ipairs(fileContent) do
        file:write(value..'\n')
    end
    io.close(file)
end
function F15C_editentry()
    --print_message_to_user("F15C_editentry")
     local path = rep_dest_F15C.."entry.lua"
    local file = io.open(path, 'r')
    local fileContent = {}
    for line in file:lines() do
        table.insert (fileContent, line)
    end
    io.close(file)
end
function F15C_editdevice_init()
    local path = rep_dest_F15C.."Cockpit\\KneeboardRight\\device_init.lua"
    local file = io.open(path, 'r')
    local fileContent = {}
    for line in file:lines() do
        table.insert (fileContent, line)
    end
    io.close(file)
    if              fileContent[25]     ~=  device_init         then
                    fileContent[25]     =   device_init
                    fileContent[26]     =   modified                         
                    file = io.open(path, 'w')
                    for index, value in ipairs(fileContent) do
                        file:write(value..'\n')
                    end
                    io.close(file)
    end      
end
function FC3_editinput_k()
    local path = rep_input_FC3.."keyboard\\default.lua"
    local file = io.open(path, 'r')
    local fileContent = {}
    for line in file:lines() do
        table.insert (fileContent, line)
    end
    io.close(file)
        if          fileContent[6]  ~=  '--[[Edited file by RedK0d]]'                                              then   
                    fileContent[4]  =  '})\n\n--[[Edited file by RedK0d]]\n\nlocal CMD_ONOFF    = 10000\n'
                    fileContent[78]  =   '\n-- RedK0d Countermeasures Custom Program\n{down = CMD_ONOFF,name = _(\'Countermeasures Custom Program\'),category = _(\'Countermeasures\'),features = {"Countermeasures"}},\n})\n'
        end
    file = io.open(path, 'w')
    for index, value in ipairs(fileContent) do
        file:write(value..'\n')
    end
    io.close(file)
end
function FC3_editinput_j()
    local path = rep_input_FC3.."joystick\\default.lua"
    local file = io.open(path, 'r')
    local fileContent = {}
    for line in file:lines() do
        table.insert (fileContent, line)
    end
    io.close(file)
        if          fileContent[6]  ~=  '--[[Edited file by RedK0d]]'                                              then   
                    fileContent[4]  =  '})\n\n--[[Edited file by RedK0d]]\n\nlocal CMD_ONOFF    = 10000\n'
                    fileContent[76]  =   '\n-- RedK0d Countermeasures Custom Program\n{down = CMD_ONOFF,name = _(\'Countermeasures Custom Program\'),category = _(\'Countermeasures\'),features = {"Countermeasures"}},\n})\n'
        end
    file = io.open(path, 'w')
    for index, value in ipairs(fileContent) do
        file:write(value..'\n')
    end
    io.close(file)
end
function FC3_editentry()
    --print_message_to_user("FC3_editentry")
     local path = rep_dest_FC3.."entry.lua"
    local file = io.open(path, 'r')
    local fileContent = {}
    for line in file:lines() do
        table.insert (fileContent, line)
    end
    io.close(file)
end
function FC3_editdevice_init()
    local path = rep_dest_FC3.."Cockpit\\KneeboardRight\\device_init.lua"
    local file = io.open(path, 'r')
    local fileContent = {}
    for line in file:lines() do
        table.insert (fileContent, line)
    end
    io.close(file)
    if              fileContent[25]     ~=  device_init         then
                    fileContent[25]     =   device_init
                    fileContent[26]     =   modified                         
                    file = io.open(path, 'w')
                    for index, value in ipairs(fileContent) do
                        file:write(value..'\n')
                    end
                    io.close(file)
    end      
end


---------------------------------------------------------------------------------------
--Checks if installation status
function F15C_check()
    F15C_editinput_k()
    F15C_editinput_j() 
end
function FC3_check()
    FC3_editinput_k()
    FC3_editinput_j() 
end
---------------------------------------------------------------------------------------
if      present_FC3                                     then
        FC3                 =   true
else
        FC3                 =   false
end
if      present_F15C                                    then
        F15C                =   true
else
        F15C                =   false
end

---------------------------------------------------------------------------------------


if                  F15C                ==  true                                        then
                    F15C_check()                      
end
if                  FC3                 ==  true                                        then
                    FC3_check()
end
---------------------------------------------------------------------------------------
--Installation Functions
--me_ProductType.getType()




