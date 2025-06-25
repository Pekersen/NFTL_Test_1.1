extends Node3D

@onready var hex = $hexagon
@onready var circle = $circle
@onready var collision_shape = $Area3D/CollisionShape3D

var size
var element
var object_is_clicked = false

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true
	collision_shape.disabled = true
	self.hide()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if object_is_clicked:
		collision_shape.disabled = false
		self.show()
	
	if size:
		hex.scale = size
		circle.scale = size
		pass


func _on_area_3d_mouse_entered():
	print("Mouse Entered Tile: ", element)
	

func _on_area_3d_mouse_exited():
	print("Mouse Exited Tile: ", element)
