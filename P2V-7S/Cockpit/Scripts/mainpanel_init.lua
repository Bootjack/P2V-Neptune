shape_name       = "Cockpit_P2V-7S"
is_EDM           = true
new_model_format = true

ambient_light               = {255, 255, 255}
ambient_color_day_texture    = {72, 100, 160}
ambient_color_night_texture  = {40, 60, 150}
ambient_color_from_devices   = {50, 50, 40}
ambient_color_from_panels    = {35, 25, 25}

dusk_border          = 0.4
draw_pilot           = false
use_external_views   = true

day_texture_set_value   = 0.0
night_texture_set_value = 0.1

local controllers = LoRegisterPanelControls()

---------------------------------------------------------------
-- Control surface position gauges (driven by FM parameters)
---------------------------------------------------------------
StickPitch                   = CreateGauge("parameter")
StickPitch.arg_number        = 2
StickPitch.input             = {-1, 1}
StickPitch.output            = {-1, 1}
StickPitch.parameter_name    = "STICK_PITCH"

StickBank                    = CreateGauge("parameter")
StickBank.arg_number         = 3
StickBank.input              = {-1, 1}
StickBank.output             = {-1, 1}
StickBank.parameter_name     = "STICK_ROLL"

RudderPedals                 = CreateGauge("parameter")
RudderPedals.arg_number      = 4
RudderPedals.input           = {-1, 1}
RudderPedals.output          = {-1, 1}
RudderPedals.parameter_name  = "RUDDER_PEDALS"

---------------------------------------------------------------
-- Landing gear position
---------------------------------------------------------------
GearNose                     = CreateGauge("parameter")
GearNose.arg_number          = 0
GearNose.input               = {0, 1}
GearNose.output              = {0, 1}
GearNose.parameter_name      = "GEAR_NOSE"

GearLeft                     = CreateGauge("parameter")
GearLeft.arg_number          = 5
GearLeft.input               = {0, 1}
GearLeft.output              = {0, 1}
GearLeft.parameter_name      = "GEAR_LEFT"

GearRight                    = CreateGauge("parameter")
GearRight.arg_number         = 3
GearRight.input              = {0, 1}
GearRight.output             = {0, 1}
GearRight.parameter_name     = "GEAR_RIGHT"

---------------------------------------------------------------
-- Canopy / entry hatch
---------------------------------------------------------------
Canopy                       = CreateGauge()
Canopy.arg_number            = 38
Canopy.input                 = {0, 1}
Canopy.output                = {0, 0.9}
Canopy.controller            = controllers.base_gauge_CanopyPos

---------------------------------------------------------------
-- Throttle levers (will be driven by device scripts later)
---------------------------------------------------------------
ThrottleLeft                 = CreateGauge("parameter")
ThrottleLeft.arg_number      = 104
ThrottleLeft.input           = {0, 1}
ThrottleLeft.output          = {0, 1}
ThrottleLeft.parameter_name  = "THROTTLE_LEFT"

ThrottleRight                = CreateGauge("parameter")
ThrottleRight.arg_number     = 105
ThrottleRight.input          = {0, 1}
ThrottleRight.output         = {0, 1}
ThrottleRight.parameter_name = "THROTTLE_RIGHT"

---------------------------------------------------------------
-- Flaps position
---------------------------------------------------------------
Flaps                        = CreateGauge("parameter")
Flaps.arg_number             = 9
Flaps.input                  = {0, 1}
Flaps.output                 = {0, 1}
Flaps.parameter_name         = "FLAPS"
