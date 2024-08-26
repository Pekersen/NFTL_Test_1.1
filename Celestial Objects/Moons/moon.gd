extends Moon

@onready var moonMesh = $RotationPoint/Core/TrueMoon
@onready var core = $"RotationPoint/Core"
@onready var moonCollision = $"RotationPoint/Core/MoonCollision"
@onready var orbitMesh = $Orbit


#var parent_planet_pos_x = get_parent($RotationPoint/Core.position.x)
#var parent_planet_pos_y = get_parent($RotationPoint/Core.position.y)
#var parent_planet_pos_z = get_parent($RotationPoint/Core.position.z)

func _init():
	
	mass = 0.001
	
# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Init orbit visuals
	orbitMesh.mesh.outer_radius = distance + 0.025
	orbitMesh.mesh.inner_radius = distance - 0.025
	core.position.x = distance
	# Init planet visuals
	moonMesh.mesh.radius = radius
	moonMesh.mesh.height = radius * 2
	# Init click area
	moonCollision.shape.radius = radius + click_forgiveness
	
	
	#orbitMesh.material.render_mode = Enums.RENDER_MODE_DISABLED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	orbit(delta)

