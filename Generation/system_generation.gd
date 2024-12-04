class_name SystemGeneration extends GenerateCluster

@onready var star = preload("res://Celestial Objects/Stars/star.tscn")

const CLUSTER_TO_SYSTEM_AGE = 1000000

var system_age : int
var star_count : int
var star_type : String

var orbit_styles := {
	"Monary" : ["Centered"],
	"Binary" : ["Centered", "Far"],
	"Trinary" : ["Centered", "Far"]
}
var orbit_style : String

var stars : Array

func system_generate():
	cluster_variables()
	
	# Set system age
	cluster_age /= CLUSTER_TO_SYSTEM_AGE
	system_age = offsetValue([(cluster_age - (cluster_age / 10)), 
							cluster_age]) * CLUSTER_TO_SYSTEM_AGE
	print("System Age: " + str(system_age))
	
	while(true):
		stars = [null, null, null]
		# Get star_count
		_set_star_count()
		
		print("Star Count: " + str(star_count))
		
		_init_star_vars()
		
		
		print("here")
		if !_set_orbit_style():
			continue
		
		
		_init_stars()
		stars.sort_custom(_compare_mass)
		for star in stars:
			print(star.star_name, ": mass - ", star.mass)
		
		_init_star_orbit()
		
		break

# sets star_count to 1 to max, inclusive
func _set_star_count():
	var random_float = randf()
	if random_float < 0.33:
		star_count = 1
	elif random_float < 0.66:
		star_count = 2
	elif random_float < 1.0:
		star_count = 3
	#star_count = 1 # TEMP
	# cleans stars array
	for i in range(stars.size() - star_count):
		stars.erase(null)

# initializes stars for each star_count	
func _init_star_vars():
	for i in range(star_count):
		var star_instance = star.instantiate()
		stars[i] = star_instance
		
		stars[i].age = system_age
		stars[i].position.x = stars[i].mass * 10
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
			
			stars[1].semi_major_axis = stars[1].mass * 5 + 10 
			
			stars[0].semi_major_axis = stars[1].semi_major_axis *\
										(stars[1].mass/stars[0].mass)

			stars[0].eccentricity = 0.5
			stars[0].orbital_period = 50
			stars[0].is_flipped = true
			stars[0].can_orbit = true
			
			stars[1].eccentricity = stars[0].eccentricity
			stars[1].orbital_period = stars[0].orbital_period
			stars[1].can_orbit = true
		3:
			pass
		_: 
			print("Unkown star count. Star orbit was not initialized.")

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
