dofile(LockOn_Options.script_path.."clickable_defs.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")
local gettext = require("i_18n")
_ = gettext.translate
show_element_boxes = true --connector debug




elements = {}

-- F-15C clickable elements
elements["PNT_EJECT_BIS"]           = default_button("Eject (3 times)",                                     devices.CLICKABLE,  device_commands.CLIC_EJECT         )  
elements["PNT_EJECT"]               = default_button("Eject (3 times)",                                     devices.CLICKABLE,  device_commands.CLIC_EJECT         )  
elements["PNT_CTM_F15"]             = default_button("Countermeasures Release",                             devices.CLICKABLE,  device_commands.CLIC_CTM_F15      )
elements["PNT_JAM_BIS"]             = default_button("ECM",                                                 devices.CLICKABLE,  device_commands.CLIC_JAM           )
elements["PNT_JAM"]                 = default_button("ECM",                                                 devices.CLICKABLE,  device_commands.CLIC_JAM           )
elements["PNT_AIRBRAKE"]            = default_button("Airbrake",                                            devices.CLICKABLE,  device_commands.CLIC_AIRBRAKE      )
elements["PNT_FLAPS_MULTI_BIS"]     = default_button("Flaps Up/Down",                                       devices.CLICKABLE,  device_commands.CLIC_FLAPS_MULTI   )
elements["PNT_STATION"]             = default_button("Weapon Change",                                       devices.CLICKABLE,  device_commands.CLIC_STATION       )
elements["PNT_STICK_LOCK"]          = default_button("Target Lock",                                         devices.CLICKABLE,  device_commands.CLIC_LOCK          )
elements["PNT_STICK_UNLOCK"]        = default_button("Radar - Return To Search/NDTWS",                      devices.CLICKABLE,  device_commands.CLIC_LOCK_REL      )
elements["PNT_STICK_STATION"]       = default_button("Weapon Change",                                       devices.CLICKABLE,  device_commands.CLIC_STATION       )
elements["PNT_STICK_SHOOT"]         = default_button("Weapon Release",                                      devices.CLICKABLE,  device_commands.CLIC_FIRE          )
elements["PNT_FUEL_BINGO"]          = default_axis_limited("Bingo Fuel Index CW/CCW",                       devices.CLICKABLE,  device_commands.CLIC_BINGO,nil, 0, 100/15,true,true)
elements["PNT_TGT_L"]               = default_button("Target Designator Left",                              devices.CLICKABLE,  device_commands.CLIC_TGT_L         )
elements["PNT_TGT_R"]               = default_button("Target Designator Right",                             devices.CLICKABLE,  device_commands.CLIC_TGT_R         )
elements["PNT_TGT_U"]               = default_button("Target Designator Up",                                devices.CLICKABLE,  device_commands.CLIC_TGT_U         )
elements["PNT_TGT_D"]               = default_button("Target Designator Down",                              devices.CLICKABLE,  device_commands.CLIC_TGT_D         )
elements["PNT_TRIM_L"]              = default_button("Trim: Left Wing Down",                                devices.CLICKABLE,  device_commands.CLIC_TRIM_L        )
elements["PNT_TRIM_R"]              = default_button("Trim: Right Wing Down",                               devices.CLICKABLE,  device_commands.CLIC_TRIM_R        )
elements["PNT_TRIM_U"]              = default_button("Trim: Nose Down",                                     devices.CLICKABLE,  device_commands.CLIC_TRIM_U        )
elements["PNT_TRIM_D"]              = default_button("Trim: Nose Up",                                       devices.CLICKABLE,  device_commands.CLIC_TRIM_D        )
elements["PNT_CANOPY"]              = default_button("Canopy Open/Close",                                   devices.CLICKABLE,  device_commands.CLIC_CANOPY        )  
elements["PNT_CAS_YAW"]             = default_button("CAS Yaw",                                             devices.CLICKABLE,  device_commands.CLIC_CAS_YAW       )
elements["PNT_CAS_YAW"].stop_action        = nil
elements["PNT_CAS_ROLL"]            = default_button("CAS Roll",                                            devices.CLICKABLE,  device_commands.CLIC_CAS_ROLL       )
elements["PNT_CAS_ROLL"].stop_action        = nil
elements["PNT_CAS_PITCH"]           = default_button("CAS Pitch",                                           devices.CLICKABLE,  device_commands.CLIC_CAS_PITCH       )
elements["PNT_CAS_PITCH"].stop_action        = nil
elements["PNT_CAS_ALT-HOLD"]        = default_button("Autopilot - Altitude Hold",                           devices.CLICKABLE,  device_commands.CLIC_CAS_ALT_HOLD          )
elements["PNT_CAS_ALT-HOLD"].stop_action        = nil
elements["PNT_CAS_ATT-HOLD"]        = default_button("Autopilot - Attitude Hold",                           devices.CLICKABLE,  device_commands.CLIC_CAS_ATT_HOLD         )
elements["PNT_CAS_ATT-HOLD"].stop_action        = nil
elements["ENG_CUTOFF_L"]             = default_button("Engine Left Stop",                                    devices.CLICKABLE,  device_commands.CLIC_ENG_L_STOP    )
elements["ENG_CUTOFF_R"]             = default_button("Engine Right Stop",                                   devices.CLICKABLE,  device_commands.CLIC_ENG_R_STOP    )

-- Light Control System elements
local rotvalue                       = (100/15)/10
elements["EXT_LT_POSITION"]          = default_axis_limited("Position Lights",                               devices.LIGHT_CONTROL,  device_commands.LIGHT_POS,     484, 0, rotvalue, false, false, {0, 0.7})
elements["EXT_LT_FORMATION"]         = default_axis_limited("Formation Lights",                              devices.LIGHT_CONTROL,  device_commands.LIGHT_FORM,    485, 0, rotvalue, false, false, {0, 0.6})
elements["TMB_MISC_TAXI-LIGHT"]      = default_button("Ldg/Off/Taxi Light",                                  devices.LIGHT_CONTROL,  device_commands.LIGHT_LDG_TAXI)
elements["TMB_EXT-LT_ANTI-COLLISION"] = default_2_position_tumb("Anti Collision Lights",                     devices.LIGHT_CONTROL,  device_commands.LIGHT_ANTICOL, 451)
elements["TMB_EXT-LT_ANTI-COLLISION"].arg_lim = {{-1, 1}, {-1, 1}}
elements["INTERIOR_FLT-INST"]        = default_axis_limited("Illumination Cockpit",                          devices.LIGHT_CONTROL,  device_commands.LIGHT_COCKPIT, 478, 0, 1, false, false, {0.1, 0.6})

-- Radar Control System elements
elements["RADAR_SPL-MODE"]           = default_axis_limited("Radar Spl Modes",                               devices.RADAR_CONTROL,  device_commands.CLIC_RADAR_SPL_MODE,  0, 0, rotvalue, false, false, {0, 1})
elements["RADAR_MODE_SEL"]           = default_axis_limited("Radar Master Mode Select",                      devices.RADAR_CONTROL,  device_commands.CLIC_RADAR_MODE_SEL,  0, 0, rotvalue, false, false, {0, 1})
elements["RADAR_AZ_SCAN"]            = default_axis_limited("Radar Az Scan",                                 devices.RADAR_CONTROL,  device_commands.CLIC_RADAR_AZ_SCAN)
elements["RADAR_EL_SCAN"]            = default_axis_limited("Radar El Scan",                                 devices.RADAR_CONTROL,  device_commands.CLIC_RADAR_EL_SCAN,   0, 0, rotvalue, false, false, {0, 1})
elements["RADAR_EL_SCAN"].cycle      = false
elements["RADAR_RANGE"]              = default_axis_limited("Radar Range",                                   devices.RADAR_CONTROL,  device_commands.CLIC_RADAR_RANGE,     0, 0, rotvalue, false, false, {0, 1})
elements["RADAR_RANGE"].cycle        = false
elements["RADAR_POWER"]              = default_axis_limited("Radar Power",                                   devices.RADAR_CONTROL,  device_commands.CLIC_RADAR_POWER,     0, 0, rotvalue, false, false, {0, 1})

-- Additional clickable elements
elements["TMB_FUEL_OPEN/CLOSE"]      = default_button("Refueling Port",                                      devices.CLICKABLE,  device_commands.CLIC_RPORT)