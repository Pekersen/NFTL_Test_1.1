extends Node3D

@onready var starMesh := $RotationPoint/Core/StarMesh
@onready var starCollision := $RotationPoint/Core/StarCollision
@onready var starLight := $RotationPoint/Core/StarLight

var real_star : bool
var color : Color
var size : float

# Called when the node enters the scene tree for the first time.
func _ready():
	var random_float = randf_range(0.3, 0.7)
	starMesh.mesh.radius = size * 0.2
	starMesh.mesh.height = size * 0.2 * 2
	
	starMesh.mesh.material.set_shader_parameter("Sun_Color", color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
