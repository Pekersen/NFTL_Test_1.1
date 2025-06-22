extends CharacterBody3D

@onready var springArm = $SpringArm3D
@onready var camera = $SpringArm3D/Camera3D
var SPEED = 150
var SPEED_INCREASE = 1.0

var clicked_node
var following := false
@export var rotation_lock := false

var cameraRotationDifference = Vector3.ZERO
var calculatingCamera = false
var springArmIntitialRotation = Vector3.ZERO

var free_movement_enabled := true
var locked_movement_enabled := false

var locked_camera_offset := Vector3.ZERO

signal cam_move_to_spring_arm(radius1)

var starmap_visible = false

func _on_star_star_rad_for_cam(radius):
	var radius1 = radius
	cam_move_to_spring_arm.emit(radius1)

	

func _physics_process(delta: float) -> void:
	if Starmap.is_visible:
		free_movement_enabled = false
		reset()
		#position = Vector3(0,0,0)
		starmap_visible = true
		
	else:
		free_movement_enabled = true
		starmap_visible = false
	
	
	if free_movement_enabled:
		var input = Input.get_vector("left", "right", "forward", "back")
		var direction = (transform.basis * Vector3(input.x, 0, input.y)).normalized()
		
		velocity.x = direction.x * SPEED * SPEED_INCREASE
		velocity.z = direction.z * SPEED * SPEED_INCREASE
		
		if abs(input) > Vector2(0,0):
			following = false
		
		if (Input.is_action_pressed("upward")):
			velocity.y = SPEED * SPEED_INCREASE
		elif (Input.is_action_pressed("downward")):
			velocity.y = -SPEED * SPEED_INCREASE
		else:
			velocity.y = 0
		
		move_and_slide()
	elif locked_movement_enabled:
		var input = Input.get_vector("left", "right", "forward", "back")
		var direction = (transform.basis * Vector3(input.x, 0, input.y)).normalized()
		
		if direction.x != 0:
			locked_camera_offset.x += direction.x * SPEED * SPEED_INCREASE / 1000
		if direction.z != 0:
			locked_camera_offset.z += direction.z * SPEED * SPEED_INCREASE / 1000
		
		if (Input.is_action_pressed("upward")):
			locked_camera_offset.y += SPEED * SPEED_INCREASE / 1000
		elif (Input.is_action_pressed("downward")):
			locked_camera_offset.y += -SPEED * SPEED_INCREASE / 1000
	
	
	if following:
		follow_camera()
	if rotation_lock and springArm.mouse_locked and clicked_node != null:
		if !calculatingCamera:
			springArmIntitialRotation = springArm.rotation
		cameraRotationDifference = springArm.rotation -\
						springArmIntitialRotation - clicked_node.rotation
		calculatingCamera = true
	else:
		calculatingCamera = false
	
func _process(_delta: float) -> void:
	springArm.position = position
	
	if Input.is_action_pressed("shift") and Input.is_action_pressed("ctrl"):
		SPEED_INCREASE = 10.0
	
	elif Input.is_action_pressed("shift"):
		SPEED_INCREASE = 5.0
		
	elif Input.is_action_pressed("ctrl"):
		SPEED_INCREASE = 0.1
		
	else:
		SPEED_INCREASE = 1.0
	
	if Input.is_action_just_pressed("camera_reset"):
		reset()
	
	rotation_degrees.x = springArm.rotation_degrees.x
	rotation_degrees.y = springArm.rotation_degrees.y

	
func _input(event):
	if event.is_action_released("click"):
		shoot_ray_left()
	if event.is_action_pressed("right click"):
		shoot_ray_right()
	if event.is_action_pressed("locked_camera_movement_switch"):
		locked_movement_enabled = !locked_movement_enabled
		free_movement_enabled = !locked_movement_enabled
		if !locked_camera_offset:
			locked_camera_offset = Vector3.ZERO
	
	
	# Making a right click function
func shoot_ray_right():
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
	var raycast_result_right = space.intersect_ray(ray_query)
	
	if !raycast_result_right.is_empty():
		get_tree().change_scene_to_file("res://Celestial Objects/Planets/planet_world.tscn")
		
	
func shoot_ray_left():
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
		clicked_node = raycast_result.collider
		if starmap_visible == true:
			if clicked_node.get_parent().get_id() != -1:
				print("ATTEMPTING SWITCH TO SYSTEM ", (Start4.SYSTEM_COUNT - clicked_node.get_parent().get_id()) - 1)
				springArm._spring_arm_target_length = 1.0
				Starmap.on_click = true
				Starmap.toggle_map()
				Start4.switch_to_star_system((Start4.SYSTEM_COUNT - clicked_node.get_parent().get_id()) - 1)
				
		else:
			following = true
			print("clicked " + str(raycast_result.collider))
			springArmIntitialRotation = springArm.rotation
			cameraRotationDifference = Vector3.ZERO
			print(springArmIntitialRotation)
		
			
			#print("ATTEMPTING SWITCH TO SYSTEM ", clicked_node.get_parent().get_parent().id)
		
func follow_camera():
	position = clicked_node.global_position + locked_camera_offset
	#print("pos: ", locked_camera_offset)
	if !springArm.mouse_locked and !calculatingCamera and rotation_lock:
		springArm.global_rotation = springArmIntitialRotation +\
			 			cameraRotationDifference + clicked_node.global_rotation
	
func locked_camera_rotation(value : bool):
	rotation_lock = value
	# when console does command:
	return "Locked camera rotation was set to " + str(value)

func reset():
	#print("RESET")
	position.x = 0
	position.y = 0
	position.z = 0
	rotation.x = 0
	rotation.y = 0
	rotation.z = 0
	following = false
