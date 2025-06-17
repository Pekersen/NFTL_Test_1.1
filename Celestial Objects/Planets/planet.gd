extends Planet

@onready var planetMesh = $"RotationPoint/Core/TruePlanet"
@onready var planetCollision = $"RotationPoint/Core/PlanetCollision"
@onready var orbitMesh = $Orbit
@onready var atmosphere = $"RotationPoint/Core/Atmospshere"

var initRotPos : float
var orbit_path_visible = true

var atmosphere_present : bool
var atmosphere_size : float
var atmosphere_thickness : float

var is_flipped := false

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
	
	if !atmosphere_present:
		atmosphere.mesh.material.set_transparency(0)
	else:
		atmosphere.mesh.material.set_transparency(1)
		atmosphere.mesh.radius = radius * 0.93
		atmosphere.mesh.height = (radius * 2) * 0.93
		atmosphere.mesh.material.albedo_color = Color(color_r, color_g, color_b, 0.01)
	
	semi_minor_axis = ((semi_major_axis**2)*(1-(eccentricity**2)))**0.5
	print("Eccentricity: " + str(eccentricity) + ", Major: " + str(semi_major_axis) + ", Minor: " + str(semi_minor_axis))
	
	print("R: " + str(color_r) + ", G: " + str(color_g) + ", B: " + str(color_b))
	
	planetMesh.mesh.material.albedo_color = Color(color_r, color_g, color_b)
	
	#orbitMesh.material.render_mode = Enums.RENDER_MODE_DISABLED
	
	initRotPos = offsetValue([0, (2 * PI)])
	rotationPoint.rotate_y(initRotPos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if can_orbit:
		orbit(delta, core)
		if is_flipped:
			core.position *= -1
	
	#orbit(delta, core)
	
func _input(event):
	if event.is_action_pressed("lines") and orbit_path_visible == true:
		orbitMesh.visible = false
		orbit_path_visible = false
	elif event.is_action_pressed("lines") and orbit_path_visible == false:
		orbitMesh.visible = true
		orbit_path_visible = true
