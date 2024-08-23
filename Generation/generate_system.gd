class_name SystemGeneration extends Node3D

@export_subgroup("Variance")
@export var num_planets_variance : Array[int] = [0, 0] # so size = 2
@export var num_astroids_variance : Array[int] = [0, 0]

@onready var planet = preload("res://Celestial Objects/Planets/planet.tscn")

var num_planets : int
var num_astroids : int
var sun_type : String

func initVars():
	print(num_planets_variance)
	num_planets = offsetValue(num_planets_variance)
	num_astroids = offsetValue(num_astroids_variance)

# for randomness
var rng = RandomNumberGenerator.new()

func offsetValue(offset : Array):
	if typeof(offset[0]) == TYPE_FLOAT:
		return rng.randf_range(offset[0], offset[1])
	elif typeof(offset[0]) == TYPE_INT:
		return rng.randi_range(offset[0], offset[1])

func initPlanetChildren():
	print(num_planets)
	for i in range(num_planets):
		print("making planet...")
		var planetInstance = planet.instantiate()
		initPlanetVars(planetInstance)
		add_child(planetInstance)

func initPlanetVars(planetInstance):
	# TEMP VALUES
	planetInstance.distance = offsetValue([5.0,15.0])
	planetInstance.orbit_speed = offsetValue([0.5,1.0])
	planetInstance.radius = offsetValue([0.1,0.5])
