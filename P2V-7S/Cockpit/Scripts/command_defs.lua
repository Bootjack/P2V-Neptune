start_custom_command   = 10000
local __count_custom = start_custom_command - 1
local function __custom_counter()
    __count_custom = __count_custom + 1
    return __count_custom
end

Keys =
{
    -- Standard DCS command IDs
    PlaneGear                       = 68,
    PlaneGearUp                     = 430,
    PlaneGearDown                   = 431,
    Canopy                          = 71,
    PlaneFlaps                      = 72,
    PlaneFlapsOn                    = 145,
    PlaneFlapsOff                   = 146,
    PlaneAirBrake                   = 73,
    PlaneAirBrakeOn                 = 147,
    PlaneAirBrakeOff                = 148,
    PlaneLightsOnOff                = 175,
    PlaneHeadlightOnOff             = 328,
    PowerOnOff                      = 315,
    BatteryPower                    = 1073,
    PowerGeneratorLeft              = 711,
    PowerGeneratorRight             = 712,

    ---- Custom commands: 10000+ ----
    -- Reserve 10000-10049: Flight controls
    BrakesOn                        = __custom_counter(),  -- 10000
    BrakesOff                       = __custom_counter(),  -- 10001
    BrakesOnLeft                    = __custom_counter(),  -- 10002
    BrakesOffLeft                   = __custom_counter(),  -- 10003
    BrakesOnRight                   = __custom_counter(),  -- 10004
    BrakesOffRight                  = __custom_counter(),  -- 10005
    NWSEngage                       = __custom_counter(),  -- 10006
    NWSDisengage                    = __custom_counter(),  -- 10007
    ParkingBrakeToggle              = __custom_counter(),  -- 10008
}

-- Device-specific commands (used by cockpit clickable controls)
start_device_command = 3000
local __count_device = start_device_command - 1
local function __device_counter()
    __count_device = __count_device + 1
    return __count_device
end

device_commands =
{
    -- Electrical
    BatterySwitch                   = __device_counter(),  -- 3000
    GenLeftSwitch                   = __device_counter(),  -- 3001
    GenRightSwitch                  = __device_counter(),  -- 3002

    -- Engines
    ThrottleLeft                    = __device_counter(),  -- 3003
    ThrottleRight                   = __device_counter(),  -- 3004
    ThrottleJetLeft                 = __device_counter(),  -- 3005
    ThrottleJetRight                = __device_counter(),  -- 3006
    MixtureLeft                     = __device_counter(),  -- 3007
    MixtureRight                    = __device_counter(),  -- 3008
    PropRPMLeft                     = __device_counter(),  -- 3009
    PropRPMRight                    = __device_counter(),  -- 3010
    StarterLeft                     = __device_counter(),  -- 3011
    StarterRight                    = __device_counter(),  -- 3012
    StarterJetLeft                  = __device_counter(),  -- 3013
    StarterJetRight                 = __device_counter(),  -- 3014

    -- Gear & flaps
    GearHandle                      = __device_counter(),  -- 3015
    FlapHandle                      = __device_counter(),  -- 3016

    -- Lights
    NavLightsSwitch                 = __device_counter(),  -- 3017
    LandingLightSwitch              = __device_counter(),  -- 3018
    TaxiLightSwitch                 = __device_counter(),  -- 3019

    -- Canopy / hatch
    HatchHandle                     = __device_counter(),  -- 3020
}
