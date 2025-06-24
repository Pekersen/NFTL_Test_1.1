extends Moon

@onready var moonMesh = $RotationPoint/Core/TrueMoon
@onready var moonCollision = $"RotationPoint/Core/MoonCollision"
@onready var orbitMesh = $Orbit
@onready var label = $"RotationPoint/Core/Label3D"
var initRotPos : float

var orbit_path_visible = true

func _init():
	
	mass = 0.001
	
# Called when the node enters the scene tree for the first time.
func _ready():
	var parent = get_parent()
	global_position.x = parent.global_position.x
	global_rotation.y = parent.global_rotation.y
	
	# Init orbit visuals
	orbitMesh.mesh.outer_radius = semi_major_axis + 0.0025
	orbitMesh.mesh.inner_radius = semi_major_axis - 0.0025
	core.position.x = semi_major_axis
	# Init planet visuals
	moonMesh.mesh.radius = radius
	moonMesh.mesh.height = radius * 2
	# Init click area
	moonCollision.shape.radius = radius + click_forgiveness
	
	moonMesh.mesh.material.albedo_color = Color(color_r, color_g, color_b)
	
	#orbitMesh.material.render_mode = Enums.RENDER_MODE_DISABLED

	initRotPos = offset_value([0, (2 * PI)])
	rotationPoint.rotate_y(initRotPos)
	
	label.position = Vector3(0, radius * 2.0, 0)
	label.font_size = 12

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	orbit(delta, core)


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
