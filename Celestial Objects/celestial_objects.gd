class_name CelestialObject extends Node3D

var radius : float
var mass : float
var temperature : float # THIS IS THE AVERAGE TEMPERATURE, NOT THE CURRENT TEMP

# for randomness
var rng = RandomNumberGenerator.new()

# offsets
var radius_variance : Array[float]
var mass_variance : Array[float]
var temperature_variance : Array[float]


# When clicking on an object, there will be additional space where the click will go through even
# though user is clicking on nothing visually
var click_forgiveness : float = 1.0

func offsetValue(offset : Array[float]):
	return rng.randf_range(offset[0], offset[1])
