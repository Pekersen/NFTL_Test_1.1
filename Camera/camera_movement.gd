extends CharacterBody3D

@onready var springArm = $SpringArm3D
@onready var camera = $SpringArm3D/Camera3D
var SPEED = 7.5
var SPEED_INCREASE = 1.0

var clicked_node
var following := false

func _physics_process(delta: float) -> void:
	
	var input = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input.x, 0, input.y)).normalized()
	
	velocity.x = direction.x * SPEED * SPEED_INCREASE
	velocity.z = direction.z * SPEED * SPEED_INCREASE
	
	if abs(input) > Vector2(0,0):
		following = false
	
	move_and_slide()
	
func _process(_delta: float) -> void:
	springArm.position = position
	
	if Input.is_action_pressed("shift"):
		SPEED_INCREASE = 3.0
		
	elif Input.is_action_pressed("ctrl"):
		SPEED_INCREASE = 1.0/3
		
	else:
		SPEED_INCREASE = 1.0
	
	if Input.is_action_just_pressed("camera_reset"):
		position.x = 0
		position.y = 2
		position.z = 0
	
	rotation_degrees.x = springArm.rotation_degrees.x
	rotation_degrees.y = springArm.rotation_degrees.y
	
	if following:
		follow_camera()
	
func _input(event):
	if event.is_action_released("click"):
		shoot_ray()
	
func shoot_ray():
	# Get the position of the mouse on the screen (in 2D viewport coordinates)
	var mouse_pos = get_viewport().get_mouse_position()
	# Define the length of the ray to be cast (1000 units in 3D space)
	var ray_length = 1000
	# Calculate the origin point of the ray in 3D space using the camera's 
	# position and the mouse position
	var from = camera.project_ray_origin(mouse_pos)
	# Calculate the end point of the ray in 3D space by extending the ray 
	# from its origin along its direction (normal)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	# Get the space state from the 3D world to perform the raycasting operation
	var space = get_world_3d().direct_space_state
	# Create a new PhysicsRayQueryParameters3D object to define the parameters 
	# for the raycast
	var ray_query = PhysicsRayQueryParameters3D.new()
	# Set the origin point of the ray
	ray_query.from = from
	# Set the target point of the ray (where the ray ends after traveling the 
	# defined length)
	ray_query.to = to
	# Perform the raycast and store the result (if the ray hits something, the 
	# result will contain information about the hit)
	var raycast_result = space.intersect_ray(ray_query)

	# HERE IS WHERE YOU CAN MAKE IT DO SOMETHING (LIKE OPEN A GUI MENU)
	# TODO:
	if !raycast_result.is_empty():
		following = true
		print("clicked " + str(raycast_result.collider))
		clicked_node = raycast_result.collider
		
		
func follow_camera():
	position = clicked_node.global_position

