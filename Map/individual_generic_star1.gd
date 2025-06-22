extends Node3D

@onready var firstStarMesh := $Core/StarMesh
@onready var firstStarCollision := $Core/StarCollision
#@onready var starCollision := $RotationPoint/Core/StarCollision
#@onready var starLight := $RotationPoint/Core/StarLight

var size : float
var color : Color

# Called when the node enters the scene tree for the first time.
func _ready():
	size = get_parent_node_3d().first_size
	color = get_parent_node_3d().first_color
	firstStarMesh.mesh.radius = size * 0.1
	firstStarMesh.mesh.height = size * 0.1 * 2
	#print("FIRST STAR - Size: ", size, ", Color: ", color)
	firstStarCollision.shape.radius = size * 1.1
	
	if size > 2:
		print("HERE!")
	
	firstStarMesh.mesh.material.set_shader_parameter("Sun_Color", color)
	#firstStarMesh.mesh.resource_path = "res://Map/generic_star.tscn::SphereMesh_c8gkq"
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func get_id():
	return self.get_parent().get_id()
