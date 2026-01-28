extends Moon

@onready var moonMesh = $RotationPoint/Core/TrueMoon
@onready var moonCollision = $"RotationPoint/Core/MoonCollision"
@onready var orbitMesh = $Orbit
@onready var label = $"RotationPoint/Core/Label3D"
@onready var builder = $RotationPoint/Core/TrueMoon/TileBuilder

var initial_rotation : float

var orbit_path_visible = true

var on_tile = false

func _init():
	
	mass = 0.001
	
# Called when the node enters the scene tree for the first time.
func _ready():
	_init_variance()
	_init_vars()
	
	#builder.build(radius)
	
	semi_minor_axis = ((semi_major_axis**2)*(1-(eccentricity**2)))**0.5
	var parent = get_parent()
	global_position.x = parent.global_position.x
	global_rotation.y = parent.global_rotation.y
	
	moonMesh.mesh.material.albedo_color = Color(color_r, color_g, color_b)
	
	#orbitMesh.material.render_mode = Enums.RENDER_MODE_DISABLED

	initial_rotation = offset_value([0, (2 * PI)])
	rotationPoint.rotate_y(initial_rotation)
	
	label.position = Vector3(0, radius * 2.0, 0)
	label.font_size = 12

func _init_variance():
	axial_tilt_variance = [-1,1]
	rotation_speed_variance = [0.0005,0.005]

func _init_vars():
	# Axial tilt
	core.rotation.x = offset_value(axial_tilt_variance)
	core.rotation.z = offset_value(axial_tilt_variance)
	axial_tilt = core.rotation
	# Rotation speed
	rotations_per_tick = offset_value(rotation_speed_variance)
	# Init orbit visuals
	orbitMesh.mesh.outer_radius = semi_major_axis + 0.0025
	orbitMesh.mesh.inner_radius = semi_major_axis - 0.0025
	core.position.x = semi_major_axis
	# Init planet visuals
	moonMesh.mesh.radius = radius
	moonMesh.mesh.height = radius * 2
	# Init click area
	moonCollision.shape.radius = radius + click_forgiveness

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	orbit(delta, core)
	celestial_rotation(delta, moonMesh)


func _input(event):
	if event.is_action_pressed("lines") and orbit_path_visible == true:
		orbitMesh.visible = false
		orbit_path_visible = false
		label.visible = false
	elif event.is_action_pressed("lines") and orbit_path_visible == false:
		orbitMesh.visible = true
		orbit_path_visible = true
		label.visible = true
	if (event.is_action_pressed("forward") or event.is_action_pressed("back") or event.is_action_pressed("left") or event.is_action_pressed("right") or event.is_action_pressed("upward") or event.is_action_pressed("downward") or event.is_action_pressed("camera_confine")) and on_tile:
		object_is_clicked()
		
func change_name(new_name : String):
	label.text = new_name
	object_name = new_name
	
func object_is_clicked():
	builder.clicked()
	print("CLICKED")
	if !on_tile:
		on_tile = true
		moonCollision.shape.radius = 0.9 * radius
		print("Planet Collision: ", moonCollision.shape.radius)
	else:
		on_tile = false
		moonCollision.shape.radius = radius + click_forgiveness
		print("Planet Collision: ", moonCollision.shape.radius)
