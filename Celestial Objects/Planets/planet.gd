extends Planet

@onready var planetMesh = $"Rotation Point/Core/True Planet"
@onready var core = $"Rotation Point/Core"

func _init():
	distance = 10
	radius = 0.1
	mass = 0.01
	orbit_speed = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	
	orbitMesh.mesh.outer_radius = distance
	orbitMesh.mesh.inner_radius = distance - 0.005
	core.position.x = distance

	planetMesh.mesh.radius = radius
	planetMesh.mesh.height = radius * 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	orbit(delta)
