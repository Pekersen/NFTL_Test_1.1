extends Node3D

@onready var firstStarMesh := $Core/StarMesh
@onready var firstStarCollision := $Core/StarCollision
@onready var label1 := $Core/Label3D
#@onready var starCollision := $RotationPoint/Core/StarCollision
#@onready var starLight := $RotationPoint/Core/StarLight

var size : float
var color : Color
var object_name : String

var labels_visible = true

# Called when the node enters the scene tree for the first time.
func _ready():
	size = get_parent_node_3d().first_size
	color = get_parent_node_3d().first_color
	object_name = get_parent_node_3d().first_name
	
	firstStarMesh.mesh.radius = size * 0.1
	firstStarMesh.mesh.height = size * 0.1 * 2
	#print("FIRST STAR - Size: ", size, ", Color: ", color)
	firstStarCollision.shape.radius = size * 1.1
	
	if size > 2:
		#print("HERE!")
		pass
	
	firstStarMesh.mesh.material.set_shader_parameter("Sun_Color", color)
	
	label1.position = Vector3(0, size * 0.5, 0)
	label1.font_size = 16
	label1.text = object_name
	#firstStarMesh.mesh.resource_path = "res://Map/generic_star.tscn::SphereMesh_c8gkq"
	
	
func get_id():
	return self.get_parent().get_id()

func _input(event):
	if event.is_action_pressed("lines") and labels_visible == true:
		label1.visible = false
		labels_visible = false
	elif event.is_action_pressed("lines") and labels_visible == false:
		label1.visible = true
		labels_visible = true
		
