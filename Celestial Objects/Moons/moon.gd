extends Moon

@onready var moonMesh = $RotationPoint/Core/TrueMoon
@onready var core = $"RotationPoint/Core"
@onready var moonCollision = $"RotationPoint/Core/MoonCollision"
@onready var orbitMesh = $Orbit


func _init():
	radius_variance = [0.01, 0.05]
	#orbit_speed_variance = [0.1, 3] # this is temporary. There should be other values
									# that affect this (e.g. distance).
	print("default")
	distance = 10
	radius = offsetValue(radius_variance)
	mass = 0.01
	#orbit_speed = offsetValue(orbit_speed_variance)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	print("setting radius")
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
	#orbit(delta)
	pass
