class_name SystemGeneration extends GenerateCluster

@onready var star = preload("res://Celestial Objects/Stars/star.tscn")

var system_age : int
var star_count : int
var star_type : String

var mass = [0.0, 0.0, 0.0]
var star_order = [0, 0, 0]
var stars = [null, null, null]

var temporary_star

signal star_gen(star_type)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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
		print(stars[i].mass)
		mass[i] = stars[i].mass
	
	mass.sort()
	print("Sorting")
	
	for i in range(star_count):
		print(stars[i].mass)
		print(mass[i])
	
	print("Second Sorting")
	
	for i in range(star_count):
		for j in range(star_count):
			if stars[i].mass == mass[j]:
				pass
	
