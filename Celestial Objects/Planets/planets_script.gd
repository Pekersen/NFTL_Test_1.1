class_name Planet extends CelestialObject

@export var rotationPoint : Node3D


var distance : float
var num_moons : int
var rings : bool
var ring_size : float
var tidally_locked : bool
var rotation_speed : float
var tilt : float

var atmospheric_composition : Array[float]

const ORBIT_SPEED_YEAR := PI/6
var orbit_speed : float
func orbit(delta):
	rotationPoint.rotate_y(ORBIT_SPEED_YEAR * orbit_speed * delta)

# Offset values
var distance_variance : Array[float]
var num_moons_variance : Array[float]
var ring_size_variance : Array[float]
var rotation_speed_variance : Array[float]
var tilt_variance : Array[float]
var atomospheric_composition_variance : Array[float]
var orbit_speed_variance : Array[float]
