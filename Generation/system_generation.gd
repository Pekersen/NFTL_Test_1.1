class_name SystemGeneration extends GenerateCluster

@onready var star = preload("res://Celestial Objects/Stars/star.tscn")

var system_age : int
var star_count : int
var star_type : String

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
	
	'''
	if star_count == 1:
		star_type = pick_star_type()
		var starInstance = star.instantiate()
		initStar1()
		add_child(starInstance)
	elif star_count == 2:
		star_type = pick_star_type()	
		var starInstance = star.instantiate()
		initStar1()
		add_child(starInstance)
		
		star_type = pick_star_type()	
		starInstance = star.instantiate()
		initStar2()
		add_child(starInstance)
	
	'''
	for i in range(star_count):
		#star_type = pick_star_type()
		var starInstance = star.instantiate()
		add_child(starInstance)
		starInstance.position.x = 10 * i

'''
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
		
	
		
func initStar1():
	print("Star Type: " + star_type)
	star_gen.emit(star_type)

func initStar2():
	print("Star Type: " + star_type)
	star_gen.emit(star_type)

'''
