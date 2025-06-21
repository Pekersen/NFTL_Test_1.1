extends SpringArm3D

@export var mouse_sensitivity := 0.15

var camera_min : float
var star_radius : float = 0.0

var starmap_reset = false
# zoom
@export_group("Camera Zoom")
## Default distance to set the camera from the player.
@export var camera_default_distance := 2.0
## Maximum distance the camera can zoom out to.
@export var camera_distance_max := 1000.0
## Mininum distance the camera can zoom in to.
@export var camera_distance_min := 1.0 # TODO: Make it variable to celestial obj size
## How far the camera will move per zoom input.
@export var camera_zoom_step := 3.0#0.6
## How quickly the camera zoom interpolates.
@export var camera_lerp_speed := 5.0
# zoom

var mouse_locked = false

# zoom
# Variable for handling smooth zooming.
var _spring_arm_target_length := camera_default_distance

## The camera [SpringArm3D], which prevents the camera passing through objects.
@onready var spring_arm := $"." as SpringArm3D
## The main player [Camera3D].
@onready var cam := $Camera3D as Camera3D
# zoom

var zoom_increase = 1.0


func _ready() -> void:
	set_as_top_level(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	
	# zoom
	spring_arm.spring_length = camera_default_distance
	# zoom
	
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and mouse_locked == true:
		rotation_degrees.x -= event.relative.y * mouse_sensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, -60.0, 60.0)
		
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)
		
	# Handle camera zoom.
	elif event.is_action_pressed("zoom_in"):
		_spring_arm_target_length -= camera_zoom_step * zoom_increase
		_spring_arm_target_length = clamp(_spring_arm_target_length, camera_distance_min, camera_distance_max)
	elif event.is_action_pressed("zoom_out"):
		_spring_arm_target_length += camera_zoom_step * zoom_increase
		_spring_arm_target_length = clamp(_spring_arm_target_length, camera_distance_min, camera_distance_max)
	# zoom
	
	
func _input(event):
	if event.is_action_pressed("camera_to_cursor"):
		mouse_locked = true
		
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		
	if event.is_action_pressed("camera_confine"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		
		
func _process(delta):
	
	if not Input.is_action_pressed("camera_to_cursor") and mouse_locked == true:
		mouse_locked = false
	
		
	if Input.is_action_pressed("shift") and Input.is_action_pressed("ctrl"):
		zoom_increase = 10.0
	
	elif Input.is_action_pressed("shift"):
		zoom_increase = 5.0
		
	elif Input.is_action_pressed("ctrl"):
		zoom_increase = 1.0/3
		
	else:
		zoom_increase = 1.0
		
	# zoom
		# Handle smooth camera zooming.
	if _spring_arm_target_length != spring_arm.spring_length:
		spring_arm.spring_length = lerp(spring_arm.spring_length, _spring_arm_target_length, camera_lerp_speed * delta)
	# zoom
	
	if Starmap.is_visible:
		if starmap_reset == false:
			_spring_arm_target_length = Start4.SYSTEM_COUNT * 0.5
			starmap_reset = true
		camera_distance_min = 0.5
		camera_distance_max = Start4.SYSTEM_COUNT * 2
	else:
		starmap_reset = false
		camera_distance_min = 1.0
		camera_distance_max = 1000.0
	
func _on_base_point_cam_move_to_spring_arm(radius1):
	star_radius = radius1
	camera_min = 2 * star_radius
	
	#camera_distance_min = camera_min
	_spring_arm_target_length = camera_min
	spring_arm.spring_length = camera_min

