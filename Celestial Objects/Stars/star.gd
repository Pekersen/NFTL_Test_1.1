extends Star

@onready var starMesh = $StarMesh
@onready var starCollision = $StarCollision
@onready var starLight = $StarLight

func _init():
	radius_variance = [1,4] # arbitrary values
	mass_variance = [10,15]
	luminosity_variance = [1,10]
	
	radius = offsetValue(radius_variance)
	mass = offsetValue(mass_variance)
	luminosity = offsetValue(luminosity_variance)

# Called when the node enters the scene tree for the first time.
func _ready():
	starMesh.mesh.radius = radius
	starMesh.mesh.height = radius * 2
	
	starCollision.shape.radius = radius + click_forgiveness
	
	print(luminosity)
	starLight.light_energy = luminosity
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
