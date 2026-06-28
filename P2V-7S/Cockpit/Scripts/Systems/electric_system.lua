dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."utils.lua")

local dev = GetSelf()
local update_time_step = 0.02
make_default_activity(update_time_step)

------------------------------------------------------------------------
-- State
------------------------------------------------------------------------
local battery_on = false

------------------------------------------------------------------------
-- Exported parameters (read by mainpanel_init gauges)
------------------------------------------------------------------------
-- AMMETER: normalized bus current, -1..+1
--   -1 = full-scale discharge (battery powering bus, no alternator)
--    0 = zero current (battery off, or battery + alternator perfectly balanced)
--   +1 = full-scale charge (alternator charging battery)
local ammeter_param = get_param_handle("AMMETER")

------------------------------------------------------------------------
-- Electrical model constants
------------------------------------------------------------------------
-- Quiescent bus draw with avionics on: ~30 A (POC placeholder).
-- Full-scale on the gauge face: 60 A each direction.
local BUS_DRAW_AMPS  = 30.0
local FULL_SCALE_AMPS = 60.0

------------------------------------------------------------------------
-- Command listeners
------------------------------------------------------------------------
dev:listen_command(Keys.BatteryPower)           -- keyboard shortcut (1073)
dev:listen_command(device_commands.BatterySwitch) -- 3D cockpit rocker (3000)

------------------------------------------------------------------------
function post_initialize()
    local birth = LockOn_Options.init_conditions.birth_place
    if birth == "GROUND_HOT" or birth == "AIR_HOT" then
        battery_on = true
        -- Sync the clickable switch arg to ON (arg 50 → 1) without re-calling SetCommand.
        dev:performClickableAction(device_commands.BatterySwitch, 1, true)
    end
    ammeter_param:set(0)
end

------------------------------------------------------------------------
function SetCommand(command, value)
    if command == device_commands.BatterySwitch then
        -- value: +1 = toggled on, -1 = toggled off
        battery_on = (value == 1)

    elseif command == Keys.BatteryPower then
        -- Keyboard shortcut: mirror the 3D switch so they stay in sync.
        battery_on = not battery_on
        local sw_value = battery_on and 1 or -1
        dev:performClickableAction(device_commands.BatterySwitch, sw_value, true)
    end
end

------------------------------------------------------------------------
function update()
    local current_norm = 0.0
    if battery_on then
        -- No alternator modeled yet: battery discharges into the bus.
        current_norm = -BUS_DRAW_AMPS / FULL_SCALE_AMPS  -- ≈ -0.5
    end
    ammeter_param:set(current_norm)
end
