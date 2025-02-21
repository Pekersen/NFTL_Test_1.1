extends Node3D

var stars: Dictionary = {}  # Stores the star mesh instances
var is_visible = false  # Toggle for visibility

const STAR_MESH = preload("res://Map/generic_star.tscn")  # Preload a generic star mesh

func _ready():
	self.hide()  # Start hidden
	Start4.switch_to_star_system(0)

# 1️⃣ Generate star representations in a sphere around the current system
func generate_galaxy_map():
	for id in Start4.star_systems.keys():
		var system = Start4.star_systems[id]
		var star = STAR_MESH.instantiate()
		star.name = "Star_" + str(id)
		
		# Position stars in a sphere around the center
		var angle1 = randf_range(0, TAU)  # Random azimuth angle
		var angle2 = randf_range(0, PI)  # Random polar angle
		var radius = 10  # Distance from center
		var pos = Vector3(
			radius * sin(angle2) * cos(angle1),
			radius * sin(angle2) * sin(angle1),
			radius * cos(angle2)
		)
		print("___________________Star Position:", pos)
		star.position = pos

		# Set star color to match system
		var star_color = Start4.star_systems[id].star_data.starMesh.mesh.material
		var mat = StandardMaterial3D.new()
		mat.albedo_color = star_color
		star.set_surface_override_material(0, mat)

		# Add interaction
		star.set_meta("system_id", id)  # Store system ID for click event
		star.connect("input_event", _on_star_clicked)

		add_child(star)
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
		self.show()
	else:
		self.hide()

# 4️⃣ Handle clicks on stars
func _on_star_clicked(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		var system_id = get_meta("system_id")
		print("Switching to system:", system_id)
		Start4.switch_to_star_system(system_id)
		toggle_map()  # Hide map when switching systems

