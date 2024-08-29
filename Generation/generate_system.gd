class_name SystemGeneration extends Node3D

@export_subgroup("Variance")
@export var num_planets_variance : Array[int] = [0, 0] # so size = 2
@export var num_astroids_variance : Array[int] = [0, 0]

@onready var planet = preload("res://Celestial Objects/Planets/planet.tscn")
@onready var star = preload("res://Celestial Objects/Stars/star.tscn")
@onready var moon = preload("res://Celestial Objects/Moons/moon.tscn")

var num_planets : int
var num_astroids : int
var star_type : String
var num_moons : int

var orbit_sum := 0.0
var planetInstance_distance
var moonInstance_distance

var orbit_speed_variance : Array[float] = [0.5,5.5]
var moon_orbit_speed_variance : Array[float] = [0.4,0.9]

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
	elif random_float < 0.04:
		return "B"
	elif random_float < 0.115:
		return "A"
	elif random_float < 0.215:
		return "F"
	elif random_float < 0.365:
		return "G"
	elif random_float < 0.565:
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
		for j in range(num_moons):
			var moonInstance = initMoon()
			planetInstance.get_node("RotationPoint/Core").add_child(moonInstance)
		

func initPlanetVars(planetInstance):
	# TEMP VALUES
	planetInstance_distance = offsetValue([11.0,20.0]) + orbit_sum #LOOK AT LATER
	planetInstance.distance = planetInstance_distance
	planetInstance.orbit_speed = offsetValue(orbit_speed_variance)
	planetInstance.radius = offsetValue([0.1,0.8])
	num_moons = offsetValue([1,4])
	print("Generate System script radius: " + str(planetInstance.radius))
	print("Generate System script orbit_speed: " + str(planetInstance.orbit_speed))
	print("Moons: " + str(num_moons))

func initMoon():
	var moonInstance = moon.instantiate()
	initMoonVars(moonInstance)
	return moonInstance
		
func initMoonVars(moonInstance):
	# TEMP VALUES
	moonInstance_distance = offsetValue([1.0,3.0])
	moonInstance.distance = moonInstance_distance
	moonInstance.moon_orbit_speed = offsetValue(moon_orbit_speed_variance)
	moonInstance.radius = offsetValue([0.02,0.2])
	
func initStar():
	star_gen.emit(star_type)
	
	
