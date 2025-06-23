extends Node  # Since this is an Autoload, it should NOT extend Node3D

const SYSTEM_COUNT = 5
#const SYSTEM_SCENE := preload("res://Main/main.tscn")

var star_systems : Dictionary = {}  # Store persistent star systems
var current_system: Node = null
var current_system_id : int = 0
var current_system_instance = null

var cluster_type : String
var cluster_age_variance : Array[float]
var cluster_age : int

var rng = RandomNumberGenerator.new()

var systems = SYSTEM_COUNT

var scale = 10

func _ready():
	cluster_variables()
	
	if star_systems.is_empty():  # Prevent regenerating on reload
		generate_star_cluster()
	
	print("TRANSITION")
	
	current_system_id = SYSTEM_COUNT - 1
	for i in range(SYSTEM_COUNT):
		switch_to_star_system(current_system_id)
		current_system_id -= 1
	current_system_id = 0
	
	#Starmap.generate_galaxy_map()

# 1️⃣ Generate all star systems ONCE and keep them in memory
func generate_star_cluster():
	print("Generating star cluster...")
	for i in range(SYSTEM_COUNT):
		#print("SYSTEM: ", i)
		var system_scene = load("res://Main/main.tscn")  
		var system_instance = system_scene.instantiate()  
		system_instance.name = "StarSystem_" + str(i) 
		print("GIVEN ID: ", i) 
		system_instance.set_meta("system_id", i)
		
		'''
		#EXPERIMENTAL
		add_child(system_instance)
		await get_tree().process_frame
		print("System", i, "has", system_instance.get_child_count(), "children before packing")
		#await system_instance.ready
		
		var packed_scene = PackedScene.new()
		packed_scene.pack(system_instance)
		star_systems[i] = packed_scene
		
		remove_child(system_instance)
		system_instance.queue_free()
		'''
		
		#var real_root = system_instance.get_node("System")
		
		# ✅ Trigger initial setup manually (normally done in _ready)
		#if real_root.has_method("system_generate"):
		#	real_root.system_generate()
		
		star_systems[i] = system_instance  
		system_instance.hide()  
		
		'''
		var packed := PackedScene.new()
		packed.pack(system_instance)
		star_systems[i] = packed
		'''
			
	print("Star cluster generated!")

# 2️⃣ Switch to a star system
func switch_to_star_system(id: int):
	if not star_systems.has(id):
		print("Star system_", id, " not found!")
		return
		
	'''
	#EXPERIMENTAL
	current_system_id = id
	
	if current_system_instance and current_system_instance.get_parent():
		current_system_instance.get_parent().remove_child(current_system_instance)
		current_system_instance.queue_free()
		current_system_instance = null
		
	# Instance the packed version
	var packed_scene = star_systems[id]
	current_system_instance = packed_scene.instantiate()
	get_tree().get_root().add_child(current_system_instance)
	
	print("✅ Switched to system:", current_system_instance.name)
	
	'''
	
	# Get the new system
	var new_system = star_systems[id]

	if current_system:
		#current_system.get_parent().remove_child(current_system)
		current_system.process_mode = 4
		current_system.hide()  # Hide the previous system
		#current_system.disabled
		
		#EXPERIMENTAL
	#	if current_system.get_parent() == get_tree().current_scene:
	#		get_tree().current_scene.remove_child(current_system)
	
	#if Starmap.is_visible:
	#	Starmap.toggle_map()
	
	# ✅ Add the new system to the scene tree ONLY if not already added
#	if new_system.get_parent() != get_tree().current_scene:
#		get_tree().current_scene.add_child(new_system)
	
	
	
	# ✅ If the system is already in another scene, reparent it
	if new_system.get_parent():
		new_system.get_parent().remove_child(new_system)
	
	# ✅ Add it to the current scene and show it
	get_tree().current_scene.add_child(new_system)
	new_system.process_mode = 0
	new_system.show()
	print("My Name is System ", id)
	
	'''
	current_system_id = id
	var packed_scene = star_systems[id]
	get_tree().change_scene_to_packed(packed_scene)
	'''
	
	#var new_system_id = new_system.get_path()
	#get_tree().change_scene_to_file(new_system_id)
	
	# ✅ Update current system reference
	current_system = new_system
	current_system_id = id
	
	#print("Switched to:", current_system.name)
	


# 3️⃣ Handle Input (Testing)
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_V and current_system_id + 1 < len(star_systems):  # Press 'V' to visit the next system
			current_system_id += 1
			switch_to_star_system(current_system_id)
			if Starmap.is_visible:
				Starmap.toggle_map()
		if event.keycode == KEY_C  and current_system_id - 1 >= 0:  # Press 'V' to visit the previous system
			current_system_id -= 1
			switch_to_star_system(current_system_id)
			if Starmap.is_visible:
				Starmap.toggle_map()
			
func offset_value(offset : Array):
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
		
	cluster_age = int((int(offset_value(cluster_age_variance) / 1000000)) * 1000000)
	
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
