extends Star

@onready var starMesh = $StarMesh
@onready var starCollision = $StarCollision

func _init():
	radius_variance = [1,3] # arbitrary values
	mass_variance = [10,15]
	radius = offsetValue(radius, radius_variance)
	mass = offsetValue(mass, mass_variance)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	starMesh.mesh.radius = radius
	starMesh.mesh.height = radius * 2
	
	starCollision.shape.radius = radius + click_forgiveness
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
