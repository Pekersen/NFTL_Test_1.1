extends Star

@onready var starMesh := $RotationPoint/Core/StarMesh
@onready var starCollision := $RotationPoint/Core/StarCollision
@onready var starLight := $RotationPoint/Core/StarLight
@onready var orbitMesh := $Orbit

var star_type : String
var star_names = ["Centauri", "Sol", "Bernard's Star", "Vega", "Proxima", "Polaris", "Betelgeuse", "Deneb", "Sirius"]
@export var star_name : String
@export var age : int

var small_star_probability : float
var big_star_probability : float

var star_count : int

var is_flipped := false

signal star_rad_for_cam(radius)

var orbit_path_visible = true

# ----- EXPERIMENTAL -----
var num_planets_variance = [0, 8] # so size = 2
@onready var planet = preload("res://Celestial Objects/Planets/planet.tscn")
@onready var moon = preload("res://Celestial Objects/Moons/moon.tscn")
@onready var ring = preload("res://Celestial Objects/Rings/ring.tscn")

var num_planets : int
var num_astroids : int
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

var planet_count_reduction = 1

'''
var color_r : float
var color_g : float
var color_b : float
var color_variance_r : Array[float]
var color_variance_g : Array[float]
var color_variance_b : Array[float]
'''
var all_colors : Array[float]

var major_axis : float
var planets : Array
var planets_semi : Array[float]
var planets_nodepaths : Array[String]

var atmosphere_present : bool
var atmosphere_size : float
var atmosphere_thickness : float
# ----- EXPERIMENTAL -----

func _ready():		
	# TEMP Values
	if star_count == 1:
		small_star_probability = 0.0
		big_star_probability = 1.0
		planet_count_reduction = 1
	elif star_count == 2:
		small_star_probability = 0.3
		big_star_probability = 0.01
		planet_count_reduction = 2
	elif star_count == 3:
		small_star_probability = 0.4
		big_star_probability = 0.0
		planet_count_reduction = 3
	
	initVars()
	initPlanetChildren()
	
	
func initVars():
	star_type = pick_star_type()
	print("Star Type: " + star_type)
	_on_system_star_gen(star_type)
	num_planets = offsetValue(num_planets_variance) / planet_count_reduction
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#star_rotate(delta)
	if can_orbit:
		orbit(delta, core)
		if is_flipped:
			core.position *= -1

func  _on_system_star_gen(star_type):
	self.star_type = star_type
	
	if star_type == "O":
		radius_variance = [13.2,20]
		mass_variance = [16,20]
		luminosity_variance = [50,70]
		temperature_variance = [33000, 50000]
		
		color_variance_r = [0.60,0.685]
		color_variance_g = [1,1]
		color_variance_b = [1,1]
		
	elif star_type == "B":
		radius_variance = [3.6,13.2]
		mass_variance = [2.1,16]
		luminosity_variance = [40,50]
		temperature_variance = [10000, 33000]
		
		color_variance_r = [0.685,0.875]
		color_variance_g = [1,1]
		color_variance_b = [1,1]
		
	elif star_type == "A":
		radius_variance = [2.8,3.6]
		mass_variance = [1.4,2.1]
		luminosity_variance = [20,30]
		temperature_variance = [7300, 10000]
		
		color_variance_r = [0.875,1]
		color_variance_g = [1,1]
		color_variance_b = [1,1]
		
	elif star_type == "F":
		radius_variance = [2.2,2.8]
		mass_variance = [1.04,1.4]
		luminosity_variance = [10,20]
		temperature_variance = [6000, 7300]
		
		color_variance_r = [1,1]
		color_variance_g = [1,1]
		color_variance_b = [0.8,1]
		
	elif star_type == "G":
		radius_variance = [1.8,2.2]
		mass_variance = [0.8,1.04]
		luminosity_variance = [5,10]
		temperature_variance = [5300, 6000]
		
		color_variance_r = [1,1]
		color_variance_g = [1,1]
		color_variance_b = [0.6,0.8]
		
	elif star_type == "K":
		radius_variance = [1.4,1.8]
		mass_variance = [0.45,0.8]
		luminosity_variance = [1,5]
		temperature_variance = [3900, 5300]
		
		color_variance_r = [1,1]
		color_variance_g = [0.7,0.8]
		color_variance_b = [0.4,0.6]
		
	elif star_type == "M":
		radius_variance = [1.2,1.4]
		mass_variance = [0.2,0.45]
		luminosity_variance = [0.6,1]
		temperature_variance = [2300, 3900]
		
		color_variance_r = [1,1]
		color_variance_g = [0.25,0.35]
		color_variance_b = [0.2,0.3]
		
	elif star_type == "L":
		radius_variance = [1.0,1.2]
		mass_variance = [0.1,0.2]
		luminosity_variance = [0.4,0.6]
		temperature_variance = [1300, 2000]
		
		color_variance_r = [0.6,0.7]
		color_variance_g = [0.2,0.25]
		color_variance_b = [0.1,0.2]
	
	elif star_type == "T":
		radius_variance = [0.8,1.0]
		mass_variance = [0.08,0.1]
		luminosity_variance = [0.2,0.4]
		temperature_variance = [700, 1300]
		
		color_variance_r = [0.5,0.6]
		color_variance_g = [0.2,0.25]
		color_variance_b = [0.2,0.3]
		
	elif star_type == "Y":
		radius_variance = [0.6,0.8]
		mass_variance = [0.05,0.08]
		luminosity_variance = [0.0,0.2]
		temperature_variance = [100, 700]
		
		color_variance_r = [0.3,0.5]
		color_variance_g = [0.25,0.3]
		color_variance_b = [0.3,0.4]
		
	
	rotation_speed_variance = [0,0]
	
	var random_float = randf()
	if random_float < 0.6:
		rotation_speed_variance = [0.02,0.03]
	elif random_float > 0.99:
		rotation_speed_variance = [11,12.5]
	else:
		rotation_speed_variance = [0.01,1.25]
		
	radius = offsetValue(radius_variance)
	mass = offsetValue(mass_variance)
	luminosity = offsetValue(luminosity_variance)
	temperature = offsetValue(temperature_variance)
	rotation_speed = offsetValue(rotation_speed_variance)
	
	color_r = offsetValue(color_variance_r)
	color_g = offsetValue(color_variance_g)
	color_b = offsetValue(color_variance_b)
	
	#TEMP
	#print("Color R: " + str(color_r) + ", Color G: " + str(color_g) + ", Color B: " + str(color_b))
	
	starMesh.mesh.radius = radius
	starMesh.mesh.height = radius * 2
	
	star_rad = radius
	
	starCollision.shape.radius = radius + click_forgiveness
	
	starLight.light_energy = luminosity
	
	starMesh.mesh.material.set_shader_parameter("Sun_Color", Color(color_r, color_g, color_b))
	starLight.light_color = Color(1.0, 1.0, 1.0)
	
	var name_index = offsetValue([0, star_names.size()])
	star_name = star_names[name_index - 1]
	
	star_rad_for_cam.emit(radius)
	

func init_orbit_mesh():
	orbitMesh.mesh.outer_radius = semi_major_axis + 0.1
	orbitMesh.mesh.inner_radius = semi_major_axis - 0.1
	major_axis = semi_major_axis
	orbitMesh.scale.z = semi_minor_axis/semi_major_axis
	orbitMesh.position.x = -sqrt(pow(semi_major_axis,2) - pow(semi_minor_axis,2))
	#print("mesh pos: ", orbitMesh.position.x)
	if is_flipped:
		orbitMesh.position.x *= -1

# For console
func get_star_info() -> String:
	# Command currently based on Star node being in Main. Will have to change eventually.
	return "Star type: " + str(star_type) + "\nRadius: " + str(radius) + "\nMass: " +\
	 	str(mass) + "\nLuminosity: " + str(luminosity) + "\nTemperature: " +\
		str(temperature) + "\nColor: R-" + str(color_r) + ", G-" + str(color_g) +\
		", B-" + str(color_b) + "\nRotation Speed: " + str(rotation_speed)

func set_star_type(newStarType : String):
	if newStarType == "random":
		newStarType = pick_star_type()
		_on_system_star_gen(newStarType)
	else:
		_on_system_star_gen(newStarType)
	return "Set star type to " + (str(newStarType))

# temp
func pick_star_type():
	var random_float = randf()
	

	if random_float < 0.01 * big_star_probability:
		return "O"
	elif random_float < 0.04 * big_star_probability:
		return "B"
	elif random_float < 0.115 * big_star_probability:
		return "A"
	elif random_float < 0.215:
		return "F"
	elif random_float < 0.365:
		return "G"
	elif random_float < 0.565:
		return "K"
	if random_float < 0.565 + (small_star_probability * 0.1):
		return "L"
	elif random_float < 0.565 + (small_star_probability * 0.2):
		return "T"
	elif random_float < 0.565 + (small_star_probability * 0.3):
		return "Y"
	else:
		return "M"
		
func _input(event):
	if event.is_action_pressed("lines") and orbit_path_visible == true:
		orbitMesh.visible = false
		orbit_path_visible = false
	elif event.is_action_pressed("lines") and orbit_path_visible == false:
		orbitMesh.visible = true
		orbit_path_visible = true

#===================================================================================
# E X P E R I M E N T A L  //  E X P E R I M E N T A L  //  E X P E R I M E N T A L
#===================================================================================

func offsetValue(offset : Array):
	if typeof(offset[0]) == TYPE_FLOAT:
		return rng.randf_range(offset[0], offset[1])
	elif typeof(offset[0]) == TYPE_INT:
		return rng.randi_range(offset[0], offset[1])

func initPlanetChildren():
	print(num_planets)
	
	orbit_sum = offsetValue([0.0, 5.0 * star_rad])
	
	for i in range(num_planets):
		#print("making planet...")
		var planetInstance = planet.instantiate()
		initPlanetVars(planetInstance, i, star_rad)
		
		orbit_sum = planetInstance_distance
		
		#var temp_path = planetInstance.get_scene_file_path()
		#planets_nodepaths.append(temp_path)
		
		get_node("RotationPoint/Core").add_child(planetInstance)
		planets.append(planetInstance)
		
		for j in range(num_moons):
			var moonInstance = initMoon()
			planetInstance.get_node("RotationPoint/Core").add_child(moonInstance)
		
		for k in range(num_rings):
			var ringInstance = initRing()
			planetInstance.get_node("RotationPoint/Core").add_child(ringInstance)
			#print("Ring Size 2: " + str(ring_size))

func initPlanetVars(planetInstance, i, star_rad):
	# TEMP VALUES
	# Axial tilt
	planetInstance.core.rotation.x = offsetValue([-0.3,0.3])
	planetInstance.core.rotation.z = offsetValue([-0.3,0.3])
	# Orbital tilt
	planetInstance.rotation.x = offsetValue([-0.01,0.01])
	planetInstance.rotation.z = offsetValue([-0.01,0.01])
	
	#NOTE: Split Transitional into Super-Earth and Mini Neptune
	#ADD: Additional red color to Gas_Giant for hot jupiters when close to star
	#Mini Neptunes should be ice colors when far away
	#ADD: Green, Magenta, Brown, and Blue Colors to corresponding planets
	
	var random_float = randf()
	if random_float < 0.4:
		planet_type = "Gas_Giant"
	elif random_float < 0.6:
		planet_type = "Terrestrial_Planet"
	else:
		planet_type = "Transitional_Planet"
	
	if (orbit_sum <= 2.0) and (planet_type == "Gas_Giant"):
		planet_type = "Cthonian_Planet"
	elif (orbit_sum < star_rad * 5.0) and (planet_type == "Gas_Giant"):
		planet_type = "Hot_Giant"
	elif (orbit_sum > star_rad * 75) and (planet_type == "Gas_Giant"):
		planet_type = "Ice_Giant"
	
	random_float = randf()
	
	if (orbit_sum > star_rad * 10 and orbit_sum < star_rad * 20) and (planet_type == "Terrestrial_Planet") and (random_float > 0.5):
		planet_type = "Water_World"
	
	if (orbit_sum > star_rad * 10 and orbit_sum < star_rad * 20) and (planet_type == "Transitional_Planet") and (random_float > 0.5):
		planet_type = "Hycean_Planet"
	
	#print("-----------------------------")
	#print(planet_type, ": ", orbit_sum, ". Habitable zone: ", star_rad * 10, " - ", star_rad * 15)
	#print("-----------------------------")
	
	if planet_type == "Gas_Giant":
		planet_radius_variance = [0.5,0.8] 
		num_moons_variance = [4,10]
		planetInstance_distance_variance = [25.0,50.0]
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
			
		random_float = randf()
		if random_float < 0.9:
			color_variance_r = [1,1]
			color_variance_g = [1,1]
			color_variance_b = [0.6,1]
		else:
			color_variance_r = [0.5,0.6]
			color_variance_g = [0.2,0.25]
			color_variance_b = [0.2,0.3]
		
		atmosphere_present = true
		atmosphere_thickness = 0.5
	
	if planet_type == "Hot_Giant":
		planet_radius_variance = [0.4,0.7] 
		num_moons_variance = [0,8]
		planetInstance_distance_variance = [25.0,50.0]
		random_float = randf()
		if random_float < 0.7:
			num_rings_variance = [0,10]
			ring_size_variance = [0.1,0.3]
			ring_max = 0.3
		else:
			ring_size_variance = [0.2,1.2]
			num_rings_variance = [10,30]
			ring_max = 1.2
			
		color_variance_r = [1,1]
		color_variance_g = [0.25,0.35]
		color_variance_b = [0.2,0.3]
	
		atmosphere_present = true
		atmosphere_thickness = 0.3
		
	elif planet_type == "Cthonian_Planet":
		planet_radius_variance = [0.15,0.3]
		num_moons_variance = [0,0]
		planetInstance_distance_variance = [5.0,10.0]
		random_float = randf()
		num_rings_variance = [0,0]
		ring_size_variance = [0,0]
		ring_max = 1.0
		
		random_float = randf()
		if random_float < 0.5:
			var colors = offsetValue([0.1,0.5])
			color_variance_r = [colors, colors]
			color_variance_g = [colors, colors]
			color_variance_b = [colors, colors]
		else:
			color_variance_r = [0.6,0.9]
			color_variance_g = [0.2,0.5]
			color_variance_b = [0.1,0.4]
			
		atmosphere_present = false
	
	elif planet_type == "Terrestrial_Planet":
		planet_radius_variance = [0.15,0.3]
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
		
		random_float = randf()
		if random_float < 0.5:
			atmosphere_present = true
			atmosphere_thickness = 0.5
		else:
			atmosphere_present = false
			
	elif planet_type == "Water_World":
		planet_radius_variance = [0.15,0.3]
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
		color_variance_r = [0,0]
		color_variance_g = [0.2,0.8]
		color_variance_b = [0.7,0.9]
		
		atmosphere_present = true
		atmosphere_thickness = 0.5
		
	elif planet_type == "Ice_Giant":
		planet_radius_variance = [0.35,0.5]
		num_moons_variance = [2,4]
		planetInstance_distance_variance = [30.0,60.0]
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
		
		atmosphere_present = true
		atmosphere_thickness = 0.5
	
	elif planet_type == "Transitional_Planet":
		planet_radius_variance = [0.25,0.4]
		num_moons_variance = [0,3]
		planetInstance_distance_variance = [7.0,20.0]
		random_float = randf()
		if random_float < 0.8:
			num_rings_variance = [0,4]
			ring_size_variance = [0.1,0.2]
			ring_max = 0.2
		else:
			num_rings_variance = [5,10]
			ring_size_variance = [0.1,0.6]
			ring_max = 0.6
		
		random_float = randf()
		if random_float < 0.5:
			var colors = offsetValue([0.2,0.8])
			color_variance_r = [colors, colors]
			color_variance_g = [colors, colors]
			color_variance_b = [colors, colors]
		else:
			color_variance_r = [1,1]
			color_variance_g = [0.5,0.7]
			color_variance_b = [0.3,0.5]
			
		random_float = randf()
		if random_float < 0.5:
			atmosphere_present = true
			atmosphere_thickness = 0.5
		else:
			atmosphere_present = false
			
	elif planet_type == "Hycean_Planet":
		planet_radius_variance = [0.25,0.4]
		num_moons_variance = [0,3]
		planetInstance_distance_variance = [7.0,15.0]
		random_float = randf()
		if random_float < 0.8:
			num_rings_variance = [0,4]
			ring_size_variance = [0.1,0.2]
			ring_max = 0.2
		else:
			num_rings_variance = [5,10]
			ring_size_variance = [0.1,0.6]
			ring_max = 0.6
		
		random_float = randf()
		color_variance_r = [0.1,0.1]
		color_variance_g = [0.1,0.9]
		color_variance_b = [0.6,0.9]
		
		atmosphere_present = true
		atmosphere_thickness = 0.5
	
	planetInstance_individual_distance = offsetValue(planetInstance_distance_variance)
	planetInstance_distance = planetInstance_individual_distance + orbit_sum + planet_post_distance#LOOK AT LATER
	planetInstance.semi_major_axis = planetInstance_distance + star_rad
	planet_post_distance = planetInstance_individual_distance
	planetInstance.orbital_period = planetInstance.semi_major_axis **(3.0/2)
	planetInstance.eccentricity = rng.randf_range(0, 0.1) #TODO: Make accurate eccentricity values
	
	planets_semi.append(planetInstance_distance)
	
	radius = offsetValue(planet_radius_variance)
	planetInstance.radius = radius
	num_moons = offsetValue(num_moons_variance)
	
	if atmosphere_present:
		planetInstance.atmosphere_present = true
		planetInstance.atmosphere_size = atmosphere_size
		planetInstance.atmosphere_thickness = atmosphere_thickness
	
	planetInstance.color_r = offsetValue(color_variance_r)
	planetInstance.color_g = offsetValue(color_variance_g)
	planetInstance.color_b = offsetValue(color_variance_b)
	
	num_rings = offsetValue(num_rings_variance)
	#print("Number of rings: " + str(num_rings))
	
	#print("Generate System script radius: " + str(planetInstance.radius))
	#print("Generate System script orbital_period: " + str(planetInstance.orbital_period))
	#print("Moons: " + str(num_moons))
	
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
	
func get_semimajoraxis(i : int):
	return planets_semi[i]
	
func remove_child_at_path(i : int):
	var planet = planets[i]
	get_node("RotationPoint/Core").remove_child(planet)
	planet.queue_free()

func remove_all():
	for planet in planets:
		get_node("RotationPoint/Core").remove_child(planet)
		planet.queue_free()
	planets.clear()
