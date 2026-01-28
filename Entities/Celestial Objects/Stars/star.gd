class_name Star extends CelestialObject

signal star_rad_for_cam(radius)

const _LABEL_OFFSET_FROM_SURFACE = Vector3(0, 10, 0)
const _LABEL_FONT_SIZE = 48

@export var star_type : StarType
@export var star_name : String
@export var age : int

var star_names = ["Centauri", "Sol", "Bernard's Star", "Vega", "Proxima", "Polaris", "Betelgeuse", "Deneb", "Sirius"]

var small_star_probability : float
var big_star_probability : float

var star_count : int

var orbit_path_visible = true

var num_planets_variance = [0, 10] # so size = 2

var num_planets : int
var num_belts : int
var num_moons : int
var num_rings : int
var planet_type : String

var luminosity : float
var color_r : float
var color_g : float
var color_b : float

var planet_radius_variance : Array[float]

var num_moons_variance : Array[float]
var num_rings_variance : Array[float]
var ring_size_variance : Array[float]
var num_belts_variance = [1, 3]

var orbit_sum := 0.0
var planet_instance_distance
var planet_instance_individual_distance
var moonInstance_distance
var planet_post_distance = 0.0

var planet_instance_distance_variance : Array[float]

var moon_sum := 0.0

var orbit_speed_variance : Array[float] = [0.1,1]
var moon_orbit_speed_variance : Array[float] = [0.1,1]
var ring_size
var ring_max

var star_rad : float

var planet_count_reduction = 1

var all_colors : Array[float]
var base_texture = false

var major_axis : float
var planets : Array
var planets_semi : Array[float]
var planets_nodepaths : Array[String]

var atmosphere_present : bool
var atmosphere_size : float
var atmosphere_thickness : float

var is_home = false
var home_world_added = false
var gas_added = false
var home_world_num

var belts : Array
var belt_orbit_sum = 1

var belt_radii : Array

var s = Start4.scale

var system_name : String

var on_tile = false

@onready var starMesh := $RotationPoint/Core/StarMesh
@onready var starCollision := $RotationPoint/Core/StarCollision
@onready var starLight := $RotationPoint/Core/StarLight
@onready var orbitMesh = $Orbit
@onready var label = $"RotationPoint/Core/Label3D"
@onready var builder = $RotationPoint/Core/StarMesh/TileBuilder

@onready var innerZone = $InnerZone
@onready var outerZone = $OuterZone

@onready var planet = preload("res://Entities/Celestial Objects/Planets/planet.tscn")
@onready var moon = preload("res://Entities/Celestial Objects/Moons/moon.tscn")
@onready var ring = preload("res://Entities/Celestial Objects/Rings/ring.tscn")
@onready var belt = preload("res://Entities/Celestial Objects/Belts/belt.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#star_rotate(delta)
	if can_orbit:
		orbit(delta, core)
		if is_flipped:
			core.position *= -1
	celestial_rotation(delta, starMesh)

func _ready():
	_init_vars()
	
	if star_count == 1:
		_init_belt_children() 
		pass
	_init_planet_children()
	
	label.position = Vector3(0,star_rad,0) + _LABEL_OFFSET_FROM_SURFACE
	label.font_size = _LABEL_FONT_SIZE
	
	
func _init_vars() -> void:
	_init_type()
	_init_planets()
	_init_belts()

func _init_belts() -> void:
	var rand = randf()
	if rand < 0.7:
		num_belts = 0
	elif rand < 0.85:
		num_belts = 1
	elif rand < 0.95:
		num_belts = 2
	else:
		num_belts = 3
	if num_planets == 0 and num_belts > 1:
		num_belts = 1
	elif num_planets < 4 and num_belts > 2:
		num_belts = 2
	
	if is_home:
		num_belts = 2
		num_planets = randi_range(7, 9)

func _init_planets() -> void:
	num_planets = offset_value(num_planets_variance) / planet_count_reduction

func _init_type() -> void:
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
	_set_star_type(_pick_star_type())
	_on_system_star_gen()

func  _on_system_star_gen() -> void:
	# TODO: put rot_speed_var in star type
	rotation_speed_variance = [0,0]
	
	var random_float = randf()
	if random_float < 0.6:
		rotation_speed_variance = [0.02,0.03]
	elif random_float > 0.99:
		rotation_speed_variance = [11,12.5]
	else:
		rotation_speed_variance = [0.01,1.25]
		
	radius = offset_value(star_type.radius_variance) * s
	mass = offset_value(star_type.mass_variance)
	luminosity = offset_value(star_type.luminosity_variance)
	temperature = offset_value(star_type.temperature_variance)
	rotations_per_tick = offset_value(rotation_speed_variance)
	
	color_r = offset_value(star_type.color_r_variance)
	color_g = offset_value(star_type.color_g_variance)
	color_b = offset_value(star_type.color_b_variance)
	
	#TEMP
	#print("Color R: " + str(color_r) + ", Color G: " + str(color_g) + ", Color B: " + str(color_b))
	
	starMesh.mesh.radius = radius
	starMesh.mesh.height = radius * 2
	
	star_rad = radius
	
	starCollision.shape.radius = radius + click_forgiveness
	
	starLight.light_energy = luminosity * s
	
	starMesh.mesh.material.set_shader_parameter("Sun_Color", Color(color_r, color_g, color_b))
	starLight.light_color = Color(1.0, 1.0, 1.0)
	
	var name_index = offset_value([0, star_names.size()])
	star_name = star_names[name_index - 1]
	
	star_rad_for_cam.emit(radius)

### Console Commands ###

func get_star_info() -> String:
	# Command currently based on Star node being in Main. Will have to change eventually.
	return "Star type: " + str(star_type.star_type_name) + "\nRadius: " + str(radius) + "\nMass: " +\
	 	str(mass) + "\nLuminosity: " + str(luminosity) + "\nTemperature: " +\
		str(temperature) + "\nColor: R-" + str(color_r) + ", G-" + str(color_g) +\
		", B-" + str(color_b) + "\nRotation Speed: " + str(rotations_per_tick)

func set_star_type(newStarType : String):
	_set_star_type(newStarType)
	return "Set star type to " + (star_type.star_type_name)

### End Console Commands ###

func _pick_star_type():
	var random_float = randf()
	
	if is_home:
		if random_float < 0.33:
			return "F"
		elif random_float < 0.66:
			return "G"
		else:
			return "K"
		
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

func _set_star_type(type : String) -> void:
	match type:
		"random":
			_set_star_type(_pick_star_type())
		"O":
			star_type = StarTypes.type_o
		"B":
			star_type = StarTypes.type_b
		"A":
			star_type = StarTypes.type_a
		"F":
			star_type = StarTypes.type_f
		"G":
			star_type = StarTypes.type_g
		"K":
			star_type = StarTypes.type_k
		"M":
			star_type = StarTypes.type_m
		"L":
			star_type = StarTypes.type_l
		"T":
			star_type = StarTypes.type_t
		"Y":
			star_type = StarTypes.type_y
		_:
			push_error("Star Type Error: \"" + type + "\" not declared in the current scope.")

func change_name():
	label.text = object_name

func _input(event):
	if event.is_action_pressed("lines") and orbit_path_visible == true:
		orbitMesh.visible = false
		orbit_path_visible = false
		label.visible = false
	elif event.is_action_pressed("lines") and orbit_path_visible == false:
		orbitMesh.visible = true
		orbit_path_visible = true
		label.visible = true
	if (event.is_action_pressed("forward") or event.is_action_pressed("back") or event.is_action_pressed("left") or event.is_action_pressed("right") or event.is_action_pressed("upward") or event.is_action_pressed("downward") or event.is_action_pressed("camera_confine")) and on_tile:
		object_is_clicked()

func object_is_clicked():
	builder.clicked()
	print("CLICKED")
	if !on_tile:
		on_tile = true
		starCollision.shape.radius = 0.9 * radius
		print("Planet Collision: ", starCollision.shape.radius)
	else:
		on_tile = false
		starCollision.shape.radius = radius + click_forgiveness
		print("Planet Collision: ", starCollision.shape.radius)

#===================================================================================
# E X P E R I M E N T A L  //  E X P E R I M E N T A L  //  E X P E R I M E N T A L
#===================================================================================

func _init_planet_children():
	print(num_planets)
	orbit_sum = offset_value([0.0, 2.0 * star_rad])
	
	for i in range(num_planets):
		var planet_instance = planet.instantiate()
		_init_planet_vars(planet_instance, i, star_rad)
		
		orbit_sum = planet_instance_distance
		
		get_node("RotationPoint/Core").add_child(planet_instance)
		planets.append(planet_instance)
		
		for j in range(num_moons):
			var moonInstance = _init_moon()
			planet_instance.get_node("RotationPoint/Core").add_child(moonInstance)
			moonInstance.init_orbit_mesh(moonInstance.orbitMesh, moonInstance.initial_rotation)	
			planet_instance.moons.append(moonInstance)
		
		for k in range(num_rings):
			var ringInstance = _init_ring()
			planet_instance.get_node("RotationPoint/Core").add_child(ringInstance)
			#print("Ring Size 2: " + str(ring_size))
		
		planet_instance.init_orbit_mesh(planet_instance.orbitMesh, planet_instance.initial_rotation)
		if home_world_added:
			planets[home_world_num].is_home_world = true

func _init_planet_vars(planet_instance, i, star_radius):
	# TEMP VALUES
	# Orbital tilt
	planet_instance.rotation.x = offset_value([-0.01,0.01])
	planet_instance.rotation.z = offset_value([-0.01,0.01])
	
	planet_instance.can_orbit = true
	
	#NOTE: Split Transitional into Super-Earth and Mini Neptune
	#ADD: Additional red color to Gas_Giant for hot jupiters when close to star
	#Mini Neptunes should be ice colors when far away
	#ADD: Green, Magenta, Brown, and Blue Colors to corresponding planets
	
	_set_planet_type(i)
	
	planet_instance_individual_distance = offset_value(planet_instance_distance_variance) * s
	planet_instance_distance = planet_instance_individual_distance + orbit_sum + planet_post_distance#LOOK AT LATER
	var x = 10
	
	#print("planet_instanceDISTANCE: ", planet_instance_distance, ", ", planet_instance_distance + star_radius)
	
	if belt_radii.size() > 0:
		if planet_instance_distance + star_radius > belt_radii[0] - x and planet_instance_distance < belt_radii[1] + x:
			planet_instance_distance = belt_radii[1] + (belt_radii[1] - belt_radii[0])
			#print("ADDING ", belt_radii[1] - belt_radii[0])
	if belt_radii.size() > 2:
		if planet_instance_distance + star_radius > belt_radii[2] - x and planet_instance_distance < belt_radii[3] + x:
			planet_instance_distance = belt_radii[3] + (belt_radii[3] - belt_radii[2])
			#print("ADDING ", belt_radii[3] - belt_radii[2])
	if belt_radii.size() > 4:
		if planet_instance_distance + star_radius > belt_radii[4] - x and planet_instance_distance < belt_radii[5] + x:
			planet_instance_distance = belt_radii[5] + (belt_radii[5] - belt_radii[4])
			#print("ADDING ", belt_radii[5] - belt_radii[4])
		
	planet_instance.semi_major_axis = planet_instance_distance + star_radius
	planet_instance.eccentricity = rng.randf_range(0.0, 0.05) #TODO: Make accurate eccentricity values	
	planet_instance.semi_minor_axis = planet_instance.semi_major_axis *\
									sqrt(1 - pow(planet_instance.eccentricity,2))
	planet_post_distance = planet_instance_individual_distance
	planet_instance.orbital_period = planet_instance.semi_major_axis **(3.0/2)
	
	planets_semi.append(planet_instance_distance)
	
	radius = offset_value(planet_radius_variance) * s
	planet_instance.radius = radius
	num_moons = offset_value(num_moons_variance)
	
	if atmosphere_present:
		planet_instance.atmosphere_present = true
		planet_instance.atmosphere_size = atmosphere_size
		planet_instance.atmosphere_thickness = atmosphere_thickness
	'''
	planet_instance.color_r = offset_value(color_r_variance)
	planet_instance.color_g = offset_value(color_g_variance)
	planet_instance.color_b = offset_value(color_b_variance)
	'''
	num_rings = offset_value(num_rings_variance)
	
	if base_texture:
		planet_instance.is_gas = true
	else:
		pass
	
func _init_moon():
	var moonInstance = moon.instantiate()
	_init_moon_vars(moonInstance)
	moon_sum += moonInstance_distance
	return moonInstance
	
func _init_moon_vars(moonInstance):
	# TEMP VALUES
	moonInstance_distance = offset_value([0.1, 0.3]) * (s * s)
	moonInstance.semi_major_axis = moonInstance_distance + radius + ring_max + 1.0
	moonInstance.eccentricity = rng.randf_range(0, 0.2) #TODO: Make acurrate eccentricity values	
	moonInstance.semi_minor_axis = moonInstance.semi_major_axis *\
									sqrt(1 - pow(moonInstance.eccentricity,2))
	moonInstance.orbital_period = moonInstance.semi_major_axis **(3.0/2)
	moonInstance.eccentricity = rng.randf_range(0, 0.0) #TODO: Make acurrate eccentricity values
	moonInstance.radius = offset_value([0.01,0.05]) * s
	moonInstance.rotation.x = offset_value([-0.3,0.3])
	moonInstance.rotation.z = offset_value([-0.3,0.3])
	moonInstance.can_orbit = true

func _init_ring():
	var ringInstance = ring.instantiate()
	_init_ring_vars(ringInstance)
	return ringInstance
	
func _init_ring_vars(ringInstance):
	ring_size = offset_value(ring_size_variance) * s
	ringInstance.semi_major_axis = ring_size + radius
	
	var colors = offset_value([0.0,1.0])
	star_type.color_r_variance = [colors,colors]
	star_type.color_g_variance = [colors,colors]
	star_type.color_b_variance = [colors,colors]
	
	ringInstance.color_r = offset_value(star_type.color_r_variance)
	ringInstance.color_g = offset_value(star_type.color_g_variance)
	ringInstance.color_b = offset_value(star_type.color_b_variance)
	
func get_semimajoraxis(i : int):
	return planets_semi[i]
	
func remove_child_at_path(i : int):
	var p = planets[i]
	get_node("RotationPoint/Core").remove_child(p)
	p.queue_free()

func remove_all():
	for p in planets:
		get_node("RotationPoint/Core").remove_child(p)
		p.queue_free()
	planets.clear()
	
func _init_belt_children():
	belt_orbit_sum = randf_range(0, star_rad * 50)
	if is_home:
		belt_orbit_sum = randf_range (25 * star_rad, 50 * star_rad)
	#print("BELT CHILDREN: ", num_belts)
	for i in range(num_belts):
		var beltInstance = belt.instantiate()
		_init_belt_vars(beltInstance)
		get_node("RotationPoint/Core").add_child(beltInstance)
		belts.append(beltInstance)
		belt_orbit_sum += beltInstance.outer
		
func _init_belt_vars(beltInstance):
	beltInstance.asteroid_num = randf_range(100, 150)
	beltInstance.inner = randf_range(belt_orbit_sum + 30, belt_orbit_sum + 60)
	belt_radii.append(beltInstance.inner)
	#print("INNER: ", beltInstance.inner)
	beltInstance.outer = beltInstance.inner + (randf_range(20, 30) * s)
	belt_radii.append(beltInstance.outer)
	#print("OUTER: ", beltInstance.outer)
	
func _set_planet_type(i : int):
	var random_float = randf()
	if random_float < 0.4:
		planet_type = "Gas_Giant"
	elif random_float < 0.6:
		planet_type = "Terrestrial_Planet"
	else:
		planet_type = "Transitional_Planet"
		
	if is_home and home_world_added and !gas_added and i > 5:
		planet_type = "Gas_Giant"
		print("Force-added Gas Giant")
	
	if (orbit_sum <= 2.0) and (planet_type == "Gas_Giant"):
		planet_type = "Cthonian_Planet"
	elif (orbit_sum < star_rad * 5.0) and (planet_type == "Gas_Giant"):
		planet_type = "Hot_Giant"
	elif (orbit_sum > star_rad * 75) and (planet_type == "Gas_Giant"):
		planet_type = "Ice_Giant"
	
	random_float = randf()
	
	if (orbit_sum < star_rad * 20) and is_home:
		if random_float < 0.5:
			planet_type = "Terrestrial_Planet"
		else:
			planet_type = "Transitional_Planet"
	
	random_float = randf()
	
	if (orbit_sum > star_rad * 20 and orbit_sum < star_rad * 40) and (planet_type == "Terrestrial_Planet") and (random_float > 0.5):
		planet_type = "Water_World"
	
	if (orbit_sum > star_rad * 20 and orbit_sum < star_rad * 40) and (planet_type == "Transitional_Planet") and (random_float > 0.5):
		planet_type = "Hycean_Planet"
		
	if (is_home) and (orbit_sum > star_rad * 20 and orbit_sum < star_rad * 40) and (!home_world_added):
		planet_type = "Water_World" #"Home_World"
		home_world_added = true
		home_world_num = i
		print("Home World Added")
		
	
	#print("-----------------------------")
	#print(planet_type, ": ", orbit_sum, ". Habitable zone: ", star_rad * 10, " - ", star_rad * 15)
	#print("-----------------------------")
	
	if planet_type == "Gas_Giant":
		planet_radius_variance = [0.5,0.8] 
		num_moons_variance = [4,10]
		planet_instance_distance_variance = [25.0,50.0]
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
			star_type.color_r_variance = [1,1]
			star_type.color_g_variance = [1,1]
			star_type.color_b_variance = [0.6,1]
		else:
			star_type.color_r_variance = [0.5,0.6]
			star_type.color_g_variance = [0.2,0.25]
			star_type.color_b_variance = [0.2,0.3]
		
		atmosphere_present = true
		atmosphere_thickness = 0.5
		gas_added = true
		base_texture = true
	
	if planet_type == "Hot_Giant":
		planet_radius_variance = [0.4,0.7] 
		num_moons_variance = [0,8]
		planet_instance_distance_variance = [25.0,50.0]
		random_float = randf()
		if random_float < 0.7:
			num_rings_variance = [0,10]
			ring_size_variance = [0.1,0.3]
			ring_max = 0.3
		else:
			ring_size_variance = [0.2,1.2]
			num_rings_variance = [10,30]
			ring_max = 1.2
			
		star_type.color_r_variance = [1,1]
		star_type.color_g_variance = [0.25,0.35]
		star_type.color_b_variance = [0.2,0.3]
	
		atmosphere_present = true
		atmosphere_thickness = 0.3
		gas_added = true
		base_texture = true
		
	elif planet_type == "Cthonian_Planet":
		planet_radius_variance = [0.15,0.3]
		num_moons_variance = [0,0]
		planet_instance_distance_variance = [5.0,10.0]
		random_float = randf()
		num_rings_variance = [0,0]
		ring_size_variance = [0,0]
		ring_max = 1.0
		
		random_float = randf()
		if random_float < 0.5:
			var colors = offset_value([0.1,0.5])
			star_type.color_r_variance = [colors, colors]
			star_type.color_g_variance = [colors, colors]
			star_type.color_b_variance = [colors, colors]
		else:
			star_type.color_r_variance = [0.6,0.9]
			star_type.color_g_variance = [0.2,0.5]
			star_type.color_b_variance = [0.1,0.4]
			
		atmosphere_present = false
	
	elif planet_type == "Terrestrial_Planet":
		planet_radius_variance = [0.15,0.3]
		num_moons_variance = [0,2]
		planet_instance_distance_variance = [5.0,11.0]
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
			var colors = offset_value([0.2,0.8])
			star_type.color_r_variance = [colors, colors]
			star_type.color_g_variance = [colors, colors]
			star_type.color_b_variance = [colors, colors]
		else:
			star_type.color_r_variance = [1,1]
			star_type.color_g_variance = [0.5,0.8]
			star_type.color_b_variance = [0.3,0.5]
		
		random_float = randf()
		if random_float < 0.5:
			atmosphere_present = true
			atmosphere_thickness = 0.5
		else:
			atmosphere_present = false
			
	elif planet_type == "Water_World":
		planet_radius_variance = [0.15,0.3]
		num_moons_variance = [0,2]
		planet_instance_distance_variance = [5.0,11.0]
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
		star_type.color_r_variance = [0,0]
		star_type.color_g_variance = [0.2,0.8]
		star_type.color_b_variance = [0.7,0.9]
		
		atmosphere_present = true
		atmosphere_thickness = 0.5
		
	elif planet_type == "Ice_Giant":
		planet_radius_variance = [0.35,0.5]
		num_moons_variance = [2,4]
		planet_instance_distance_variance = [30.0,60.0]
		random_float = randf()
		if random_float < 0.8:
			num_rings_variance = [1,10]
			ring_size_variance = [0.1,0.2]
			ring_max = 0.2
		else:
			num_rings_variance = [10,30]
			ring_size_variance = [0.2,0.8]
			ring_max = 0.8
		
		star_type.color_r_variance = [0.6,0.9]
		star_type.color_g_variance = [1,1]
		star_type.color_b_variance = [1,1]
		
		atmosphere_present = true
		atmosphere_thickness = 0.5
		gas_added = true
		base_texture = true
	
	elif planet_type == "Transitional_Planet":
		planet_radius_variance = [0.25,0.4]
		num_moons_variance = [0,3]
		planet_instance_distance_variance = [7.0,20.0]
		if is_home:
			planet_instance_distance_variance = [7.0, 15.0]
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
			var colors = offset_value([0.2,0.8])
			star_type.color_r_variance = [colors, colors]
			star_type.color_g_variance = [colors, colors]
			star_type.color_b_variance = [colors, colors]
		else:
			star_type.color_r_variance = [1,1]
			star_type.color_g_variance = [0.5,0.7]
			star_type.color_b_variance = [0.3,0.5]
			
		random_float = randf()
		if random_float < 0.5:
			atmosphere_present = true
			atmosphere_thickness = 0.5
		else:
			atmosphere_present = false
			
	elif planet_type == "Hycean_Planet":
		planet_radius_variance = [0.25,0.4]
		num_moons_variance = [0,3]
		planet_instance_distance_variance = [7.0,15.0]
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
		star_type.color_r_variance = [0.1,0.1]
		star_type.color_g_variance = [0.1,0.9]
		star_type.color_b_variance = [0.6,0.9]
		
		atmosphere_present = true
		atmosphere_thickness = 0.5
