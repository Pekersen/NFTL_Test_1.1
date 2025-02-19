extends Star

@onready var starMesh := $RotationPoint/Core/StarMesh
@onready var starCollision := $RotationPoint/Core/StarCollision
@onready var starLight := $RotationPoint/Core/StarLight
@onready var orbitMesh := $Orbit

var star_type : String
var star_names = ["Centauri", "Sol", "Bernard's Star", "Vega", "Proxima", "Polaris", "Betelgeuse", "Deneb", "Sirius"]
@export var star_name : String
@export var age : int

var small_star_probability : float

var star_count : int

var is_flipped := false

signal star_rad_for_cam(radius)

var orbit_path_visible = true

func _ready():		
	# TEMP Values
	if star_count == 1:
		small_star_probability = 0.0
	elif star_count == 2:
		small_star_probability = 0.3
	elif star_count == 3:
		small_star_probability = 0.4
	
	star_type = pick_star_type()
	print("Star Type: " + star_type)
	_on_system_star_gen(star_type)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#star_rotate(delta)
	if can_orbit:
		orbit(delta, core)
		if is_flipped:
			core.position *= -1

func  _on_system_star_gen(star_type):
	self.star_type = star_type
	
	if star_type == "O":
		radius_variance = [13.2,20]
		mass_variance = [16,20]
		luminosity_variance = [50,70]
		temperature_variance = [33000, 50000]
		
		color_variance_r = [0.60,0.685]
		color_variance_g = [1,1]
		color_variance_b = [1,1]
		
	elif star_type == "B":
		radius_variance = [3.6,13.2]
		mass_variance = [2.1,16]
		luminosity_variance = [40,50]
		temperature_variance = [10000, 33000]
		
		color_variance_r = [0.685,0.875]
		color_variance_g = [1,1]
		color_variance_b = [1,1]
		
	elif star_type == "A":
		radius_variance = [2.8,3.6]
		mass_variance = [1.4,2.1]
		luminosity_variance = [20,30]
		temperature_variance = [7300, 10000]
		
		color_variance_r = [0.875,1]
		color_variance_g = [1,1]
		color_variance_b = [1,1]
		
	elif star_type == "F":
		radius_variance = [2.2,2.8]
		mass_variance = [1.04,1.4]
		luminosity_variance = [10,20]
		temperature_variance = [6000, 7300]
		
		color_variance_r = [1,1]
		color_variance_g = [1,1]
		color_variance_b = [0.8,1]
		
	elif star_type == "G":
		radius_variance = [1.8,2.2]
		mass_variance = [0.8,1.04]
		luminosity_variance = [5,10]
		temperature_variance = [5300, 6000]
		
		color_variance_r = [1,1]
		color_variance_g = [1,1]
		color_variance_b = [0.6,0.8]
		
	elif star_type == "K":
		radius_variance = [1.4,1.8]
		mass_variance = [0.45,0.8]
		luminosity_variance = [1,5]
		temperature_variance = [3900, 5300]
		
		color_variance_r = [1,1]
		color_variance_g = [0.7,0.8]
		color_variance_b = [0.4,0.6]
		
	elif star_type == "M":
		radius_variance = [1.2,1.4]
		mass_variance = [0.08,0.45]
		luminosity_variance = [0.6,1]
		temperature_variance = [2300, 3900]
		
		color_variance_r = [1,1]
		color_variance_g = [0.25,0.35]
		color_variance_b = [0.2,0.3]
		
	elif star_type == "L":
		radius_variance = [1.0,1.2]
		mass_variance = [0.05,0.08]
		luminosity_variance = [0.4,0.6]
		temperature_variance = [1300, 2000]
		
		color_variance_r = [0.6,0.7]
		color_variance_g = [0.2,0.25]
		color_variance_b = [0.1,0.2]
	
	elif star_type == "T":
		radius_variance = [0.8,1.0]
		mass_variance = [0.03,0.05]
		luminosity_variance = [0.2,0.4]
		temperature_variance = [700, 1300]
		
		color_variance_r = [0.5,0.6]
		color_variance_g = [0.2,0.25]
		color_variance_b = [0.2,0.3]
		
	elif star_type == "Y":
		radius_variance = [0.6,0.8]
		mass_variance = [0.01,0.03]
		luminosity_variance = [0.0,0.2]
		temperature_variance = [100, 700]
		
		color_variance_r = [0.3,0.5]
		color_variance_g = [0.25,0.3]
		color_variance_b = [0.3,0.4]
		
	
	rotation_speed_variance = [0,0]
	
	var random_float = randf()
	if random_float < 0.6:
		rotation_speed_variance = [0.02,0.03]
	elif random_float > 0.99:
		rotation_speed_variance = [11,12.5]
	else:
		rotation_speed_variance = [0.01,1.25]
		
	radius = offsetValue(radius_variance)
	mass = offsetValue(mass_variance)
	luminosity = offsetValue(luminosity_variance)
	temperature = offsetValue(temperature_variance)
	rotation_speed = offsetValue(rotation_speed_variance)
	
	color_r = offsetValue(color_variance_r)
	color_g = offsetValue(color_variance_g)
	color_b = offsetValue(color_variance_b)
	
	#TEMP
	print("Color R: " + str(color_r) + ", Color G: " + str(color_g) + ", Color B: " + str(color_b))
	
	starMesh.mesh.radius = radius
	starMesh.mesh.height = radius * 2
	
	starCollision.shape.radius = radius + click_forgiveness
	
	starLight.light_energy = luminosity
	
	
	starMesh.mesh.material.set_shader_parameter("Sun_Color", Color(color_r, color_g, color_b))
	starLight.light_color = Color(1.0, 1.0, 1.0)
	
	var name_index = offsetValue([0, star_names.size()])
	star_name = star_names[name_index]
	
	star_rad_for_cam.emit(radius)
	

func init_orbit_mesh():
	orbitMesh.mesh.outer_radius = semi_major_axis + 0.1
	orbitMesh.mesh.inner_radius = semi_major_axis - 0.1
	orbitMesh.scale.z = semi_minor_axis/semi_major_axis
	orbitMesh.position.x = -sqrt(pow(semi_major_axis,2) - pow(semi_minor_axis,2))
	print("mesh pos: ", orbitMesh.position.x)
	if is_flipped:
		orbitMesh.position.x *= -1

# For console
func get_star_info() -> String:
	# Command currently based on Star node being in Main. Will have to change eventually.
	return "Star type: " + str(star_type) + "\nRadius: " + str(radius) + "\nMass: " +\
	 	str(mass) + "\nLuminosity: " + str(luminosity) + "\nTemperature: " +\
		str(temperature) + "\nColor: R-" + str(color_r) + ", G-" + str(color_g) +\
		", B-" + str(color_b) + "\nRotation Speed: " + str(rotation_speed)

func set_star_type(newStarType : String):
	if newStarType == "random":
		newStarType = pick_star_type()
		_on_system_star_gen(newStarType)
	else:
		_on_system_star_gen(newStarType)
	return "Set star type to " + (str(newStarType))

# temp
func pick_star_type():
	var random_float = randf()
	

	if random_float < 0.01:
		return "O"
	elif random_float < 0.04:
		return "B"
	elif random_float < 0.115:
		return "A"
	elif random_float < 0.215:
		return "F"
	elif random_float < 0.365:
		return "G"
	elif random_float < 0.565:
		return "K"
	if random_float < 0.565 + (small_star_probability * 0.1):
		return "L"
	elif random_float < 0.565 + (small_star_probability * 0.2):
		return "T"
	elif random_float < 0.565 + (small_star_probability * 0.3):
		return "Y"
	else:
		return "M"
		
func _input(event):
	if event.is_action_pressed("lines") and orbit_path_visible == true:
		orbitMesh.visible = false
		orbit_path_visible = false
	elif event.is_action_pressed("lines") and orbit_path_visible == false:
		orbitMesh.visible = true
		orbit_path_visible = true

