local KG_TO_POUNDS  = 2.20462
local POUNDS_TO_KG  = 1/KG_TO_POUNDS
local FEET_TO_M     = 0.3048

-- P2V-7S Neptune specifications
-- Empty weight:   ~49,935 lbs (22,652 kg)
-- Max takeoff:    ~79,895 lbs (36,228 kg)
-- Internal fuel:  ~2,910 US gal (~8,000 kg avgas + jet fuel)
-- Wingspan:       103 ft 10 in (31.65 m)
-- Length:          91 ft 8 in (27.94 m)
-- Height:         28 ft 1 in (8.56 m)
-- Wing area:      1,000 sq ft (92.9 m2)
-- Engines:        2x Wright R-3350-32W (3,500 hp each) + 2x Westinghouse J34-WE-36 (3,400 lbf each)

P2V_7S = {
    Name                 = 'P2V-7S',
    DisplayName          = _('P2V-7S Neptune'),
    ViewSettings         = ViewSettings,

    Countries = {
        "Australia",
        "Argentina",
        "Brazil",
        "Canada",
        "Chile",
        "France",
        "Japan",
        "The Netherlands",
        "Portugal",
        "UK",
        "USA",
    },

    HumanCockpit         = false,
    HumanCockpitPath     = current_mod_path..'/Cockpit/',
    Picture              = "P2V-7S.png",
    Rate                 = 30,
    Shape                = "P2V-7S",

    shape_table_data =
    {
        {
            file       = 'P2V-7S',
            life       = 20,
            vis        = 3,
            desrt      = 'Fighter-2-crush',
            fire       = {300, 3},
            username   = 'P2V-7S',
            index      = WSTYPE_PLACEHOLDER,
            classname  = "lLandPlane",
            positioning = "BYNORMAL",
        },
    },

    net_animation = {
        0,  -- nose gear
        3,  -- right main gear
        5,  -- left main gear
        9,  -- right flap
        10, -- left flap
        11, -- right aileron
        12, -- left aileron
        15, -- right elevator
        16, -- left elevator
        17, -- rudder
        38, -- entry hatch
        190, -- nav light left
        191, -- nav light right
        192, -- tail light
    },

    -- WSTYPE_PLACEHOLDER must also key the unit (WorldID), not just the shape index — without
    -- it the type registration is incomplete. (Added during crash #6 debugging; correct to keep.)
    WorldID     = WSTYPE_PLACEHOLDER,

    mapclasskey = "P0091000025",
    attribute   = {wsType_Air, wsType_Airplane, wsType_Fighter, WSTYPE_PLACEHOLDER, "Bombers"},
    Categories  = {"{78EFB7A2-FD52-4b57-A6A6-3BF0E1D6555F}", "Interceptor"},

    Tasks = {
        aircraft_task(AntishipStrike),
        aircraft_task(GroundAttack),
        aircraft_task(Reconnaissance),
    },
    -- Reconnaissance for now: the aircraft is weaponless (Pylons={}, stores_number=0), so a
    -- strike default task gives the AI nothing to do. Switch to AntishipStrike once weapons exist.
    DefaultTask = aircraft_task(Reconnaissance),

    M_empty                     = 49935 * POUNDS_TO_KG,
    M_nominal                   = 61153 * POUNDS_TO_KG,
    M_max                       = 79895 * POUNDS_TO_KG,
    M_fuel_max                  = 17600 * POUNDS_TO_KG,
    H_max                       = 22000 * FEET_TO_M,

    length                      = 27.94,
    height                      = 8.56,
    wing_area                   = 92.9,
    wing_span                   = 31.65,
    wing_tip_pos                = {-3.0, -0.5, 15.8},
    wing_type                   = 0,
    flaps_maneuver              = 0.5,
    has_speedbrake              = false,

    RCS                         = 20.0,
    IR_emission_coeff           = 0.6,
    IR_emission_coeff_ab        = 0.6,

    stores_number               = 0,

    CAS_min                     = 41.2,
    V_opt                       = 103.0,
    V_take_off                  = 61.7,
    V_land                      = 51.4,
    V_max_sea_level             = 155.0,
    V_max_h                     = 155.0,
    Vy_max                      = 10.2,
    Mach_max                    = 0.48,
    Ny_min                      = -2.0,
    Ny_max                      = 3.5,
    Ny_max_e                    = 3.5,
    bank_angle_max              = 45,
    range                       = 5930,

    thrust_sum_max              = 3500 * 2 * 0.8,  -- placeholder (kg), kept consistent with SFM_Data.engine
    has_afteburner              = false,
    has_differential_stabilizer = false,
    thrust_sum_ab               = 3500 * 2 * 0.8,
    average_fuel_consumption    = 0.5,
    is_tanker                   = false,

    -- SFM_Data: Simplified Flight Model aerodynamics + engine tables. REQUIRED while AFMenabled
    -- = false — the SFM/AI flight model is built from this at spawn, and its ABSENCE was crash
    -- #6 (a null-deref in the flight-model FSM, invariant to model/params/make_flyable). These
    -- are rough placeholders so the aircraft spawns and flies adequately; the EFM (Neptune.dll)
    -- will replace this in a later phase. See DEVLOG 2026-06-14.
    SFM_Data = {
        aerodynamics = {
            Cy0      = 0.0,
            Mzalfa   = 6.0,
            Mzalfadt = 0.7,
            kjx      = 4.5,
            kjz      = 0.0012,
            Czbe     = -0.016,
            cx_gear  = 0.02,
            cx_flap  = 0.05,
            cy_flap  = 0.30,
            cx_brk   = 0.0,
            table_data = {
            --   M      Cx0     Cya     B      B4    Omxmax  Aldop   Cymax
                {0.0,   0.020,  0.090,  0.15,  0.0,   1.0,   18.0,   1.4},
                {0.2,   0.020,  0.090,  0.15,  0.0,   2.0,   18.0,   1.4},
                {0.4,   0.022,  0.085,  0.15,  0.0,   3.0,   16.0,   1.2},
                {0.5,   0.026,  0.080,  0.16,  0.0,   3.0,   14.0,   1.0},
            },
        },
        engine = {
            Nmg     = 60.0,
            MinRUD  = 0,
            MaxRUD  = 1,
            MaksRUD = 1,
            ForsRUD = 1,
            typeng  = 0,        -- E_TURBOJET (simplest placeholder until EFM models recip+jet)
            hMaxEng = 8,
            dcx_eng = 0.01,
            cemax   = 0.2,
            cefor   = 0.2,
            dpdh_m  = 5000,
            dpdh_f  = 5000,
            table_data = {
            --   M     Pmax    Pfor
                {0.0,  5600,   5600},
                {0.5,  4000,   4000},
            },
        },
    },

    tand_gear_max               = math.rad(60.0),

    engines_count    = 4,
    engines_nozzles  =
    {
        [1] = -- Left R-3350
        {
            pos              = {2.0, -0.5, -4.5},
            elevation        = 0.0,
            diameter         = 1.4,
            exhaust_length_ab = 0.01,
            exhaust_length_ab_K = 0.707,
            smokiness_level  = 0.5,
        },
        [2] = -- Right R-3350
        {
            pos              = {2.0, -0.5, 4.5},
            elevation        = 0.0,
            diameter         = 1.4,
            exhaust_length_ab = 0.01,
            exhaust_length_ab_K = 0.707,
            smokiness_level  = 0.5,
        },
        [3] = -- Left J34 jet pod
        {
            pos              = {0.5, -1.0, -5.5},
            elevation        = 0.0,
            diameter         = 0.4,
            exhaust_length_ab = 0.01,
            exhaust_length_ab_K = 0.707,
            smokiness_level  = 0.3,
        },
        [4] = -- Right J34 jet pod
        {
            pos              = {0.5, -1.0, 5.5},
            elevation        = 0.0,
            diameter         = 0.4,
            exhaust_length_ab = 0.01,
            exhaust_length_ab_K = 0.707,
            smokiness_level  = 0.3,
        },
    },

    -- sounderName left disabled until sound files exist (an empty Sounds path caused crash #1).
    -- sounderName          = "Aircraft/Planes/P2V-7S",

    crew_size    = 7,
    crew_members =
    {
        [1] =
        {
            ejection_seat_name  = 0,
            pos                 = {10.5, 0.5, -0.4},
            canopy_pos          = {10.5, 1.5, -0.4},
            g_suit              = 3.0,
        },
    },

    mechanimations = {
        Door0 = {
            {Transition = {"Close", "Open"},  Sequence = {{C = {{"Arg", 38, "to", 0.9, "in", 3.0}}}}, Flags = {"Reversible"}},
            {Transition = {"Open", "Close"},  Sequence = {{C = {{"Arg", 38, "to", 0.0, "in", 3.0}}}}, Flags = {"Reversible", "StepsBackwards"}},
        },
    },

    fires_pos =
    {
        [1]  = {0.0,    1.0,    0.0},
        [2]  = {2.0,   -0.5,    4.5},
        [3]  = {2.0,   -0.5,   -4.5},
        [4]  = {-2.0,  -0.5,    8.0},
        [5]  = {-2.0,  -0.5,   -8.0},
        [6]  = {-2.0,  -0.5,   12.0},
        [7]  = {-2.0,  -0.5,  -12.0},
        [8]  = {-10.0,  1.5,    0.0},
        [9]  = {-12.0,  3.0,    0.0},
        [10] = {-12.0,  0.0,    0.0},
        [11] = {-6.0,   0.0,    0.0},
    },

    Pylons = {},

    -- Damage / collision model. Must be a 1:1 set with the collision-shell objects in the .edm:
    -- every key needs a matching shell (else "No cell for property records") and every shell
    -- needs a key here (else "No property record for cell"). Keys must be names DCS recognizes
    -- (see DCS\Scripts\Aircrafts\_Common\Damage.lua). Add a key only when you add the shell.
    Damage = verbose_to_dmg_properties
    {
        ["GEAR_FRONT"] = {critical_damage = 3},  -- cell 8  (nose gear)
        ["GEAR_L"]     = {critical_damage = 3},  -- cell 15 (left main gear)
        ["GEAR_R"]     = {critical_damage = 3},  -- cell 16 (right main gear)
        ["MAIN"]       = {critical_damage = 3},  -- cell 10 (fuselage hull)
    },

    DamageParts = {},

    lights_data = {
        typename = "collection",
        lights = {
            [1] = {
                typename = "collection",
                lights = {
                    {typename = "argumentlight", argument = 208},
                },
            },
            [2] = {},
            [3] = {
                typename = "collection",
                lights = {
                    {typename = "argumentlight", argument = 190},
                    {typename = "argumentlight", argument = 191},
                    {typename = "argumentlight", argument = 192},
                },
            },
            [4] = {},
            [5] = {},
            [6] = {},
            [7] = {},
        },
    },
}

add_aircraft(P2V_7S)
