extends Node3D

#@onready var firstStarMesh := $RotationPoint/Core/StarMesh
#@onready var starCollision := $RotationPoint/Core/StarCollision
#@onready var starLight := $RotationPoint/Core/StarLight

@onready var firstStarRotPoint := $RotationPoint
@onready var secondStarRotPoint := $RotationPoint2

@onready var firstCore := $RotationPoint/Core
#@onready var secondStarMesh := $RotationPoint2/Core2/StarMesh2

#var real_star : bool
var first_color : Color
var first_size : float

var second_star = false
var second_color : Color
var second_size : float
var second_position : Vector3

var id : int
var is_real = true

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#print("FIRST SIZE: ", first_size, ", FIRST COLOR: ", first_color)
	#firstStarRotPoint.size = first_size
	#firstStarRotPoint.color = first_color
	
	#print("ACTUAL FIRST STAR - Size: ", starMesh.mesh.radius / 0.2, ", Color: ", starMesh.mesh.material.get_shader_parameter("Sun_Color"))
	
	if second_star:
		secondStarRotPoint.show()
		secondStarRotPoint.position = second_position
		
		#print("SECOND SIZE: ", second_size, ", SECOND COLOR: ", second_color)
		#secondStarRotPoint.size = second_size
		#secondStarRotPoint.color = second_color
		
		#print("ACTUAL FIRST STAR - Size: ", firstStarMesh.mesh.radius / 0.2, ", Color: ", firstStarMesh.mesh.material.get_shader_parameter("Sun_Color"))
		#print("ACTUAL SECOND STAR - Size: ", secondStarMesh.mesh.radius / 0.2, ", Color: ", secondStarMesh.mesh.material.get_shader_parameter("Sun_Color"))
		
	
	#WHICHEVER IS SECOND SEEMS TO TAKE PRIORITY AND BOTH STARS WILL APPEAR THAT WAY
	
func get_id():
	if !is_real:
		return -1
	return id
