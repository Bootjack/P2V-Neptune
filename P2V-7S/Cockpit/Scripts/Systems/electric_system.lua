dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."utils.lua")

local dev = GetSelf()
local update_time_step = 0.02
make_default_activity(update_time_step)

local battery_on = false

dev:listen_command(Keys.BatteryPower)

function post_initialize()
    local birth = LockOn_Options.init_conditions.birth_place
    if birth == "GROUND_HOT" or birth == "AIR_HOT" then
        battery_on = true
    end
end

function SetCommand(command, value)
    if command == Keys.BatteryPower then
        battery_on = not battery_on
    end
end

function update()
end
