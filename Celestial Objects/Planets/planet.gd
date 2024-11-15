extends Planet

@onready var planetMesh = $"RotationPoint/Core/TruePlanet"
@onready var planetCollision = $"RotationPoint/Core/PlanetCollision"
@onready var orbitMesh = $Orbit

var initRotPos : float
var orbit_path_visible = true

func _init():
	mass = 0.01

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Init orbit visuals
	orbitMesh.mesh.outer_radius = semi_major_axis + 0.05
	orbitMesh.mesh.inner_radius = semi_major_axis - 0.05
	core.position.x = semi_major_axis
	# Init planet visuals
	planetMesh.mesh.radius = radius
	planetMesh.mesh.height = radius * 2
	# Init click area
	planetCollision.shape.radius = radius + click_forgiveness
	
	
	#orbitMesh.material.render_mode = Enums.RENDER_MODE_DISABLED
	
	initRotPos = offsetValue([0,2 * PI])
	rotationPoint.rotate_y(initRotPos)

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
