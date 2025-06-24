class_name SystemGeneration extends GenerateCluster

@onready var star_obj = preload("res://Celestial Objects/Stars/star.tscn")
#var star
@export var system_id: int  # Assigned by UniverseManager

#signal system_data_generated(star_data)  # Signal to send star info

var built = false  # Track if we've already built the system

var system_age : int
var system_age_variance : Array
var star_count : int
var star_type : String

var orbit_styles := {
	"Monary" : ["Centered"],
	"Binary" : ["Centered", "Far"],
	"Trinary" : ["Centered", "Far"]
}
var orbit_style : String

var stars : Array

var is_home = false

var s = Start4.scale

const letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
const l_letters = "abcdefghijklmnopqrstuvwxyz"
const numbers = "0123456789"
var system_name : String

signal star_count_to_star
signal system_to_localresources

func _ready():
	system_id = Start4.systems - 1
	Start4.systems -= 1
	print("ACTUAL ID: ", system_id)
	
	system_name = letters[randi() % letters.length()]
	for i in range(6):
		system_name += numbers[randi() % numbers.length()]
	print("SYSTEM NAME: ", system_name)
	Start4.system_names.append(system_name)
	
	
	if !built:
		_system_generate()
		built = true

func _system_generate():
	if system_id == 0:
		print("I'M HOOOOOOOOOOME")
		is_home = true
		
	system_to_localresources.emit(system_id)
	
	#_setup_nodes()
	#print("🔄 Star system ", system_id, " is READY!")
	
	# Set system age
	#print("Cluster Age per system: ", Start4.cluster_age)
	cluster_age = Start4.cluster_age
	system_age_variance = [cluster_age - (cluster_age / 10), cluster_age]
	#print("Lower Limit: ", system_age_variance[0], ", Upper Limit: ", system_age_variance[1])
	system_age_variance = [(cluster_age - (cluster_age / 10)) / 1000000, cluster_age / 1000000]
	system_age = Start4.offset_value(system_age_variance) * 1000000
	#print("System Age: " + str(system_age))
	
	while(true):
		stars = [null, null, null]
		# Get star_count
		_set_star_count()
		
		print("Star Count: " + str(star_count))
		
		_init_star_vars()
		
		#print("here")
		#if !_set_orbit_style():
			#continue
		
		_init_stars()
		
		_assign_names()
	#	for star in stars:
	#		await star.ready
		
		stars.sort_custom(_compare_mass)
		
		_init_star_orbit()
		
		#if star_count > 1:
		_planet_mod()
		
		for star in stars:
			print(star.star_name, ": mass - ", star.mass)
			star.change_name()
		
		break
		
	#emit_system_data()


# sets star_count to 1 to max, inclusive
func _set_star_count():
	var random_float = randf()
	if random_float < 0.7 or is_home:
		star_count = 1
	elif random_float < 1.0:
		star_count = 2
	elif random_float < 1.0:
		star_count = 3
	#star_count = 2 # TEMP
	
	# cleans stars array
	for i in range(stars.size() - star_count):
		stars.erase(null)
		
	

# initializes stars for each star_count	
func _init_star_vars():
	for i in range(star_count):
		var star_instance = star_obj.instantiate()
		star_instance.star_count = star_count
		star_instance.is_home = is_home
		stars[i] = star_instance
		
		stars[i].age = system_age
		stars[i].position.x = stars[i].mass * 10 * s
		''' HR Diagram Code (Change number of stars to 400)
		if starInstance.temperature > 10000:
			starInstance.position.x = (-(starInstance.temperature) / 100 ) - 350
			starInstance.position.y = starInstance.luminosity * 2
		else:
			starInstance.position.x = -(starInstance.temperature) / 20
			starInstance.position.y = (starInstance.luminosity * 4) - 50
		'''


func _compare_mass(a: Star, b: Star) -> int:
	return (a.mass < b.mass) # > Decending order, < Accending order
	
func _sort_by_mass():
	var temp0 = stars[0]
	var temp1 = stars[1]
	if (stars[0].mass > stars[1].mass):
		stars[1] = temp0
		stars[0] = temp1

func _set_orbit_style():
	match star_count:
		1:
			orbit_style = orbit_styles["Monary"][0]
			return true
		2:
			return false
		_:
			print("Unkown star count. Retrying orbit initalizaton.")
			return false

func _init_star_orbit():
	match star_count:
		1:
			#stars[0].position = Vector3(0,0,0)
			#print("1 STARRRRRRRRRRRRRRRRR")
			pass
		2:
			'Stars orbit each other'
			# give them random staring pos
			# get COM (center of mass)
				# make a rotation point there and set stars as children
					# Chance their position is not where it was before (Check this)
				# ALTERNATIVE
				# just add the vector transformation so no need to change local coords
				# this should be done after calculating orbit :D
			# calculate orbit!
			
			stars[1].semi_major_axis = (stars[1].mass * 10 + 10) * s
			#  b = a * sqrt(1 - e^2)
			
			stars[0].semi_major_axis = stars[1].semi_major_axis *\
										(stars[1].mass/stars[0].mass)
			
			var eccentricity_val = offset_value([0.0,1.0])
			if eccentricity_val < 0.5:
				stars[0].eccentricity = offset_value([0.0,0.1])
			elif eccentricity_val < 0.8:
				stars[0].eccentricity = offset_value([0.1,0.2])
			else:
				stars[0].eccentricity = offset_value([0.2,0.8])
			#print("Eccentricity: ", stars[0].eccentricity)
			stars[0].orbital_period = 50
			stars[0].is_flipped = true
			stars[0].can_orbit = true
			stars[0].orbitMesh.visible = false
			
			stars[1].eccentricity = stars[0].eccentricity
			stars[1].orbital_period = stars[0].orbital_period
			stars[1].can_orbit = true
			stars[1].orbitMesh.visible = false
			
			stars[1].semi_minor_axis = stars[1].semi_major_axis *\
									sqrt(1 - pow(stars[1].eccentricity,2))
			#print("semi minor 1: ", stars[1].semi_minor_axis)
			stars[0].semi_minor_axis = stars[0].semi_major_axis *\
									sqrt(1 - pow(stars[0].eccentricity,2))
			#print("semi minor 0: ", stars[0].semi_minor_axis)
		3:
			pass
		_: 
			print("Unkown star count. Star orbit was not initialized.")
			return
	for star in stars:
		star.orbitMesh.mesh.outer_radius = star.semi_major_axis + 0.1
		star.orbitMesh.mesh.inner_radius = star.semi_major_axis - 0.1
		star.orbitMesh.visible = true
		star.init_orbit_mesh(star.orbitMesh)

func _calc_center_of_mass(star_group: Array) -> Vector3:
	var summation_of_positional_mass := Vector3(0.0,0.0,0.0)
	var total_mass := 0.0
	
	for star in star_group:
		total_mass += star.mass
		summation_of_positional_mass += star.mass * star.position
	
	return Vector3(
				summation_of_positional_mass.x / total_mass,
				summation_of_positional_mass.y / total_mass,
				summation_of_positional_mass.z / total_mass
				)

func _init_stars():
	for star in stars:
		add_child(star)
		
		#await get_tree().process_frame
		
		Starmap.stars1.append(star)
		#print("APPENDING STAR: ", Starmap.stars1.size(), ", SYSTEM: ", Start4.star_systems.size())
		if star_count > 1:
			if star == stars[1]:
				Starmap.stars2 += 1
				print("SECOND STARS: ", Starmap.stars2)
	
	'''
	if star_count == 2:
		if (stars[1].mass > stars[0].mass):
			Starmap.stars1.append(stars[1])
		else:
			Starmap.stars1.append(stars[0])
	elif star_count == 1:
		Starmap.stars1.append(stars[0])
	'''
	
func _planet_mod():
	if star_count > 1:
		var difference = abs(stars[0].semi_major_axis - stars[1].semi_major_axis) * 2
		
		for i in range(stars[0].planets_semi.size()):
			if stars[0].get_semimajoraxis(i) > difference:
				stars[0].remove_child_at_path(i)
		
		for i in range(stars[1].planets_semi.size()):
			if stars[1].get_semimajoraxis(i) > difference:
				stars[1].remove_child_at_path(i)
				
		for star in stars:
			if star.eccentricity > 0.2:
				star.remove_all()
			
	for star in stars:
		for i in range(star.planets.size()):
			star.planets[i].change_name(star.object_name + l_letters[i])
			print("New Name: ", star.object_name + l_letters[i])
			for j in range(star.planets[i].moons.size()):
				star.planets[i].moons[j].change_name(star.object_name + l_letters[i] + str(j + 1))

func _setup_nodes() -> void:
	star_obj = preload("res://Celestial Objects/Stars/star.tscn")
	
func _assign_names():
	if stars.size() == 1:
		stars[0].object_name = system_name + "A"
		stars[0].system_name = system_name
	elif stars.size() == 2:
		if stars[0].luminosity > stars[1].luminosity:
			stars[0].object_name = system_name + "A"
			stars[1].object_name = system_name + "B"
			stars[0].system_name = system_name
			stars[1].system_name = system_name
		else:
			stars[0].object_name = system_name + "B"
			stars[1].object_name = system_name +"A"
			stars[0].system_name = system_name
			stars[1].system_name = system_name
	else:
		pass
		
		
