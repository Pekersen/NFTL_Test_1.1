extends Star

@onready var starMesh = $StarMesh
@onready var starCollision = $StarCollision
@onready var starLight = $StarLight

var star_type : String
var star_names = ["Centauri", "Sol", "Bernard's Star", "Vega", "Proxima", "Polaris", "Betelgeuse", "Deneb", "Sirius"]
@export var star_name : String
@export var age : int

var is_flipped := false

signal star_rad_for_cam(radius)


func _ready():
	star_type = pick_star_type()
	print("Star Type: " + star_type)
	_on_system_star_gen(star_type)

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
		radius_variance = [1,1.4]
		mass_variance = [0.08,0.45]
		luminosity_variance = [0.5,1]
		temperature_variance = [2300, 3900]
		
		color_variance_r = [1,1]
		color_variance_g = [0.25,0.35]
		color_variance_b = [0.2,0.3]
	
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
	
	starMesh.mesh.radius = radius
	starMesh.mesh.height = radius * 2
	
	starCollision.shape.radius = radius + click_forgiveness
	
	starLight.light_energy = luminosity
	
	var light_color_r = clamp(color_r + 0.3, 0.5, 1)
	var light_color_g = clamp(color_g + 0.3, 0.5, 1)
	var light_color_b = clamp(color_b + 0.3, 0.5, 1)
	
	starMesh.mesh.material.set_shader_parameter("Sun_Color", Color(color_r, color_g, color_b))
	starLight.light_color = Color(1.0, 1.0, 1.0)
	
	var name_index = offsetValue([0, star_names.size()])
	star_name = star_names[name_index]
	
	star_rad_for_cam.emit(radius)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	star_rotate(delta)
	if can_orbit:
		orbit(delta, self)
		if is_flipped:
			position *= -1


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
	else:
		return "M"
