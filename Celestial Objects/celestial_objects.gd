class_name CelestialObject extends Node3D

var radius : float
var mass : float

# for randomness
var rng = RandomNumberGenerator.new()

# offsets
var radius_variance : Array[float]
var mass_variance : Array[float]


# When clicking on an object, there will be additional space where the click will go through even
# though user is clicking on nothing visually
var click_forgiveness : float = 0.2

func offsetValue(value, offset : Array[float]):
	value += rng.randf_range(offset[0], offset[1])

