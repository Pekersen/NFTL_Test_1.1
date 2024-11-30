class_name Planet extends CelestialObject

@export var rotationPoint : Node3D
@export var core : Node3D

var num_moons : int
var rings : bool
var ring_size : float
var tidally_locked : bool
var rotation_speed : float

var atmospheric_composition : Array[float]

var color_r : float
var color_g : float
var color_b : float

# Offset values
var distance_variance : Array[float]
var num_moons_variance : Array[float]
var ring_size_variance : Array[float]
var rotation_speed_variance : Array[float]
var tilt_variance : Array[float]
var atomospheric_composition_variance : Array[float]
var orbit_speed_variance : Array[float]

# For Brown Dwarves
"""
var luminosity : float
var luminosity_variance : Array[float]

var color_r : float
var color_g : float
var color_b : float

var color_variance_r : Array[float]
var color_variance_g : Array[float]
var color_variance_b : Array[float]
"""

func _ready():
	can_orbit = true
