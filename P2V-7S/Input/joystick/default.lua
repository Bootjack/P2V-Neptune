local folder = LockOn_Options.script_path or ""
local cscripts = folder.."../../Cockpit/Scripts/"
dofile(cscripts.."devices.lua")
dofile(cscripts.."command_defs.lua")

local res = external_profile("Config/Input/Aircrafts/common_joystick_binding.lua")

join(res.keyCommands, {
    -- Gear
    {down = Keys.PlaneGear, name = _('Landing Gear Toggle'), category = {_('Systems')}},

    -- Flaps
    {down = Keys.PlaneFlaps, name = _('Flaps Toggle'), category = {_('Flight Control')}},

    -- Canopy / Hatch
    {down = Keys.Canopy, name = _('Entry Hatch Toggle'), category = {_('Systems')}},

    -- Brakes
    {down = Keys.BrakesOn, up = Keys.BrakesOff, name = _('Wheel Brakes'), category = {_('Flight Control')}},
})

return res
