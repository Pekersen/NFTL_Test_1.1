extends Node3D

@onready var secondStarMesh := $Core2/StarMesh2
@onready var secondStarCollision := $Core2/StarCollision2
#@onready var label2 := $RotationPoint2/Core2/Label3D

var size : float
var color : Color
var second_star
var object_name : String

# Called when the node enters the scene tree for the first time.
func _ready():
	second_star = get_parent_node_3d().second_star
	if second_star:
		size = get_parent_node_3d().second_size
		color = get_parent_node_3d().second_color
		
		secondStarMesh.mesh.radius = size * 0.1
		secondStarMesh.mesh.height = size * 0.1 * 2
		#print("SECOND STAR - Size: ", size, ", Color: ", color)
		#secondStarCollision.shape.radius = size * 0.11
		
		if size > 2:
			#print("HERE!")
			pass
					
		secondStarMesh.mesh.material.set_shader_parameter("Sun_Color", color)
		#secondStarMesh.mesh.resource_path = "res://Map/generic_star.tscn::SphereMesh_00000"
		
		#label2.position = Vector3(0, size * 0.5, 0)
		#label2.font_size = 12	
		#label2.text = object_name
	

	
func get_id():
	return self.get_parent().get_id()
