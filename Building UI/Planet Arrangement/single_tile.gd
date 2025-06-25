extends Node3D

@onready var hex = $hexagon
@onready var circle = $circle
@onready var collision_shape = $Area3D/CollisionShape3D

var size
var element

#var object_clicked = false

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true
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
		hex.scale = size
		circle.scale = size
		pass


func _on_area_3d_mouse_entered():
	circle.mesh.material.albedo_color = Color(1, 0.75, 0.5, 0.05)
	circle.mesh.material.emission = Color(1, 0.75, 0.5, 0.1)
	print("Mouse Entered Tile: ", element)
	

func _on_area_3d_mouse_exited():
	circle.mesh.material.albedo_color = Color(1, 1, 1, 0.05)
	circle.mesh.material.emission = Color(1, 1, 1, 0.1)
	print("Mouse Exited Tile: ", element)
	

