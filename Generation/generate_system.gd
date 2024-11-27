class_name GenerateSystem extends GenerateCluster

@export_subgroup("Variance")
@export var num_planets_variance : Array[int] = [0, 0] # so size = 2
@export var num_astroids_variance : Array[int] = [0, 0]

@onready var planet = preload("res://Celestial Objects/Planets/planet.tscn")
@onready var star = preload("res://Celestial Objects/Stars/star.tscn")
@onready var moon = preload("res://Celestial Objects/Moons/moon.tscn")
@onready var ring = preload("res://Celestial Objects/Rings/ring.tscn")

var num_planets : int
var num_astroids : int
var star_type : String
var num_moons : int
var num_rings : int
var planet_type : String

var planet_radius_variance : Array[float]

var num_moons_variance : Array[float]
var num_rings_variance : Array[float]
var ring_size_variance : Array[float]

var orbit_sum := 0.0
var planetInstance_distance
var planetInstance_individual_distance
var moonInstance_distance
var planet_post_distance = 0.0

var planetInstance_distance_variance : Array[float]

var moon_sum := 0.0

var orbit_speed_variance : Array[float] = [0.1,1]
var moon_orbit_speed_variance : Array[float] = [0.1,1]
var ring_size
var ring_max

var star_rad : float

var radius : float

var color_r : float
var color_g : float
var color_b : float
var color_variance_r : Array[float]
var color_variance_g : Array[float]
var color_variance_b : Array[float]
var all_colors : Array[float]

signal star_gen(star_type)

func initVars():
	print(num_planets_variance)
	star_type = pick_star_type()
	star_rad = star_type_to_rad()
	num_planets = offsetValue(num_planets_variance)
	num_astroids = offsetValue(num_astroids_variance)
	print(star_type)

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
		
		orbit_sum += planetInstance_individual_distance
		
		print("Planet distannce: ", str(planetInstance.semi_major_axis))
		add_child(planetInstance)
		for j in range(num_moons):
			var moonInstance = initMoon()
			planetInstance.get_node("RotationPoint/Core").add_child(moonInstance)
		
		for k in range(num_rings):
			var ringInstance = initRing()
			planetInstance.get_node("RotationPoint/Core").add_child(ringInstance)
			#print("Ring Size 2: " + str(ring_size))

func initPlanetVars(planetInstance):
	# TEMP VALUES
	# Axial tilt
	planetInstance.core.rotation.x = offsetValue([-0.3,0.3])
	planetInstance.core.rotation.z = offsetValue([-0.3,0.3])
	# Orbital tilt
	planetInstance.rotation.x = offsetValue([-0.01,0.01])
	planetInstance.rotation.z = offsetValue([-0.01,0.01])
	
	var random_float = randf()
	if random_float < 0.6:
		planet_type = "Gas_Giant"
	else:
		planet_type = "Terrestrial_Planet"
		
	if (planetInstance.semi_major_axis > 250.0) and (planet_type == "Gas_Giant"):
		planet_type = "Ice_Giant"
		
	print(planet_type)
	
	if planet_type == "Gas_Giant":
		planet_radius_variance = [0.5,0.7] 
		num_moons_variance = [4,10]
		planetInstance_distance_variance = [11.0,20.0]
		random_float = randf()
		if random_float < 0.03:
			num_rings_variance = [50,100]
			ring_size_variance = [0.3,3.0]
			ring_max = 3.0
		elif random_float < 0.7:
			num_rings_variance = [2,15]
			ring_size_variance = [0.1,0.3]
			ring_max = 0.3
		else:
			ring_size_variance = [0.2,1.2]
			num_rings_variance = [30,50]
			ring_max = 1.2
			
		color_variance_r = [1,1]
		color_variance_g = [1,1]
		color_variance_b = [0.6,1]
			
	elif planet_type == "Terrestrial_Planet":
		planet_radius_variance = [0.2,0.35]
		num_moons_variance = [0,2]
		planetInstance_distance_variance = [5.0,11.0]
		random_float = randf()
		if random_float < 0.95:
			num_rings_variance = [0,0]
			ring_size_variance = [0,0]
			ring_max = 1.0
		else:
			num_rings_variance = [1,5]
			ring_size_variance = [0.1,0.2]
			ring_max = 0.2
		
		random_float = randf()
		if random_float < 0.5:
			var colors = offsetValue([0.2,0.8])
			color_variance_r = [colors, colors]
			color_variance_g = [colors, colors]
			color_variance_b = [colors, colors]
		else:
			color_variance_r = [1,1]
			color_variance_g = [0.5,0.8]
			color_variance_b = [0.3,0.5]
		
	elif planet_type == "Ice_Giant":
		planet_radius_variance = [0.35,0.5]
		num_moons_variance = [2,4]
		planetInstance_distance_variance = [15.0,30.0]
		random_float = randf()
		if random_float < 0.8:
			num_rings_variance = [1,10]
			ring_size_variance = [0.1,0.2]
			ring_max = 0.2
		else:
			num_rings_variance = [10,30]
			ring_size_variance = [0.2,0.8]
			ring_max = 0.8
		
		color_variance_r = [0.6,0.9]
		color_variance_g = [1,1]
		color_variance_b = [1,1]
	
	planetInstance_individual_distance = offsetValue(planetInstance_distance_variance)
	planetInstance_distance = planetInstance_individual_distance + orbit_sum + planet_post_distance#LOOK AT LATER
	planet_post_distance = planetInstance_individual_distance
	planetInstance.semi_major_axis = planetInstance_distance + star_rad
	planetInstance.orbital_period = planetInstance.semi_major_axis **(3.0/2)
	planetInstance.eccentricity = rng.randf_range(0, 0.1) #TODO: Make acurrate eccentricity values
	
	radius = offsetValue(planet_radius_variance)
	planetInstance.radius = radius
	num_moons = offsetValue(num_moons_variance)
	
	planetInstance.color_r = offsetValue(color_variance_r)
	planetInstance.color_g = offsetValue(color_variance_g)
	planetInstance.color_b = offsetValue(color_variance_b)
	
	num_rings = offsetValue(num_rings_variance)
	print("Number of rings: " + str(num_rings))
	
	print("Generate System script radius: " + str(planetInstance.radius))
	print("Generate System script orbital_period: " + str(planetInstance.orbital_period))
	print("Moons: " + str(num_moons))

func initMoon():
	var moonInstance = moon.instantiate()
	initMoonVars(moonInstance)
	moon_sum += moonInstance_distance
	return moonInstance
		
func initMoonVars(moonInstance):
	# TEMP VALUES
	moonInstance_distance = offsetValue([0.1, 0.3])
	moonInstance.semi_major_axis = moonInstance_distance + radius + ring_max + 1.0
	moonInstance.orbital_period = moonInstance.semi_major_axis **(3.0/2)
	moonInstance.eccentricity = rng.randf_range(0, 0.1) #TODO: Make acurrate eccentricity values
	moonInstance.radius = offsetValue([0.01,0.05])
	moonInstance.rotation.x = offsetValue([-0.3,0.3])
	moonInstance.rotation.z = offsetValue([-0.3,0.3])
	
	var colors = offsetValue([0.3,0.6])
	color_variance_r = [colors, colors]
	color_variance_g = [colors, colors]
	color_variance_b = [colors, colors]
	
	moonInstance.color_r = offsetValue(color_variance_r)
	moonInstance.color_g = offsetValue(color_variance_g)
	moonInstance.color_b = offsetValue(color_variance_b)
	
func initStar():
	star_gen.emit(star_type)
	
func initRing():
	var ringInstance = ring.instantiate()
	initRingVars(ringInstance)
	return ringInstance
	
func initRingVars(ringInstance):
	ring_size = offsetValue(ring_size_variance)
	ringInstance.semi_major_axis = ring_size + radius
	
	var colors = offsetValue([0.0,1.0])
	color_variance_r = [colors,colors]
	color_variance_g = [colors,colors]
	color_variance_b = [colors,colors]
	
	ringInstance.color_r = offsetValue(color_variance_r)
	ringInstance.color_g = offsetValue(color_variance_g)
	ringInstance.color_b = offsetValue(color_variance_b)
