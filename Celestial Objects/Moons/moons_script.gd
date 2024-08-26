class_name Moon extends CelestialObject

@onready var rotationPoint = $RotationPoint

var distance : float
var tidally_locked : bool
var moon_orbit_speed : float
var rotation_speed : float

var moon_orbit_speed_variance : Array[float]

var orbit_angle : float # may have to be a vector to account for x and z rotation

const ORBIT_SPEED_YEAR := PI/6
func orbit(delta):
	rotationPoint.rotate_y(ORBIT_SPEED_YEAR * moon_orbit_speed * delta)
	
