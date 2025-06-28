extends SpringArm3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("left"):
		rotation_degrees.y -= 5
	if Input.is_action_pressed("right"):
		rotation_degrees.y += 5
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.is_action_just_pressed("camera_confine"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		
