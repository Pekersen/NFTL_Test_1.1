extends Node3D

var stars: Dictionary = {}  # Stores the star mesh instances
var is_visible = false  # Toggle for visibility
var stars1 : Array
var stars2 : float

var STAR_MESH = preload("res://Map/generic_star.tscn")  # Preload a generic star mesh

var map_scene = load("res://Map/map.tscn")  
var map_instance = map_scene.instantiate()  
var map_generated = false

var inner = 3.1
var outer = (Start4.SYSTEM_COUNT * 2) / 5

func _ready():
	Start4.switch_to_star_system(0)

# Generate star representations in a sphere around the current system
func generate_galaxy_map():
	print(stars1.size())
	print(Start4.star_systems.keys().size())
	print("------------------------- GENERATING GALAXY MAP -------------------")
	var i = 0
	for id in Start4.star_systems.keys():
		
		var system = Start4.star_systems[id]
		var star = STAR_MESH.instantiate()
		star.name = "Star_" + str(id)
		map_instance.add_child(star)
		
		star.id = id
		# Set star color to match system
		#print("FIRST STAR: ", stars1[i].star_type, ", ", i, ", REAL ID: ", id)
		var star_color = stars1[i].starMesh.mesh.material.get_shader_parameter("Sun_Color")
		var star_size = sqrt(stars1[i].starMesh.mesh.radius)
		if star_size < 1:
			star_size = 1
		star.first_color = star_color
		star.first_size = star_size
		
		# Add interaction
		star.set_meta("system_id", id)  # Store system ID for click event
		star.connect("input_event", _on_star_clicked)
		
		stars[id] = star  # Store reference
		
		
		if stars1[i].star_count > 1:
			i += 1
			#print("SECOND STAR: ", stars1[i].star_type, ", ", i)
			var second_color = stars1[i].starMesh.mesh.material.get_shader_parameter("Sun_Color")
			var second_size = sqrt(stars1[i].starMesh.mesh.radius)
			if second_size < 1:
				second_size = 1
			var second_position = _calc_position((star_size + second_size) * 0.2, (star_size + second_size) * 0.3, 1)
			
			star.second_star = true
			star.second_color = second_color
			star.second_size = second_size
			star.second_position = second_position

		
		star.position = _calc_position(inner, outer, id)
		i += 1
		
	
	# Checks if any stars are less than x units (x ly) away from each other
	# If any are, then the positions are recalculated.
	var x = 3
	var changed = true
	while (changed == true):
		changed = false
		for id in Start4.star_systems.keys():
			for id_next in Start4.star_systems.keys():
				if (stars[id].position.distance_to(stars[id_next].position)) < x && (stars[id].position.distance_to(stars[id_next].position) != 0):
					stars[id].position = _calc_position(inner, outer, 1)
					changed = true
					#print("RECALCULATING POSITION")
	
	_generate_false_stars()

# Toggle visibility of galaxy map
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

# Handle clicks on stars
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
			
func _calc_position(inner, outer, id):
	# Position stars in a sphere around the center
	if id == Start4.star_systems.keys().size() - 1:
		return Vector3(0, 0, 0)
	else:
		var angle1 = randf_range(0, TAU)  # Random azimuth angle
		var angle2 = randf_range(0, TAU)  # Random polar angle
		var radius = randf_range(inner,outer)  # Distance from center
		var pos = Vector3(
			radius * sin(angle2) * cos(angle1),
			radius * sin(angle2) * sin(angle1),
			radius * cos(angle2)
		)
		return pos
		
func _generate_false_stars():
	var false_star_num = stars1.size() * 15
	var false_outer = stars1.size() * 2
	for i in false_star_num:
		#print("GENERATING FALSE STAR")
		var star = STAR_MESH.instantiate()
		map_instance.add_child(star)
		star.show()
		
		var color = randf_range(0.5, 1.0)
		star.first_color = Color(color, color, color)
		star.first_size = randf_range(0.6, 1.0)
		
		star.position = _calc_position(outer + 1.0, false_outer, 1)
		
		
