extends Belts

@onready var asteroid = preload("res://Celestial Objects/Belts/Asteroid Scenes/asteroid.tscn")
@onready var asteroid1 = preload("res://Celestial Objects/Belts/Asteroid Scenes/asteroid1.tscn")
@onready var asteroid2 = preload("res://Celestial Objects/Belts/Asteroid Scenes/asteroid2.tscn")
@onready var asteroid3 = preload("res://Celestial Objects/Belts/Asteroid Scenes/asteroid3.tscn")
@onready var asteroid4 = preload("res://Celestial Objects/Belts/Asteroid Scenes/asteroid4.tscn")
@onready var asteroid5 = preload("res://Celestial Objects/Belts/Asteroid Scenes/asteroid5.tscn")

var asteroid_num : float
var inner : float
var outer : float

var s = Start4.scale

# Called when the node enters the scene tree for the first time.
func _ready():
	#print("ASTEROID NUM: ", asteroid_num)
	for i in range(asteroid_num):
		var rand = randi_range(0, 4)
		var asteroidInstance
		match rand:
			0:
				asteroidInstance = asteroid1.instantiate()
			1:
				asteroidInstance = asteroid2.instantiate()
			2:
				asteroidInstance = asteroid3.instantiate()
			3:
				asteroidInstance = asteroid4.instantiate()
			4:
				asteroidInstance = asteroid5.instantiate()
			
		initAsteroidVars(asteroidInstance)
		add_child(asteroidInstance)
		asteroidInstance.position = asteroidPosition(inner, outer)
		#print("BUILT ASTEROID: ", asteroidInstance.position)
		

func initAsteroidVars(asteroidInstance):
	var size = randf_range(0.005, 0.03) * s
	#asteroidInstance.mesh.radius = size
	#asteroidInstance.mesh.height = size * 2
	
	var color = randf_range(0.1, 0.9)
	#asteroidInstance.mesh.material.albedo_color = Color(color, color, color)

func asteroidPosition(inner_pos, outer_pos):
	var angle1 = randf_range(0, TAU)  # Random azimuth angle
	#var angle2 = randf_range(0, PI)  # Random polar angle
	var r = randf_range(inner_pos,outer_pos)  # Distance from center
	var pos = Vector3(
		r * cos(angle1),
		randf_range(-2, 2),
		r * sin(angle1)
	)
	return pos
	
	
	
	
