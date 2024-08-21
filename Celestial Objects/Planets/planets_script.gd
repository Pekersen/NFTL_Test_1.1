class_name Planet extends CelestialObject

@export var orbitMesh : MeshInstance3D


var distance : float
var num_moons : int
var rings : bool
var ring_size : float
var planet_temperature : float
var tidally_locked : bool

var atmospheric_composition : float

const ORBIT_SPEED_YEAR := PI/6
var orbit_speed : float
func orbit(delta):
	orbitMesh.rotate_y(ORBIT_SPEED_YEAR * orbit_speed * delta)

var rotation_speed : float
var tilt : float
