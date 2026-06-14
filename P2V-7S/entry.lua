-- P2V-7S Neptune — DCS World community mod
-- Set AFMenabled to true once Neptune.dll EFM is built
local AFMenabled = false

bin = {}
if AFMenabled == true then
    bin = {'Neptune'}
end

local self_ID = "P2V-7S"
declare_plugin(self_ID,
{
    installed    = true,
    dirName      = current_mod_path,
    displayName  = _("P2V-7S Neptune"),
    fileMenuName = _("P2V-7S"),
    update_id    = "P2V-7S",
    version      = "0.1.0",
    state        = "installed",
    info         = _("P2V-7S Neptune\n\nThe Lockheed P-2 Neptune was a maritime patrol and anti-submarine warfare aircraft. The P2V-7S variant featured twin Wright R-3350 radial engines supplemented by twin Westinghouse J34 turbojet pods, along with MAD, sonobuoy, and Jezebel/Julie ASW systems."),

    binaries     = bin,

    Skins =
    {
        {
            name = _("P2V-7S"),
            dir  = "Liveries/P2V-7S",
        },
    },
    --Missions =
    --{
    --    {
    --        name = _("P2V-7S"),
    --        dir  = "Missions",
    --    },
    --},
    LogBook =
    {
        {
            name = _("P2V-7S"),
            type = "P2V-7S",
        },
    },
    InputProfiles =
    {
        ["P2V-7S"] = current_mod_path .. '/Input',
    },
    --Options =
    --{
    --    {
    --        name   = _("P2V-7S"),
    --        nameId = "P2V-7S",
    --        dir    = "Options",
    --        CLSID  = "{P2V-7S options}",
    --    },
    --},
})

-- Mount asset paths
mount_vfs_model_path    (current_mod_path.."/Shapes")
mount_vfs_model_path    (current_mod_path.."/Cockpit/Shapes")
mount_vfs_liveries_path (current_mod_path.."/Liveries")
mount_vfs_texture_path  (current_mod_path.."/Cockpit/Textures")
mount_vfs_texture_path  (current_mod_path.."/Textures")
-- mount_vfs_sound_path    (current_mod_path.."/Sounds")  -- enable when sound files exist

-- Flight model
if AFMenabled == true then
    dofile(current_mod_path.."/Entry/Suspension.lua")
    local FM =
    {
        [1] = self_ID,
        [2] = 'P2V-7S',
        center_of_mass    = {0.0, 0.0, 0.0},
        moment_of_inertia = {200000, 350000, 250000, 0},
        suspension        = suspension,
    }
    make_flyable('P2V-7S', current_mod_path..'/Cockpit/Scripts/', FM, current_mod_path..'/comm.lua')
else
    make_flyable('P2V-7S', current_mod_path..'/Cockpit/Scripts/', nil, current_mod_path..'/comm.lua')
end

-- Load aircraft definition, weapons, payloads
dofile(current_mod_path..'/Weapons/P2V7S_Weapons.lua')
dofile(current_mod_path..'/P2V-7S.lua')
dofile(current_mod_path..'/UnitPayloads/P2V-7S.lua')

-- Load views
dofile(current_mod_path.."/Views.lua")
make_view_settings('P2V-7S', ViewSettings, SnapViews)

plugin_done()
