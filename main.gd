extends Node3D

@onready var planet = preload("res://Celestial Objects/Planets/planet.tscn")

var rng = RandomNumberGenerator.new()

func general_system_gen():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var newPlanet = planet.instantiate()
	newPlanet.distance = 18
	add_child(newPlanet)
	
	var newPlanet2 = planet.instantiate()
	newPlanet2.distance = 16
	add_child(newPlanet2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
