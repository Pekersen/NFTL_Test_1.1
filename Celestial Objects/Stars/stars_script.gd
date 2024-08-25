class_name Star extends CelestialObject

var luminosity : float
var rotation_speed : float
#var num_planets : int
#var num_asteroids : int

var color_r : float
var color_g : float
var color_b : float

var rotation_speed_variance : Array[float]
var luminosity_variance : Array[float]
var color_variance_r : Array[float]
var color_variance_g : Array[float]
var color_variance_b : Array[float]

func star_rotate(delta):
	rotate_y(rotation_speed * delta)
