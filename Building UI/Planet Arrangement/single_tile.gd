extends Node3D

@onready var circle = $circle
@onready var circle2 = $secondCircle


var size
var element

var on_tile = false

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true
	circle.mesh.material.albedo_color = Color(1, 1, 1, 0.05)
	circle.mesh.material.emission = Color(1, 1, 1, 0.1)
	circle.mesh.material.emission_energy_multiplier = 2.0
	
	circle2.mesh.material.albedo_color = Color(1, 0.75, 0.5, 0.05)
	circle2.mesh.material.emission = Color(1, 0.75, 0.5, 0.1)
	circle2.mesh.material.emission_energy_multiplier = 5.0
	circle2.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if size:
		circle.scale = 10
		pass
	
func highlight():
	circle.mesh.material.albedo_color = Color(1, 0.75, 0.5, 0.05)
	circle.mesh.material.emission = Color(1, 0.75, 0.5, 0.1)
	circle.mesh.material.emission_energy_multiplier = 5.0
	circle2.show()
	on_tile = true
	#print("HIGHLIGHTING")
	
func unhighlight():
	circle.mesh.material.albedo_color = Color(1, 1, 1, 0.05)
	circle.mesh.material.emission = Color(1, 1, 1, 0.1)
	circle.mesh.material.emission_energy_multiplier = 2.0
	circle2.hide()
	on_tile = false
	#print("UNHIGHLIGHTING")
	
func _input(event):
	if event.is_action_pressed("click") and on_tile:
		left_click()
	if event.is_action_pressed("right click") and on_tile:
		right_click()
		
func left_click():
	print("Tile ", element, " was left-clicked")
	
func right_click():
	print("Tile ", element, " was right-clicked")
