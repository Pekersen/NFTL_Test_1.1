class_name SystemGeneration extends Node3D

@export_subgroup("Variance")
@export var num_planets_variance : Array[int] = [0, 0] # so size = 2
@export var num_astroids_variance : Array[int] = [0, 0]

@onready var planet = preload("res://Celestial Objects/Planets/planet.tscn")

var num_planets : int
var num_astroids : int
#var star_types = ["M", "K", "G", "F", "A", "B", "O"]
var star_type : String

var orbit_sum := 0.0

func initVars():
	print(num_planets_variance)
	num_planets = offsetValue(num_planets_variance)
	num_astroids = offsetValue(num_astroids_variance)
	
	star_type = pick_star_type()
	
	#star_type = star_types.pick_random()
	print(star_type)

# for randomness
var rng = RandomNumberGenerator.new()

func pick_star_type():
	var random_float = randf()

	if random_float < 0.765:
		return "M"
	elif random_float < 0.121:
		return "K"
	elif random_float < 0.076:
		return "G"
	elif random_float < 0.03:
		return "F"
	elif random_float < 0.006:
		return "A"
	elif random_float < 0.0013:
		return "B"
	else:
		return "O"

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
		
		add_child(planetInstance)
		
func initStarChildren():
	pass
	#starInstance.radius = offsetValue([])

func initPlanetVars(planetInstance):
	# TEMP VALUES
	planetInstance.distance = offsetValue([5.0,15.0]) + orbit_sum
	planetInstance.orbit_speed = offsetValue([0.5,1.0])
	planetInstance.radius = offsetValue([0.1,0.5])
	
func initStarVars(starInstance):
	pass
