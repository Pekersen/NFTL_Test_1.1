extends Node3D

var energy
var is_controlled = false
var id

# Called when the node enters the scene tree for the first time.
func _ready():
	energy = 0
	if id == 0:
		is_controlled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_controlled:
		Resources.local_energy[id] = energy
	
func _input(event):
	if event.is_action_pressed("resource_change"):
		var random_float = randf_range(0, 10)
		energy += random_float
		print("Changing energy by ", random_float)


func _on_system_system_to_localresources(system_id : int):
	id = system_id
