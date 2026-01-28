class_name Planet extends CelestialObject

@export var rotationPoint : Node3D

var num_moons : int
var rings : bool
var ring_size : float
var tidally_locked : bool

var atmospheric_composition : Array[float]

var color_r : float
var color_g : float
var color_b : float

# Offset values
var distance_variance : Array[float]
var num_moons_variance : Array[float]
var ring_size_variance : Array[float]
var atomospheric_composition_variance : Array[float]
var orbit_speed_variance : Array[float]


func _ready():
	can_orbit = true
