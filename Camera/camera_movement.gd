extends CharacterBody3D

@onready var springArm = $SpringArm3D
@onready var camera = $SpringArm3D/Camera3D
var SPEED = 150
var SPEED_INCREASE = 1.0

var clicked_node
var following := false
@export var rotation_lock := false

var free_movement_enabled := true
var locked_movement_enabled := false

var locked_camera_offset := Vector3.ZERO

var on_planet = false

signal cam_move_to_spring_arm(radius1)

func _on_star_star_rad_for_cam(radius):
	var radius1 = radius
	cam_move_to_spring_arm.emit(radius1)

	

func _physics_process(_delta: float) -> void:	
	if free_movement_enabled:
		var input = Input.get_vector("left", "right", "forward", "back")
		var direction = (transform.basis * Vector3(input.x, 0, input.y)).normalized()
		
		velocity.x = direction.x * SPEED * SPEED_INCREASE
		velocity.z = direction.z * SPEED * SPEED_INCREASE
		
		if input and on_planet:
			on_planet = false
		
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
	if rotation_lock and clicked_node != null:
		pass
	
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
	
	if Input.is_action_just_pressed("test"):
		if clicked_node is StaticBody3D:
			clicked_node.get_parent().get_parent().can_orbit = !clicked_node.get_parent().get_parent().can_orbit
	
	rotation_degrees.x = springArm.rotation_degrees.x
	rotation_degrees.y = springArm.rotation_degrees.y
	


	
func _input(event):
	if event.is_action_pressed("starmap"):
		if !Starmap.map_generated:
			Starmap.generate_galaxy_map()
			Starmap.map_generated = true	
		Starmap.toggle_map()
		if Starmap.is_visible:
			free_movement_enabled = false
			locked_movement_enabled = false
			reset()
		else:
			free_movement_enabled = true
			locked_movement_enabled = false
	if event.is_action_released("click"):
		shoot_ray_left()
	if event.is_action_pressed("right click"):
		shoot_ray_right()
	if event.is_action_pressed("locked_camera_movement_switch"):
		locked_movement_enabled = !locked_movement_enabled
		free_movement_enabled = !locked_movement_enabled
		print("locked, ",  locked_movement_enabled)
		print("free, ", free_movement_enabled)
		if !locked_camera_offset:
			locked_camera_offset = Vector3.ZERO
	
	# Making a right click function

func shoot_ray_right():
	# Get the position of the mouse on the screen (in 2D viewport coordinates)
	var mouse_pos = get_viewport().get_mouse_position()
	# Define the length of the ray to be cast (1000 units in 3D space)
	var ray_length = 2000
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
	var ray_length = 2000
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
		if Starmap.is_visible:
			if clicked_node.get_parent().get_id() != -1:
				print("ATTEMPTING SWITCH TO SYSTEM ", (Start4.SYSTEM_COUNT - clicked_node.get_parent().get_id()) - 1)
				springArm._spring_arm_target_length = 1.0
				Starmap.on_click = true
				Starmap.toggle_map()
				Start4.switch_to_star_system((Start4.SYSTEM_COUNT - clicked_node.get_parent().get_id()) - 1)
				
		else:
			#if on_planet:
			#	on_planet = false
			
			following = true
			print("clicked " + str(raycast_result.collider), " with parent ", clicked_node.get_parent(), " which has parent ", clicked_node.get_parent().get_parent())
			if !on_planet:
				on_planet = true
				#springArmIntitialRotation = springArm.rotation
				#cameraRotationDifference = Vector3.ZERO
				#print(springArmIntitialRotation)
				springArm._spring_arm_target_length = clicked_node.get_parent().get_parent().radius * 3.0
				clicked_node.get_parent().get_parent().object_is_clicked()
				
			
			
			#print("ATTEMPTING SWITCH TO SYSTEM ", clicked_node.get_parent().get_parent().id)
		
func follow_camera():
	position = clicked_node.global_position + locked_camera_offset
	#print("pos: ", locked_camera_offset)
	if rotation_lock:
		springArm.rotate(clicked_node.get_parent().get_parent().axis_of_rot, clicked_node.get_parent().get_parent().rotation_velocity)
	
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
