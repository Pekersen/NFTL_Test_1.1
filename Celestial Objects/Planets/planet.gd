extends Planet

@onready var planetMesh = $"RotationPoint/Core/TruePlanet"
@onready var core = $"RotationPoint/Core"
@onready var planetCollision = $"RotationPoint/Core/PlanetCollision"
@onready var orbitMesh = $Orbit


func _init():
	mass = 0.01

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Init orbit visuals
	orbitMesh.mesh.outer_radius = distance + 0.01
	orbitMesh.mesh.inner_radius = distance - 0.01
	core.position.x = distance
	# Init planet visuals
	planetMesh.mesh.radius = radius
	planetMesh.mesh.height = radius * 2
	# Init click area
	planetCollision.shape.radius = radius + click_forgiveness
	
	
	#orbitMesh.material.render_mode = Enums.RENDER_MODE_DISABLED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	orbit(delta)
