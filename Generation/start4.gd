extends Node  # Since this is an Autoload, it should NOT extend Node3D

const SYSTEM_COUNT = 50
var star_systems: Dictionary = {}  # Store persistent star systems
var current_system: Node = null
var current_system_id : int = 0

var cluster_type : String
var cluster_age_variance : Array[float]
var cluster_age : int

var rng = RandomNumberGenerator.new()

func _ready():
	cluster_variables()
	
	if star_systems.is_empty():  # Prevent regenerating on reload
		generate_star_cluster()

# 1️⃣ Generate all star systems ONCE and keep them in memory
func generate_star_cluster():
	print("Generating star cluster...")
	for i in range(SYSTEM_COUNT):
		var system_scene = load("res://Main/main.tscn")  
		var system_instance = system_scene.instantiate()  
		system_instance.name = "StarSystem_" + str(i)  
		system_instance.set_meta("system_id", i) 
		#print("Star System", i, "Position:", system_instance.global_transform.origin)
		'
		print("Creating system:", i, "Instance type:", system_instance.get_class())
		# ✅ DEBUG: Check if the script is correctly attached
		print("Star system", i, "Script attached:", system_instance.get_script())
	
		if system_instance.has_signal("system_data_generated"):
			system_instance.system_data_generated.connect(_on_system_data_received.bind(i))
			print("Signal Connected")
		else:
			push_error("Star system " + str(i) + " does not have the signal!")'
		
		star_systems[i] = system_instance  
		system_instance.hide()  
		
			
	print("Star cluster generated!")

# 2️⃣ Switch to a star system
func switch_to_star_system(id: int):
	if not star_systems.has(id):
		print("Star system", id, "not found!")
		return

	if current_system:
		current_system.hide()  # Hide the previous system

	# Get the new system
	var new_system = star_systems[id]

	# ✅ If the system is already in another scene, reparent it
	if new_system.get_parent():
		new_system.get_parent().remove_child(new_system)

	# ✅ Add it to the current scene and show it
	get_tree().current_scene.add_child(new_system)
	new_system.show()
	
	# ✅ Update current system reference
	current_system = new_system

	print("Switched to:", current_system.name)

# 3️⃣ Handle Input (Testing)
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_V and current_system_id + 1 < len(star_systems):  # Press 'V' to visit a random system
			current_system_id += 1
			switch_to_star_system(current_system_id)
		if event.keycode == KEY_C  and current_system_id - 1 >= 0:  # Press 'V' to visit a random system
			current_system_id -= 1
			switch_to_star_system(current_system_id)
			
func offsetValue(offset : Array):
	if typeof(offset[0]) == TYPE_FLOAT:
		return rng.randf_range(offset[0], offset[1])
	elif typeof(offset[0]) == TYPE_INT:
		return rng.randi_range(offset[0], offset[1])
	
func cluster_variables():
	var random_float = randf() * 2
	
	if random_float < 0.33:
		cluster_age_variance = [1000000000, 10000000000]
		print("Old System")
	elif random_float < 0.66:
		cluster_age_variance = [100000000, 999999999]
		print("Middle-Aged System")
	elif random_float < 1.0:
		print("Young System")
		cluster_age_variance = [0, 99999999]
	else:
		cluster_age_variance = [10000000000, 14000000000]
		print("Very Old System")
		
	cluster_age = int((int(offsetValue(cluster_age_variance) / 1000000)) * 1000000)
	
	if cluster_age < 99999999:
		cluster_type = "Association"
	elif cluster_age < 999999999:
		cluster_type = "Open"
	elif cluster_age < 10000000000:
		cluster_type = "Globular"
	else:
		cluster_type = "none"
	
	print("Cluster Age: " + str(cluster_age) + ", Cluster Type: " + cluster_type)

'func _on_system_data_received(system_id, star_data):
	print("Received system data for", system_id, ":", star_data)

	# ✅ Store system info in UniverseManager
	if not star_systems.has(system_id):
		return
	
	star_systems[system_id].set_meta("star_data", star_data)
'
