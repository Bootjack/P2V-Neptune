local folder = LockOn_Options.script_path or ""
local cscripts = folder.."../../Cockpit/Scripts/"
dofile(cscripts.."devices.lua")
dofile(cscripts.."command_defs.lua")

local res = external_profile("Config/Input/Aircrafts/common_joystick_binding.lua")

join(res.keyCommands, {
    -- Gear
    {combos = {{key = 'G'}}, down = Keys.PlaneGear, name = _('Landing Gear Toggle'), category = {_('Systems')}},
    {combos = {{key = 'G', reformers = {'LCtrl'}}}, down = Keys.PlaneGearUp, name = _('Landing Gear Up'), category = {_('Systems')}},
    {combos = {{key = 'G', reformers = {'LShift'}}}, down = Keys.PlaneGearDown, name = _('Landing Gear Down'), category = {_('Systems')}},

    -- Flaps
    {combos = {{key = 'F'}}, down = Keys.PlaneFlaps, name = _('Flaps Toggle'), category = {_('Flight Control')}},
    {combos = {{key = 'F', reformers = {'LShift'}}}, down = Keys.PlaneFlapsOn, name = _('Flaps Down'), category = {_('Flight Control')}},
    {combos = {{key = 'F', reformers = {'LCtrl'}}}, down = Keys.PlaneFlapsOff, name = _('Flaps Up'), category = {_('Flight Control')}},

    -- Canopy / Hatch
    {combos = {{key = 'C', reformers = {'LCtrl'}}}, down = Keys.Canopy, name = _('Entry Hatch Toggle'), category = {_('Systems')}},

    -- Lights
    {combos = {{key = 'L', reformers = {'RCtrl'}}}, down = Keys.PlaneLightsOnOff, name = _('Nav Lights Toggle'), category = {_('Systems')}},
    {combos = {{key = 'L', reformers = {'RAlt'}}}, down = Keys.PlaneHeadlightOnOff, name = _('Landing Light Toggle'), category = {_('Systems')}},

    -- Brakes
    {combos = {{key = 'W'}}, down = Keys.BrakesOn, up = Keys.BrakesOff, name = _('Wheel Brakes'), category = {_('Flight Control')}},

    -- Electrical
    {combos = {{key = 'B', reformers = {'LShift'}}}, down = Keys.BatteryPower, name = _('Battery Power Toggle'), category = {_('Systems')}},
})

return res
