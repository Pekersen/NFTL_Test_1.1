extends CharacterBody3D

@onready var springArm = $SpringArm3D
var SPEED = 7.5


func _physics_process(delta: float) -> void:
	
	var input = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input.x, 0, input.y)).normalized()
	
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	
	move_and_slide()
	
func _process(_delta: float) -> void:
	springArm.position = position
	
	if Input.is_action_just_pressed("camera_reset"):
		position.x = 0
		position.y = 2
		position.z = 0
	
	rotation_degrees.x = springArm.rotation_degrees.x
	rotation_degrees.y = springArm.rotation_degrees.y
