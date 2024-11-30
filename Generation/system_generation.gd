class_name SystemGeneration extends GenerateCluster

@onready var star = preload("res://Celestial Objects/Stars/star.tscn")

var system_age : int
var star_count : int
var star_type : String

var orbit_style : String

var stars = [null, null, null]


func system_generate():
	cluster_variables()
	
	cluster_age /= 1000000
	system_age = offsetValue([(cluster_age - (cluster_age / 10)), cluster_age]) * 1000000
	print("System Age: " + str(system_age))

	var random_float = randf()
	if random_float < 0.33:
		star_count = 1
	elif random_float < 0.66:
		star_count = 2
	elif random_float < 1.0:
		star_count = 3
		
	print("Star Count: " + str(star_count))
	
	for i in range(star_count):
		var starInstance = star.instantiate()
		add_child(starInstance)
		stars[i] = starInstance
		
		stars[i].age = system_age
		starInstance.position.x = starInstance.mass * 10
		
		''' HR Diagram Code (Change number of stars to 400)
		if starInstance.temperature > 10000:
			starInstance.position.x = (-(starInstance.temperature) / 100 ) - 350
			starInstance.position.y = starInstance.luminosity * 2
		else:
			starInstance.position.x = -(starInstance.temperature) / 20
			starInstance.position.y = (starInstance.luminosity * 4) - 50
		'''
	
	for i in range(star_count):
		print(stars[i].star_name + ": " + str(stars[i].mass))
	
	print("Sorting")
	
	for i in range(star_count):
		var currentMin = stars[i].mass
		var currentMinIndex = i
		var j = i + 1
		while j < star_count:
			if currentMin > stars[j].mass:
				currentMin = stars[j].mass
				currentMinIndex = j
			j = j + 1
				
		if currentMinIndex != i:
			stars[currentMinIndex].mass = stars[i].mass
			stars[i].mass = currentMin
	
	for i in range(star_count):
		print(stars[i].star_name + ": " + str(stars[i].mass))
