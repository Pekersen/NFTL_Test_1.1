extends Node3D

@onready var planet = preload("res://Celestial Objects/Planets/planet.tscn")

var rng = RandomNumberGenerator.new()

func general_system_gen():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var newPlanet = planet.instantiate()
	print("gen1.1")
	newPlanet.distance = 18
	print("gen1.2 instantiate and set distance")
	add_child(newPlanet)
	print("gen1.3")
	
	var newPlanet2 = planet.instantiate()
	print("gen2.1")
	newPlanet2.distance = 16
	print("gen2.2 instantiate and set distance")
	add_child(newPlanet2)
	print("gen2.3")

	var newPlanet3 = planet.instantiate()
	print("gen3.1")
	newPlanet3.distance = 22
	print("gen3.2 instantiate and set distance")
	add_child(newPlanet3)
	print("gen3.3")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
