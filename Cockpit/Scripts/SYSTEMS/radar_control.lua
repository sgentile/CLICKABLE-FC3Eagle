
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."utils.lua")


local update_time_step      = 0.005
make_default_activity(update_time_step)
sensor_data                 = get_base_data()
local dev                   = GetSelf()
local aircraft              = get_aircraft_type()
--------------------------------------------------------------------
--Variable declaration
local   radar_mode      =   0       --  1:LRS   2:VS    3:SRS
local   radar_stat      =   0       --  0:Off   1:Opr
local   radar_spl       =   0       --  0:Off   1:Flood
local   scan_area       =   1
local   s_timer         =   0
--------------------------------------------------------------------
--
local RADAR_POWER 			= get_param_handle("RADAR_POWER")
local RADAR_MODE_SEL 		= get_param_handle("RADAR_MODE_SEL")
local RADAR_SPL_MODE 		= get_param_handle("RADAR_SPL_MODE")

function post_initialize()
	local birth = LockOn_Options.init_conditions.birth_place
    if birth=="GROUND_HOT" or birth=="AIR_HOT" then


    elseif birth=="GROUND_COLD" then

    end


end
local function  reset_scan_area(scan_area)
    local       max_scan_area   =   1
        if      scan_area       >   max_scan_area       then
                return 1
        elseif  scan_area       <   0                   then
                return 0
        else
                return scan_area
        end
end

-- Listen for keyboard commands to stay in sync when pilot uses keyboard shortcuts
dev:listen_command(Keys.iCommandPlaneRadarOnOff)
dev:listen_command(Keys.iCommandPlaneModeBVR)
dev:listen_command(Keys.iCommandPlaneModeVS)
dev:listen_command(Keys.iCommandPlaneModeBore)
dev:listen_command(Keys.iCommandPlaneModeFI0)



function SetCommand(command,value)
    if                      command     ==  device_commands.CLIC_RADAR_SPL_MODE                     then
                            radar_spl   =   value
        if                  radar_spl   ==  1                                                       then
                            dispatch_action(nil,Keys.iCommandPlaneModeFI0)
        end
        if                  radar_spl   ==  0                                                       then
                            dispatch_action(nil,Keys.iCommandPlaneModeBore)
        end

    end
    if                      command     ==  device_commands.CLIC_RADAR_MODE_SEL                     then
        if                  value       ==  1                                                       then
                            radar_mode  =   radar_mode   +   1
        elseif              value       ==  0                                                       then
                            radar_mode  =   radar_mode   -   1
        end
        if                  radar_mode  >   3                                                       then
                            radar_mode  =   3
        end
        if                  radar_mode  <   0                                                       then
                            radar_mode  =   0
        end
        if                  radar_mode  ==  1                                                       then
                            dispatch_action(nil,Keys.iCommandPlaneModeBVR)
        end
        if                  radar_mode  ==  2                                                       then
                            dispatch_action(nil,Keys.iCommandPlaneModeVS)
        end
        if                  radar_mode  ==  3                                                       then
                            dispatch_action(nil,Keys.iCommandPlaneModeBore)
        end
    end
    if                      command     ==  device_commands.CLIC_RADAR_POWER                        and value == 1  then
                            dispatch_action(nil,Keys.iCommandPlaneRadarOnOff)
    end
    -- Keyboard sync: track radar on/off state
    if                      radar_stat  ==  0                                                       then
        if                  command     ==  Keys.iCommandPlaneRadarOnOff                            then
                            radar_stat  =   1
        end
    elseif                  radar_stat  ==  1                                                       then
        if                  command     ==  Keys.iCommandPlaneRadarOnOff                            then
                            radar_stat  =   0
        end
    end
    -- Keyboard sync: track mode selections
    if                      command     ==  Keys.iCommandPlaneModeBVR                               then

                            radar_mode  =   1
                            radar_spl   =   0
        if                  radar_stat  ==  0                                                       then
                            dispatch_action(nil,Keys.iCommandPlaneRadarOnOff)
        end

    end
    if                      command     ==  Keys.iCommandPlaneModeVS                                then
                            radar_mode  =   2
                            radar_spl   =   0
        if                  radar_stat  ==  0                                                       then
                            radar_stat  =   1
        end
    end
    if                      command     ==  Keys.iCommandPlaneModeBore                              then
                            radar_mode  =   3
                            radar_spl   =   0

        if                  radar_stat  ==  0                                                       then
                            radar_stat  =   1
        end
    end
    if                      command     ==  Keys.iCommandPlaneModeFI0                               then
                            radar_mode  =   3
                            radar_spl   =   1
        if                  radar_stat  ==  1                                                       then
                            dispatch_action(nil,Keys.iCommandPlaneRadarOnOff)

        end
    end
    -- EL scan with auto-stop timer
    if                      command     ==  device_commands.CLIC_RADAR_EL_SCAN                      then
                            s_timer     =   0.3
        if                  value       ==  1                                                       then
                            dispatch_action(nil,Keys.iCommandSelecterUp)
        elseif              value       ==  0                                                       then
                            dispatch_action(nil,Keys.iCommandSelecterDown)
        end
    end
    -- Range zoom
    if                      command     ==  device_commands.CLIC_RADAR_RANGE                        then
        if                  value       ==  1                                                       then
                            dispatch_action(nil,Keys.iCommandPlaneZoomIn)
        elseif              value       ==  0                                                       then
                            dispatch_action(nil,Keys.iCommandPlaneZoomOut)
        end
    end
    -- AZ scan area
    if                      command     == device_commands.CLIC_RADAR_AZ_SCAN                       and
                            value       >   0                                                       then
                            scan_area   = scan_area +1
    elseif                  command     == device_commands.CLIC_RADAR_AZ_SCAN                       and
                            value       <   0                                                       then
                            scan_area   = scan_area -1
    end
    if                      command     == device_commands.CLIC_RADAR_AZ_SCAN                       then
        if                  scan_area   ==  1                                                       then
                            dispatch_action(nil,Keys.iCommandIncreaseRadarScanArea)
        elseif              scan_area   ==  0                                                       then
                            dispatch_action(nil,Keys.iCommandDecreaseRadarScanArea)
        end
    end
                            scan_area   = reset_scan_area(scan_area)
end




function update_radar()
    RADAR_MODE_SEL:set(radar_mode)
    RADAR_POWER:set(radar_stat)
    RADAR_SPL_MODE:set(radar_spl)
end


function update()

        if s_timer > 0 then
            s_timer = s_timer - update_time_step
            if s_timer <= 0 then
                s_timer = 0
                dispatch_action(nil,Keys.iCommandSelecterStop)
            end
        end
        update_radar()
end

need_to_be_closed = false

