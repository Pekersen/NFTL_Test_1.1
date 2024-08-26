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
	'''
	var parent_planet = get_parent()
	rotationPoint.position.x = parent_planet.position.x
	rotationPoint.position.y = parent_planet.position.y
	rotationPoint.position.z = parent_planet.position.z
	

	radius_variance = [0.01, 0.05]
	moon_orbit_speed_variance = [0.1, 3] # this is temporary. There should be other values
									# that affect this (e.g. distance).
	distance = 10
	radius = offsetValue(radius_variance)
	
	moon_orbit_speed = offsetValue(moon_orbit_speed_variance)
	'''
	
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

