local count = 0
local function counter()
    count = count + 1
    return count
end

-------DEVICE ID-------
devices = {}

-- Core systems
devices["ELECTRIC_SYSTEM"]   = counter()  -- 1
devices["HYDRAULIC_SYSTEM"]  = counter()  -- 2
devices["FUEL_SYSTEM"]       = counter()  -- 3

-- Propulsion
devices["ENGINE_LEFT"]       = counter()  -- 4  R-3350 port
devices["ENGINE_RIGHT"]      = counter()  -- 5  R-3350 starboard
devices["ENGINE_JET_LEFT"]   = counter()  -- 6  J34 port pod
devices["ENGINE_JET_RIGHT"]  = counter()  -- 7  J34 starboard pod

-- Flight controls & airframe
devices["GEAR"]              = counter()  -- 8
devices["FLAPS"]             = counter()  -- 9
devices["TRIM"]              = counter()  -- 10
devices["AIRBRAKES"]         = counter()  -- 11

-- Cockpit
devices["CANOPY"]            = counter()  -- 12  Entry hatch
devices["EXT_LIGHTS"]        = counter()  -- 13
devices["INT_LIGHTS"]        = counter()  -- 14
devices["CLOCK"]             = counter()  -- 15

-- Navigation & radio
devices["NAV"]               = counter()  -- 16
devices["ILS"]               = counter()  -- 17
devices["RADIO"]             = counter()  -- 18
devices["INTERCOM"]          = counter()  -- 19

-- Weapons & stores
devices["WEAPON_SYSTEM"]     = counter()  -- 20

-- ASW mission systems (Phase 6)
devices["MAD"]               = counter()  -- 21  Magnetic Anomaly Detector
devices["SONOBUOY"]          = counter()  -- 22  Sonobuoy launcher
devices["JEZEBEL"]           = counter()  -- 23  Passive acoustic processor
devices["JULIE"]             = counter()  -- 24  Active acoustic processor
devices["SEARCHLIGHT"]       = counter()  -- 25  Belly searchlight

-- Sensors & defensive
devices["RWR"]               = counter()  -- 26
devices["COUNTERMEASURES"]   = counter()  -- 27

-- External animations & misc
devices["EXTANIM"]           = counter()  -- 28
devices["SOUNDSYSTEM"]       = counter()  -- 29

-- EFM bridge (must be present)
devices["EFM_DATA_BUS"]      = counter()  -- 30
