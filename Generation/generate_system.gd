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
var planet_type : String

var planet_radius_variance : Array[float]
var num_moons_variance : Array[float]

var orbit_sum := 0.0
var planetInstance_distance
var moonInstance_distance

var orbit_speed_variance : Array[float] = [0.1,1]
var moon_orbit_speed_variance : Array[float] = [0.1,1]

var star_rad : float

signal star_gen(star_type)

func initVars():
	print(num_planets_variance)
	star_type = pick_star_type()
	star_rad = star_type_to_rad()
	num_planets = offsetValue(num_planets_variance)
	num_astroids = offsetValue(num_astroids_variance)
	

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
		
		
func star_type_to_rad():
	if star_type == "O":
		return 20
	elif star_type == "B":
		return 13.2
	elif star_type == "A":
		return 3.6
	elif star_type == "F":
		return 2.8
	elif star_type == "G":
		return 2.2
	elif star_type == "K":
		return 1.8
	else:
		return 1.4

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
		
		orbit_sum += planetInstance_distance
		
		print("Here: " + str(planetInstance.distance))
		add_child(planetInstance)
		for j in range(num_moons):
			var moonInstance = initMoon()
			planetInstance.get_node("RotationPoint/Core").add_child(moonInstance)
		

func initPlanetVars(planetInstance):
	# TEMP VALUES
	var random_float = randf()
	if random_float < 0.5:
		planet_type = "Gas_Giant"
	else:
		planet_type = "Terrestrial_Planet"
	
	planetInstance_distance = offsetValue([11.0,20.0]) + orbit_sum #LOOK AT LATER
	planetInstance.distance = planetInstance_distance + star_rad
	planetInstance.orbit_speed = offsetValue(orbit_speed_variance)
	
	if planet_type == "Gas_Giant":
		planet_radius_variance = [0.4,0.7] 
		num_moons_variance = [4,10]
	elif planet_type == "Terrestrial_Planet":
		planet_radius_variance = [0.2,0.4]
		num_moons_variance = [0,2]
		
	planetInstance.radius = offsetValue(planet_radius_variance)
	num_moons = offsetValue(num_moons_variance)
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
	moonInstance.radius = offsetValue([0.01,0.05])
	
func initStar():
	star_gen.emit(star_type)
	
	
