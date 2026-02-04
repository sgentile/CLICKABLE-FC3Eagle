# ClickableF15CMod Project Overview

## Project Purpose
This is a DCS World mod for the F-15C aircraft that adds fully clickable cockpit controls and animations. Originally forked from RedK0d's CLICKABLE-FC3 project. All functionality is consolidated into a single tech mod variant.

## Installation
- **Install to**: `SavedGames/Mods/tech/Clickable-FC3Eagle`
- **How it works**: Overlays clickable functionality and subsystem animations onto the base F-15C via DCS's plugin/tech mod system
- **Toggle clickable mode**: LAlt+C in cockpit

---

## Project Structure

### Root Level Files
- **README.md** - Main documentation with features, installation, and list of clickable controls
- **CHANGELOG.md** - Development history and version notes
- **INSTALL.md** - Installation instructions
- **entry.lua** - Plugin declaration. Mounts textures/shapes, registers plugin systems for F-15C
- **build.sh** - Build script that packages the tech mod for OVGME distribution
- **claude.md** - Development context (this file)

---

## Cockpit/Scripts/ — Core Files

- **clickabledata.lua** - Defines all clickable UI elements and their mappings. Maps 3D cockpit connector names (PNT_*, EXT_LT_*, RADAR_*, etc.) to buttons, axes, and rotaries with hints and device commands. Primary file for adding new clickable controls. Elements are grouped by device: CLICKABLE (generic commands), LIGHT_CONTROL (lighting), RADAR_CONTROL (radar).

- **clickable_defs.lua** - Function templates for creating clickable element definitions:
  - `default_button()` - Button controls (on/off)
  - `default_movable_axis()` - Axis controls (continuous movement)
  - `default_2_position_tumb()` - 2-position toggle switches
  - `default_3_position_tumb()` - 3-position cyclic controls
  - `default_axis_limited()` - Axis with limits and optional arg_number for animation
  - `default_button_axis()` - Combined button + axis (click + scroll)
  - Animation speed and cursor mode settings

- **command_defs.lua** - Two tables:
  - `Keys` — DCS World command IDs (numeric). Reference for all native aircraft commands available via `dispatch_action()`.
  - `device_commands` — Custom mod command IDs (counter-based, starting at 3501). Organized into sections: generic clickable commands (CLIC_*), light control commands (LIGHT_*), radar control commands (CLIC_RADAR_*), and miscellaneous.

- **devices.lua** - Four device IDs:
  - `CLICKABLE` (1) — Generic command dispatcher. Handles all one-shot actions (engines, gear, weapons, trim, autopilot, etc.)
  - `PNT_UPD` (2) — Animation updater. Gets references to clickable elements and calls `:update()` each frame to sync their visual state.
  - `LIGHT_CONTROL` (3) — Lighting subsystem. Manages nav light flash, collision light flash, formation light intensity, taxi light sync, and cockpit illumination routing.
  - `RADAR_CONTROL` (4) — Radar subsystem. Tracks radar mode/power/SPL state, syncs with keyboard commands, drives radar param gauges, and handles EL scan auto-stop.

- **device_init.lua** - Registers the four device creators, each pointing to its lua file in SYSTEMS/. Gated behind the `supported` check from supported.lua.

- **mainpanel_init.lua** - Sets `shape_name = "F-15C-CLICKABLE"`. Defines all gauges (parameter type) that map between param handles and draw argument numbers:
  - Base gauges: throttle L/R, stick pitch/roll, canopy, gear lever, canopy lever
  - F-15C gauges: PSI_CABIN (arg 114), PSI_OXY (arg 363), LIQUID_OXY (arg 376)
  - Light system: MISC_TAXI_LIGHT (arg 428)
  - Radar system: RADAR_POWER (arg 488), RADAR_MODE_SEL (arg 493), RADAR_SPL_MODE (arg 492)

- **supported.lua** - Checks `get_aircraft_type() == "F-15C"` to gate mod loading.

- **utils.lua** - Utility functions including PID controller, weighted moving average, jumpwheel, and the `round()` function used throughout.

- **dump.lua** - Debug/logging utilities.

---

## Cockpit/Scripts/SYSTEMS/ — Device Logic

Each file is an independent `avLuaDevice` Lua state. They share no variables directly; cross-device communication happens via params (gauges in mainpanel_init) and `dispatch_action()`.

### clickable.lua — Generic Command Dispatcher
Handles all one-shot and simple-state commands. Covers:
- Engine start/stop (L/R), power on/off
- Gear, canopy, flaps, airbrake, trim
- Weapons: fire/pickle, station select, lock/unlock, jettison (weapons, tanks, emergency)
- Targeting: radar slew (up/down/left/right/center), selecter scan (left/right/EL)
- Radar: on/off toggle, PRF change, AZ scan area, mode cycling (master mode, AA mode, quick mode)
- Autopilot/CAS: route, alt hold, att hold, yaw/roll/pitch augmentation
- Lights: nav lights toggle, anti-collision toggle, landing/taxi lights, cockpit illumination toggle
- HUD: brightness, color, filter, repeater
- Countermeasures: chaff, flare, snar, F-15C single-button release
- Miscellaneous: mirrors, RWR, altimeter, clock, bingo fuel, waypoint, air refuel port, fuel quantity test/selector, eject, parachute, hook, wing fold, nose wheel steering
- Timers in `update()`: selecter auto-stop, plane radar auto-stop, bingo selector auto-stop

### PNT_update.lua — Animation Sync
Gets `get_clickable_element_reference()` for all PNT_* elements and calls `:update()` on each every frame. Keeps the clickable element visuals in sync with aircraft state.

### light_control.lua — Lighting Subsystem
State-driven animation logic for exterior and interior lights:
- **Nav light flash**: When `LIGHT_POS == 7`, toggles draw args 190/191/192 on a 1.5s cycle (0.5s on, 1.0s off). For positions 0–6, sets static intensity (value/10).
- **Collision light flash**: When `LIGHT_ANTICOL == 1`, pulses draw arg 199 on a 1.0s cycle (narrow 0.1s pulse between 0.5–0.6s mark).
- **Formation light**: Writes `LIGHT_FORM` value directly to draw arg 88 every frame.
- **Taxi light sync**: Reads base cockpit draw args 208 (landing) and 209 (taxi) each frame, writes to `MISC_TAXI_LIGHT` param so the `PNT_LANDING_LIGHTS` element stays in sync. The connector reference in light_control.lua must match the element key in clickabledata.lua (currently `PNT_LANDING_LIGHTS`).
- **Cockpit illumination**: Routes `LIGHT_COCKPIT` and `_409` commands through to the cockpit light element.
- Hot start initializes anti-collision flash on and position lights at intensity 5.

### radar_control.lua — Radar Subsystem
Tracks radar state internally and keeps it in sync with both clickable controls and keyboard shortcuts:
- Tracks `radar_mode` (0=off, 1=LRS/BVR, 2=VS, 3=SRS/Bore), `radar_stat` (0=off, 1=on), `radar_spl` (0=bore, 1=flood/FI0)
- Writes state to params every frame via `update_radar()`: RADAR_POWER, RADAR_MODE_SEL, RADAR_SPL_MODE
- Listens to keyboard commands (`iCommandPlaneRadarOnOff`, `ModeBVR`, `ModeVS`, `ModeBore`, `ModeFI0`) so internal state stays correct when pilot uses keyboard
- EL scan dispatches `SelecterUp`/`SelecterDown` with a 0.3s auto-stop timer
- AZ scan area toggles between increase/decrease with clamping (0–1)
- Range dispatches ZoomIn/ZoomOut

### functions.lua — File Utilities
Utility functions for file operations (read, write, copy, move). Not used by core clickable logic.

---

## Build System

### build.sh
1. Copies `entry.lua` → `build/Clickable-FC3Eagle/Mods/tech/Clickable-FC3Eagle/`
2. Copies `Cockpit/Scripts/` → same target
3. Copies `Options/`, `Skins/`, `Shapes/` → same target
4. Zips to `dist/Clickable-FC3Eagle-{version}.zip`

Version is auto-detected from `entry.lua` or passed as first argument: `./build.sh v1.2.3`

### Build Output
- `build/` — Build artifacts (gitignored, regenerated each build)
- `dist/` — Final distribution zip for OVGME installation

---

## Shared Resources

### Options/ — Configuration Files
- **options.dlg** - Options dialog UI definition
- **optionsData.lua** - Options data structure
- **optionsDb.lua** - Options database/persistence

### Shapes/ & Skins/
3D model assets for the F-15C cockpit (includes `F-15C-CLICKABLE.edm`)

---

## Key Concepts

### Clickable Elements
Defined in **clickabledata.lua**:
```lua
elements["CONNECTOR_NAME"] = function_type("Display Name", device, command, ...)
```
The CONNECTOR_NAME must match a 3D connector name on `F-15C-CLICKABLE.edm`. Elements referencing connectors that don't exist on the model are simply not rendered or interactive — they don't cause errors.

### Device Routing
Each element specifies which device receives its commands:
- `devices.CLICKABLE` — command goes to clickable.lua's `SetCommand()`
- `devices.LIGHT_CONTROL` — command goes to light_control.lua's `SetCommand()`
- `devices.RADAR_CONTROL` — command goes to radar_control.lua's `SetCommand()`

### Animation System
- Draw arguments (`set_aircraft_draw_argument_value()`) are model-agnostic — they work regardless of which EDM is loaded
- Param handles (`get_param_handle()`) require a matching gauge in mainpanel_init.lua
- `PNT_update.lua` calls `:update()` on element references to sync their visuals with cockpit state

### Device Commands
- `device_commands.CLIC_*` — generic clickable commands (handled by clickable.lua)
- `device_commands.LIGHT_*` — light system commands (handled by light_control.lua)
- `device_commands.CLIC_RADAR_SPL_MODE` etc. — radar commands (handled by radar_control.lua)
- `Keys.*` — native DCS commands dispatched via `dispatch_action()`

### Extracting Connector Names from EDM
The EDM is a binary file. Connector names are embedded as plain strings and can be extracted:
```bash
strings Shapes/F-15C-CLICKABLE.edm | grep "^PNT_\|^EXT_\|^TMB_\|^RADAR_\|^ENG_\|^INTERIOR_"
```
The element key in `clickabledata.lua` must exactly match one of these connector names. Mismatches are silent — DCS simply ignores the element with no error.

### Common Pitfalls
- **`default_button` fires twice**: It sends the same command on press (value=1) and release (value=0). Toggle handlers must guard with `and value == 1`, otherwise they double-fire.
- **`default_2_position_tumb` sends {-1, 1}**, not {0, 1}. Handlers must check `value == -1` for the "off" position, not `value == 0`.
- **Connector name ≠ handler variable name**: The element key in clickabledata.lua is what DCS looks up on the EDM. Internal variable names in handlers are irrelevant to wiring.
- **light_control.lua connector references**: Three-step pattern — declare `connector["NAME"] = nil`, get reference in `post_initialize()`, call `:update()` in `update()`. The NAME must match the clickabledata.lua element key exactly.
- **Rotary knob patterns differ**: Radar rotaries (PNT_RADAR_MODE, EL, RANGE) use `rotvalue` gain (~0.667), relative=false, and handlers check value==0/1 at endpoints. Other rotaries (HUD_BRT, MODE_F15, WAYPOINT, ALTIMETER, RADAR_AZ) use gain=100/15, relative=true, and handlers check value>0 / value<0.

---

## Commented-Out / Deferred Elements
Six elements in clickabledata.lua are commented out because their connector names do not exist on the current EDM. They have handlers in light_control.lua / clickable.lua but cannot be wired until the EDM is updated:
- `EXT_LT_POSITION` — Position lights rotary
- `EXT_LT_FORMATION` — Formation lights rotary
- `TMB_MISC_TAXI-LIGHT` — Taxi light toggle (superseded by PNT_LANDING_LIGHTS)
- `TMB_EXT-LT_ANTI-COLLISION` — Anti-collision light toggle
- `INTERIOR_FLT-INST` — Cockpit illumination rotary
- `RADAR_SPL-MODE` — Radar special mode rotary

---

## Development Workflow

### To Add a New Clickable Control:
1. Add element definition to **clickabledata.lua** with the connector name from the EDM and the appropriate device
2. Add a new command to **command_defs.lua** `device_commands` table (if not reusing an existing one)
3. Add the handler to the appropriate SYSTEMS file:
   - Generic action → **clickable.lua** `SetCommand()`
   - Lighting logic → **light_control.lua** `SetCommand()`
   - Radar logic → **radar_control.lua** `SetCommand()`
4. If the control needs a param for visual feedback, add a gauge to **mainpanel_init.lua**
5. Test with clickable mode toggled on (LAlt+C)

### To Add a New Animation:
1. Find the connector name on `F-15C-CLICKABLE.edm`
2. If it needs a param-driven gauge: add to **mainpanel_init.lua** with the draw arg number
3. If it needs frame-by-frame logic: add to the appropriate SYSTEMS update() loop
4. If it's a simple element visual: add to **PNT_update.lua**

### Building for Distribution:
1. Run `./build.sh` (or `./build.sh v1.2.3` for specific version)
2. Zip is created in `dist/`
3. Distribute for OVGME installation

---

## Current Features (v1.1.7)
All controls below are wired to EDM connectors and active:
- **Engine**: Start/stop L/R, power on/off, cutoff L/R
- **Flight surfaces**: Flaps, airbrake, trim (L/R/U/D), takeoff trim
- **Weapons & targeting**: Fire/pickle, station select, target lock/unlock, target designator (L/R/U/D), jettison (weapons, tanks, emergency)
- **Countermeasures**: Chaff, flare, single-button release (F-15C), ECM/JAM
- **Lights**: Nav lights toggle, landing/taxi lights (with lever sync), anti-collision flash, formation intensity, cockpit illumination
- **Radar**: On/off, master mode select (BVR/VS/Bore), PRF, EL scan (auto-stop), AZ scan area, range zoom, SPL/Flood mode
- **Autopilot/CAS**: Altitude hold, attitude hold, yaw/roll/pitch augmentation
- **HUD**: Brightness, color toggle
- **Instruments**: Altimeter pressure, elapsed clock reset, bingo fuel index
- **Navigation**: Nav mode, waypoint selector
- **Fuel**: Dump on/off, refueling port toggle, quantity test/selector
- **Misc**: Mirrors, RWR mode+volume, emergency brakes, canopy, eject, master combat mode selector
