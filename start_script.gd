extends SystemGeneration

#var star_systems : Array[PackedScene] = []
var star_systems : Array[System] = []
var specific_system = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	star_systems.resize(5)
	generate_star_systems(5)  # Example: Generate 5 star systems
	print("Generated ", star_systems.size(), " star systems.")
	
	

	'''
	star_systems.resize(5)
	cluster_variables()
	for i in 5:
		star_systems[i] = preload("res://Main/main.tscn")
		var instance = star_systems[0].instantiate()
		add_child(instance)
	
func _input(event):
	if event.is_action_released("change_scene"):
		specific_system += 1
		#get_tree().change_scene_to_file(star_systems[specific_system])
	'''
func generate_star_systems(count: int):
	for i in range(count):
		var system = system_generate(i)
		print("Star System Name: ", system.name)
		star_systems.append(system)
		build_system(system)
		#get_tree().change_scene_to_file("res://Main/main.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
