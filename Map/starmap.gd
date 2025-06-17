extends Node3D

var stars: Dictionary = {}  # Stores the star mesh instances
var is_visible = false  # Toggle for visibility
var stars1 : Array

var STAR_MESH = preload("res://Map/generic_star.tscn")  # Preload a generic star mesh

var map_scene = load("res://Map/map.tscn")  
var map_instance = map_scene.instantiate()  
var map_generated = false

func _ready():
	Start4.switch_to_star_system(0)

# 1️⃣ Generate star representations in a sphere around the current system
func generate_galaxy_map():
	print("------------------------- GENERATING GALAXY MAP -------------------")
	for id in Start4.star_systems.keys():
		var system = Start4.star_systems[id]
		var star = STAR_MESH.instantiate()
		star.name = "Star_" + str(id)
		map_instance.add_child(star)
		# Position stars in a sphere around the center
		var angle1 = randf_range(0, TAU)  # Random azimuth angle
		var angle2 = randf_range(0, PI)  # Random polar angle
		var radius = randf_range(1,10)  # Distance from center
		var pos = Vector3(
			radius * sin(angle2) * cos(angle1),
			radius * sin(angle2) * sin(angle1),
			radius * cos(angle2)
		)
		star.position = pos

		# Set star color to match system
		
		var star_color = stars1[id].starMesh.mesh.material.get_shader_parameter("Sun_Color")
		var star_size = sqrt(stars1[id].starMesh.mesh.radius)
		if star_size < 1:
			star_size = 1
		star.color = star_color
		star.size = star_size

		# Add interaction
		star.set_meta("system_id", id)  # Store system ID for click event
		star.connect("input_event", _on_star_clicked)

		stars[id] = star  # Store reference

# 2️⃣ Get star color based on system properties
#func get_star_color(system) -> Color:
	#var age = system.get_meta("system_age", 5)  # Default to 5 billion years
	#if age < 2: return Color(0.2, 0.2, 1.0)  # Blue (Young)
	#elif age < 5: return Color(1.0, 1.0, 0.6)  # Yellow (Mid-age)
	#else: return Color(1.0, 0.4, 0.2)  # Red (Old)

# 3️⃣ Toggle visibility of galaxy map
func toggle_map():
	is_visible = !is_visible
	if is_visible:
		Start4.star_systems[Start4.current_system_id].hide()
		print("SHOWING")
		get_tree().current_scene.add_child(map_instance)
		map_instance.show()
	else:
		Start4.star_systems[Start4.current_system_id].show()
		print("HIDING")
		map_instance.hide()

# 4️⃣ Handle clicks on stars
func _on_star_clicked(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		var system_id = get_meta("system_id")
		print("Switching to system:", system_id)
		Start4.switch_to_star_system(system_id)
		toggle_map()  # Hide map when switching systems

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_M and !map_generated:
			generate_galaxy_map()
			map_generated = true
		if event.keycode == KEY_M:
			toggle_map()
