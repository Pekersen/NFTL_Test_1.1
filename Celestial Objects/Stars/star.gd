extends Star

@onready var starMesh = $StarMesh

# Called when the node enters the scene tree for the first time.
func _ready():
	radius = 1.0
	mass = 10.0

	starMesh.mesh.radius = radius
	starMesh.mesh.height = radius * 2
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
