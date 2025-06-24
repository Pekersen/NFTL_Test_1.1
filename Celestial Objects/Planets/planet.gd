extends Planet

@onready var planetMesh = $"RotationPoint/Core/TruePlanet"
@onready var planetCollision = $"RotationPoint/Core/PlanetCollision"
@onready var orbitMesh = $Orbit
@onready var atmosphere = $"RotationPoint/Core/Atmospshere"
@onready var label = $"RotationPoint/Core/Label3D"

#var base_material := preload("res://Experimental/Experimental Planet Mesh/planet_terrain_shader_material.tres")

var initRotPos : float
var orbit_path_visible = true

var atmosphere_present : bool
var atmosphere_size : float
var atmosphere_thickness : float

var is_home_world = false
var moons : Array

var is_gas = false
var random : float

func _init():
	mass = 0.01

# Called when the node enters the scene tree for the first time.
func _ready():
	_init_variance()
	_init_vars()
	
	if !atmosphere_present:
		atmosphere.mesh.material.set_transparency(0)
	else:
		atmosphere.mesh.material.set_transparency(1)
		atmosphere.mesh.radius = radius * 0.93
		atmosphere.mesh.height = (radius * 2) * 0.93
		atmosphere.mesh.material.albedo_color = Color(color_r, color_g, color_b, 0.01)
	
	semi_minor_axis = ((semi_major_axis**2)*(1-(eccentricity**2)))**0.5
	#print("Eccentricity: " + str(eccentricity) + ", Major: " + str(semi_major_axis) + ", Minor: " + str(semi_minor_axis))
	
	#print("R: " + str(color_r) + ", G: " + str(color_g) + ", B: " + str(color_b))
	
	planetMesh.mesh.material.albedo_color = Color(color_r, color_g, color_b)
	
	#orbitMesh.material.render_mode = Enums.RENDER_MODE_DISABLED
	
	initRotPos = offset_value([0, (2 * PI)])
	rotationPoint.rotate_y(initRotPos)
	
	label.position = Vector3(0, radius * 2.0 + 20.0, 0)
	label.font_size = 32
	
	if is_gas:
		planetMesh.mesh.material.albedo_texture = null
		planetMesh.mesh.material.roughness_texture = null
	else:
		pass
		'''
		var unique_material = base_material.duplicate()
		unique_material.set_shader_parameter("v", (randf_range(0.0, 99999.9)))
		planetMesh.material_override = unique_material
		print(unique_material.shader.get_shader_uniform_list())
		'''
		
		'''
		var material = load("res://Experimental/Experimental Planet Mesh/planet_terrain.gdshader")
		var shader_material = ShaderMaterial.new()
		shader_material.set_shader(material)
		shader_material.set_shader_parameter("rand", random)
		'''

func _init_variance():
	axial_tilt_variance = [-0.3,0.3]
	rotation_speed_variance = [0.001,0.01]

func _init_vars():
	# Axial tilt
	core.rotation.x = offset_value(axial_tilt_variance)
	core.rotation.z = offset_value(axial_tilt_variance)
	axial_tilt = core.rotation
	# Rotation speed
	rotations_per_tick = offset_value(rotation_speed_variance)
	# Init orbit visuals
	orbitMesh.mesh.outer_radius = semi_major_axis + 0.05
	orbitMesh.mesh.inner_radius = semi_major_axis - 0.05
	core.position.x = semi_major_axis
	# Init planet visuals
	planetMesh.mesh.radius = radius
	planetMesh.mesh.height = radius * 2
	# Init click area
	planetCollision.shape.radius = radius + click_forgiveness

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_orbit:
		orbit(delta, core)
		if is_flipped:
			core.position *= -1
	celestial_rotation(delta, planetMesh)
	
	#orbit(delta, core)
	
func _input(event):
	if event.is_action_pressed("lines") and orbit_path_visible == true:
		orbitMesh.visible = false
		orbit_path_visible = false
		label.visible = false
	elif event.is_action_pressed("lines") and orbit_path_visible == false:
		orbitMesh.visible = true
		orbit_path_visible = true
		label.visible = true
		
func change_name(new_name : String):
	label.text = new_name
	object_name = new_name
	if is_home_world:
		label.text = "Home"
		object_name = "Home"
