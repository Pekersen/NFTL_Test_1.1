class_name Moon extends CelestialObject

@export var rotationPoint : Node3D

var distance : float
var tidally_locked : bool
var orbit_speed : float
var rotation_speed : float

var orbit_angle : float # may have to be a vector to account for x and z rotation

const ORBIT_SPEED_YEAR := PI/6
func orbit(delta):
	rotationPoint.rotate_y(ORBIT_SPEED_YEAR * orbit_speed * delta)
