extends Planet

@onready var ring_mesh = $Torus

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Ring Size 3: " + str(semi_major_axis))
	ring_mesh.mesh.outer_radius = semi_major_axis + 0.0025
	ring_mesh.mesh.inner_radius = semi_major_axis - 0.0025
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
