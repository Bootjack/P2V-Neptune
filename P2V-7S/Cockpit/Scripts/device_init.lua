mount_vfs_texture_archives("Bazar/Textures/AvionicsCommon")

dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.common_script_path.."tools.lua")
dofile(LockOn_Options.script_path.."materials.lua")

layoutGeometry = {}

MainPanel = {"ccMainPanel", LockOn_Options.script_path.."mainpanel_init.lua",
{
},
}

creators = {}

-- Core systems
creators[devices.ELECTRIC_SYSTEM]  = {"avSimpleElectricSystem", LockOn_Options.script_path.."Systems/electric_system.lua"}

-- EFM data bus
creators[devices.EFM_DATA_BUS]     = {"avLuaDevice", LockOn_Options.script_path.."EFM_Data_Bus.lua"}

-- Phase 2+: cockpit devices (uncomment as implemented)
--creators[devices.HYDRAULIC_SYSTEM] = {"avLuaDevice", LockOn_Options.script_path.."Systems/hydraulic_system.lua"}
--creators[devices.FUEL_SYSTEM]      = {"avLuaDevice", LockOn_Options.script_path.."Systems/fuel_system.lua"}
--creators[devices.ENGINE_LEFT]      = {"avLuaDevice", LockOn_Options.script_path.."Systems/engine_left.lua"}
--creators[devices.ENGINE_RIGHT]     = {"avLuaDevice", LockOn_Options.script_path.."Systems/engine_right.lua"}
--creators[devices.ENGINE_JET_LEFT]  = {"avLuaDevice", LockOn_Options.script_path.."Systems/engine_jet_left.lua"}
--creators[devices.ENGINE_JET_RIGHT] = {"avLuaDevice", LockOn_Options.script_path.."Systems/engine_jet_right.lua"}
--creators[devices.GEAR]             = {"avLuaDevice", LockOn_Options.script_path.."Systems/gear.lua"}
--creators[devices.FLAPS]            = {"avLuaDevice", LockOn_Options.script_path.."Systems/flaps.lua"}
--creators[devices.TRIM]             = {"avLuaDevice", LockOn_Options.script_path.."Systems/trim.lua"}
--creators[devices.AIRBRAKES]        = {"avLuaDevice", LockOn_Options.script_path.."Systems/airbrakes.lua"}
--creators[devices.CANOPY]           = {"avLuaDevice", LockOn_Options.script_path.."Systems/canopy.lua"}
--creators[devices.EXT_LIGHTS]       = {"avLuaDevice", LockOn_Options.script_path.."Systems/ext_lights.lua"}
--creators[devices.INT_LIGHTS]       = {"avLuaDevice", LockOn_Options.script_path.."Systems/int_lights.lua"}
--creators[devices.NAV]              = {"avLuaDevice", LockOn_Options.script_path.."Nav/nav.lua"}
--creators[devices.ILS]              = {"avILS",       LockOn_Options.script_path.."Nav/ils.lua", {devices.ELECTRIC_SYSTEM}}
--creators[devices.RADIO]            = {"avLuaDevice", LockOn_Options.script_path.."Systems/radio.lua"}
--creators[devices.WEAPON_SYSTEM]    = {"avSimpleWeaponSystem", LockOn_Options.script_path.."Systems/weapon_system.lua"}
--creators[devices.EXTANIM]          = {"avLuaDevice", LockOn_Options.script_path.."externalanimations.lua"}
--creators[devices.SOUNDSYSTEM]      = {"avLuaDevice", LockOn_Options.script_path.."Systems/sound_system.lua"}

-- Phase 6: ASW mission systems
--creators[devices.MAD]              = {"avLuaDevice", LockOn_Options.script_path.."Systems/mad.lua"}
--creators[devices.SONOBUOY]         = {"avLuaDevice", LockOn_Options.script_path.."Systems/sonobuoy.lua"}
--creators[devices.JEZEBEL]          = {"avLuaDevice", LockOn_Options.script_path.."Systems/jezebel.lua"}
--creators[devices.JULIE]            = {"avLuaDevice", LockOn_Options.script_path.."Systems/julie.lua"}
--creators[devices.SEARCHLIGHT]      = {"avLuaDevice", LockOn_Options.script_path.."Systems/searchlight.lua"}

indicators = {}

dofile(LockOn_Options.common_script_path.."KNEEBOARD/declare_kneeboard_device.lua")
dofile(LockOn_Options.common_script_path.."PADLOCK/PADLOCK_declare.lua")
