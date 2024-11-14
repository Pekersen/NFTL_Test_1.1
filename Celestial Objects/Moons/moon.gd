extends Moon

@onready var moonMesh = $RotationPoint/Core/TrueMoon
@onready var core = $"RotationPoint/Core"
@onready var moonCollision = $"RotationPoint/Core/MoonCollision"
@onready var orbitMesh = $Orbit


var orbit_path_visible = true

func _init():
	
	mass = 0.001
	
# Called when the node enters the scene tree for the first time.
func _ready():
	var parent = get_parent()
	global_position.x = parent.global_position.x
	global_rotation.x = offsetValue([-0.3,0.3])
	global_rotation.z = offsetValue([-0.3,0.3])
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
	
	
	#orbitMesh.material.render_mode = Enums.RENDER_MODE_DISABLED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	orbit(delta, core)


func _input(event):
	if event.is_action_pressed("lines") and orbit_path_visible == true:
		orbitMesh.visible = false
		orbit_path_visible = false
	elif event.is_action_pressed("lines") and orbit_path_visible == false:
		orbitMesh.visible = true
		orbit_path_visible = true
