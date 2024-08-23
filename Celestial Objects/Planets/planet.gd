extends Planet

@onready var planetMesh = $"RotationPoint/Core/TruePlanet"
@onready var core = $"RotationPoint/Core"
@onready var planetCollision = $"RotationPoint/Core/PlanetCollision"
@onready var orbitMesh = $Orbit

func _init():
	radius_variance = [0.08, 0.2]
	orbit_speed_variance = [0.1, 3] # this is temporary. There should be other values
									# that affect this (e.g. distance).
	print("default")
	distance = 10
	radius = offsetValue(radius_variance)
	mass = 0.01
	orbit_speed = offsetValue(orbit_speed_variance)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	print("setting radius")
	# Init orbit visuals
	orbitMesh.mesh.outer_radius = distance
	orbitMesh.mesh.inner_radius = distance - 0.005
	core.position.x = distance
	# Init planet visuals
	planetMesh.mesh.radius = radius
	planetMesh.mesh.height = radius * 2
	# Init click area
	planetCollision.shape.radius = radius + click_forgiveness

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	orbit(delta)
