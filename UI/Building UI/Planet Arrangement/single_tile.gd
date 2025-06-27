extends Node3D

@onready var circle = $circle
@onready var circle2 = $secondCircle
@onready var collision_shape = $Area3D/CollisionShape3D

var size
var element

#var object_clicked = false

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
	
	#collision_shape.disabled = true
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	'
	if get_parent().object_clicked:
		get_parent().object_clicked = false
		#collision_shape.disabled = false
		#print("SHOWING")
	'
	
	
	if size:
		circle.scale = 10
		pass


func _on_area_3d_mouse_entered():
	circle.mesh.material.albedo_color = Color(1, 0.75, 0.5, 0.05)
	circle.mesh.material.emission = Color(1, 0.75, 0.5, 0.1)
	circle.mesh.material.emission_energy_multiplier = 5.0
	
	circle2.show()
	print("Mouse Entered Tile: ", element)
	

func _on_area_3d_mouse_exited():
	circle.mesh.material.albedo_color = Color(1, 1, 1, 0.05)
	circle.mesh.material.emission = Color(1, 1, 1, 0.1)
	circle.mesh.material.emission_energy_multiplier = 2.0
	circle2.hide()
	print("Mouse Exited Tile: ", element)
