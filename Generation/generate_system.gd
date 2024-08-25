class_name SystemGeneration extends Node3D

@export_subgroup("Variance")
@export var num_planets_variance : Array[int] = [0, 0] # so size = 2
@export var num_astroids_variance : Array[int] = [0, 0]

@onready var planet = preload("res://Celestial Objects/Planets/planet.tscn")
@onready var star = preload("res://Celestial Objects/Stars/star.tscn")

var num_planets : int
var num_astroids : int
var star_type : String

var orbit_sum := 0.0

signal star_gen(star_type)

func initVars():
	print(num_planets_variance)
	num_planets = offsetValue(num_planets_variance)
	num_astroids = offsetValue(num_astroids_variance)
	
	star_type = pick_star_type()

# for randomness
var rng = RandomNumberGenerator.new()

func pick_star_type():
	var random_float = randf()

	if random_float < 0.01:
		return "O"
	elif random_float < 0.03:
		return "B"
	elif random_float < 0.05:
		return "A"
	elif random_float < 0.1:
		return "F"
	elif random_float < 0.15:
		return "G"
	elif random_float < 0.2:
		return "K"
	else:
		return "M"

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
		
		orbit_sum += planetInstance.distance
		
		print("Here: " + str(planetInstance.distance))
		
		add_child(planetInstance)
		

func initPlanetVars(planetInstance):
	# TEMP VALUES
	planetInstance.distance = offsetValue([11.0,20.0]) + orbit_sum #LOOK AT LATER
	planetInstance.orbit_speed = offsetValue([0.5,1.0])
	planetInstance.radius = offsetValue([0.1,0.5])
	
func initStar():
	star_gen.emit(star_type)
	
	
