extends Node3D

@onready var secondStarMesh := $Core2/StarMesh2

var size : float
var color : Color
var second_star

# Called when the node enters the scene tree for the first time.
func _ready():
	size = get_parent_node_3d().second_size
	color = get_parent_node_3d().second_color
	second_star = get_parent_node_3d().second_star
	if second_star:
		secondStarMesh.mesh.radius = size * 0.2
		secondStarMesh.mesh.height = size * 0.2 * 2
		#print("SECOND STAR - Size: ", size, ", Color: ", color)
		if size > 2:
			print("HERE!")
					
		secondStarMesh.mesh.material.set_shader_parameter("Sun_Color", color)
		#secondStarMesh.mesh.resource_path = "res://Map/generic_star.tscn::SphereMesh_00000"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
