dofile(LockOn_Options.script_path .. "devices.lua")
dofile(LockOn_Options.script_path .. "command_defs.lua")
dofile(LockOn_Options.script_path .. "clickable_defs.lua")

elements = {}

------------------------------------------------------------------------
-- Electrical panel
------------------------------------------------------------------------

-- Battery switch (arg 50: 0 = OFF, 1 = ON)
-- Mouse-wheel or left/right click toggles the rocker.
-- SetCommand receives value=+1 (on) or -1 (off).
elements["PNT_BATTERY_SW"] = default_2_position_tumb(
    "Battery Switch",
    devices.ELECTRIC_SYSTEM,
    device_commands.BatterySwitch,
    50
)
