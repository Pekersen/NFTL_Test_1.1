extends Star

@onready var starMesh = $StarMesh
@onready var starCollision = $StarCollision
@onready var starLight = $StarLight


func _on_system_star_gen(star_type):
	print("Star Type: " + star_type)
	
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
		rotation_speed_variance = [0.2,0.2]
	elif random_float > 0.99:
		rotation_speed_variance = [100,100]
	else:
		rotation_speed_variance = [0.1,10]
		
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
	starLight.light_color = Color(light_color_r, light_color_g, light_color_b)
	
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	star_rotate(delta)

func get_star_info() -> String:
	# Command currently based on Star node being in Main. Will have to change eventually.
	return "Radius: " + str(radius) + "\nMass: " + str(mass) +\
		"\nLuminosity: " + str(luminosity) + "\nTemperature: " + str(temperature) +\
		"\nColor: R-" + str(color_r) + ", G-" + str(color_g) + ", B-" + str(color_b) +\
		"\nRotation Speed: " + str(rotation_speed)
