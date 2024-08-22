class_name Planet extends CelestialObject

@export var rotationPoint : Node3D
@export var orbitMesh : Node3D

var distance : float
var distance_offset : float
var num_moons : int
var rings : bool
var ring_size : float
var planet_temperature : float
var tidally_locked : bool

var atmospheric_composition : float

const ORBIT_SPEED_YEAR := PI/6
var orbit_speed : float
func orbit(delta):
	rotationPoint.rotate_y(ORBIT_SPEED_YEAR * orbit_speed * delta)

var rotation_speed : float
var tilt : float
