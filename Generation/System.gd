class_name System extends SystemGeneration
var i
# Called when the node enters the scene tree for the first time.
func _ready():
	
	system_generate(i)
	print("I 2: ", i)
	#initVars()
	#initStar()
	#initPlanetChildren()
	
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

