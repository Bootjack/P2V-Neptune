-- P2V-7S Neptune landing gear suspension
-- Tricycle gear: nose wheel + two main gear

-- P2V-7S empty weight ~22,652 kg
local aircraft_weight = 22652.0

-- Nose gear
local nose_amortizer_min_length                 = 0.00
local nose_amortizer_max_length                 = 0.30
local nose_amortizer_basic_length               = 0.30
local nose_amortizer_reduce_length              = 0.02

local nose_amortizer_spring_force_factor        = 4.0e+06
local nose_amortizer_spring_force_factor_rate   = 2.0

local nose_amortizer_static_force               = aircraft_weight * 9.81 * 0.15
local nose_damper_force                         = 3.0e+04
local nose_amortizer_direct_damper_force_factor = nose_damper_force * 0.75
local nose_amortizer_back_damper_force_factor   = nose_damper_force

local nose_wheel_moment_of_inertia              = 1.0

-- Main gear
local main_amortizer_min_length                 = 0.00
local main_amortizer_max_length                 = 0.50
local main_amortizer_basic_length               = 0.50
local main_amortizer_reduce_length              = 25.0

local main_amortizer_spring_force_factor        = 8.0e+07
local main_amortizer_spring_force_factor_rate   = 3.5

local main_amortizer_static_force               = aircraft_weight * 9.81 * 0.85
local main_damper_force                         = 8.0e+04
local main_amortizer_direct_damper_force_factor = main_damper_force * 0.75
local main_amortizer_back_damper_force_factor   = main_damper_force

local main_damper_coeff                         = 100.0
local main_wheel_moment_of_inertia              = 4.0

-- Friction
local wheel_static_friction_factor              = 1.00
local wheel_side_friction_factor                = 0.45
local wheel_roll_friction_factor                = 0.04
local wheel_glide_friction_factor               = 0.20

local nose_wheel_static_friction_factor         = 0.65
local nose_wheel_side_friction_factor           = 0.55
local nose_wheel_roll_friction_factor           = 0.05
local nose_wheel_glide_friction_factor          = 0.60

local brake_moment_main                         = 12000.0

suspension =
{
    -- NOSE GEAR
    {
        anti_skid_installed                     = false,
        mass                                    = 80,
        damage_element                          = 83,
        moment_of_inertia                       = {15.0, 1.0, 15.0},
        wheel_axle_offset                       = 0.25,
        self_attitude                           = true,
        yaw_limit                               = math.rad(180.0),

        amortizer_min_length                    = nose_amortizer_min_length,
        amortizer_max_length                    = nose_amortizer_max_length,
        amortizer_basic_length                  = nose_amortizer_basic_length,
        amortizer_reduce_length                 = nose_amortizer_reduce_length,

        amortizer_spring_force_factor           = nose_amortizer_spring_force_factor,
        amortizer_spring_force_factor_rate       = nose_amortizer_spring_force_factor_rate,

        amortizer_static_force                  = nose_amortizer_static_force,
        amortizer_direct_damper_force_factor    = nose_amortizer_direct_damper_force_factor,
        amortizer_back_damper_force_factor      = nose_amortizer_back_damper_force_factor,

        wheel_radius                            = 0.35,
        wheel_static_friction_factor            = nose_wheel_static_friction_factor,
        wheel_side_friction_factor              = nose_wheel_side_friction_factor,
        wheel_roll_friction_factor              = nose_wheel_roll_friction_factor,
        wheel_glide_friction_factor             = nose_wheel_glide_friction_factor,
        wheel_damage_force_factor               = 350.0,
        wheel_damage_speed                      = 200.0,
        wheel_brake_moment_max                  = 0.0,
        wheel_moment_of_inertia                 = nose_wheel_moment_of_inertia,
        wheel_kz_factor                         = 0.3,
        noise_k                                 = 1.0,

        damper_coeff                            = main_damper_coeff,

        arg_amortizer                           = 1,
        arg_wheel_rotation                      = 101,
        arg_wheel_yaw                           = 1000,
        collision_shell_name                    = "WHEEL_F",
    },

    -- MAIN GEAR LEFT
    {
        anti_skid_installed                     = false,
        mass                                    = 300.0,
        damage_element                          = 84,
        moment_of_inertia                       = {150.0, 15.0, 150.0},
        wheel_axle_offset                       = 0.0,
        yaw_limit                               = 0.0,
        self_attitude                           = false,

        amortizer_min_length                    = main_amortizer_min_length,
        amortizer_max_length                    = main_amortizer_max_length,
        amortizer_basic_length                  = main_amortizer_basic_length,
        amortizer_reduce_length                 = main_amortizer_reduce_length,

        amortizer_spring_force_factor           = main_amortizer_spring_force_factor,
        amortizer_spring_force_factor_rate       = main_amortizer_spring_force_factor_rate,

        amortizer_static_force                  = main_amortizer_static_force,
        amortizer_direct_damper_force_factor    = main_amortizer_direct_damper_force_factor,
        amortizer_back_damper_force_factor      = main_amortizer_back_damper_force_factor,

        wheel_radius                            = 0.50,
        wheel_static_friction_factor            = wheel_static_friction_factor,
        wheel_side_friction_factor              = wheel_side_friction_factor,
        wheel_roll_friction_factor              = wheel_roll_friction_factor,
        wheel_glide_friction_factor             = wheel_glide_friction_factor,
        wheel_damage_force_factor               = 350.0,
        wheel_damage_speed                      = 200.0,
        wheel_brake_moment_max                  = brake_moment_main,
        wheel_moment_of_inertia                 = main_wheel_moment_of_inertia,
        wheel_kz_factor                         = 0.52,
        noise_k                                 = 0.4,

        damper_coeff                            = main_damper_coeff,

        arg_amortizer                           = 6,
        arg_wheel_rotation                      = 103,
        arg_wheel_yaw                           = -1,
        collision_shell_name                    = "WHEEL_L",
    },

    -- MAIN GEAR RIGHT
    {
        anti_skid_installed                     = false,
        mass                                    = 300.0,
        damage_element                          = 85,
        moment_of_inertia                       = {150.0, 15.0, 150.0},
        wheel_axle_offset                       = 0.0,
        yaw_limit                               = 0.0,
        self_attitude                           = false,

        amortizer_min_length                    = main_amortizer_min_length,
        amortizer_max_length                    = main_amortizer_max_length,
        amortizer_basic_length                  = main_amortizer_basic_length,
        amortizer_reduce_length                 = main_amortizer_reduce_length,

        amortizer_spring_force_factor           = main_amortizer_spring_force_factor,
        amortizer_spring_force_factor_rate       = main_amortizer_spring_force_factor_rate,

        amortizer_static_force                  = main_amortizer_static_force,
        amortizer_direct_damper_force_factor    = main_amortizer_direct_damper_force_factor / 2.0,
        amortizer_back_damper_force_factor      = main_amortizer_back_damper_force_factor,

        wheel_radius                            = 0.50,
        wheel_static_friction_factor            = wheel_static_friction_factor,
        wheel_side_friction_factor              = wheel_side_friction_factor,
        wheel_roll_friction_factor              = wheel_roll_friction_factor,
        wheel_glide_friction_factor             = wheel_glide_friction_factor,
        wheel_damage_force_factor               = 350.0,
        wheel_damage_speed                      = 200.0,
        wheel_brake_moment_max                  = brake_moment_main,
        wheel_moment_of_inertia                 = main_wheel_moment_of_inertia,
        wheel_kz_factor                         = 0.52,
        noise_k                                 = 0.4,

        damper_coeff                            = main_damper_coeff,

        arg_amortizer                           = 4,
        arg_wheel_rotation                      = 102,
        arg_wheel_yaw                           = -1,
        collision_shell_name                    = "WHEEL_R",
    },
}
