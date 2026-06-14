-- EFM Data Bus — bridge between cockpit Lua and C++ flight model
-- Currently a stub: no EFM DLL loaded yet. All parameter handles return defaults.

dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."utils.lua")

local dev = GetSelf()
local update_time_step = 0.02
make_default_activity(update_time_step)

local sensor_data = get_base_data()

function post_initialize()
end

function SetCommand(command, value)
end

function update()
end
