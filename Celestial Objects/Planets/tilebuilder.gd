extends Node3D

var tiles : Array
var rad

var number = 256
var pts = []
var object_clicked = false
var is_showing = false

var tile_distances : Array

var tile_angles : Array
var internal = false
var sphere_center
var current_tile

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	hide()
	

func build(radius):
	var tile = preload("res://Building UI/Planet Arrangement/single_tile.tscn")
	number = radius * radius * number / 12
	if number < 2:
		number = 2
	
	tiles.resize(number)
	tile_angles.resize(number)
	
	rad = radius
	
	generatepoints(number)
	
	for i in range(number):
		var tile_instance = tile.instantiate()
		tile_instance.position = pts[i]
		tile_instance.global_transform = _calc_rotation(tile_instance.position)
		tile_instance.element = i
		tiles[i] = tile_instance
		add_child(tile_instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sphere_center = get_parent().get_parent().global_position
	
	if internal:
		var new_tile = get_tile_under_mouse(get_viewport().get_camera_3d(), get_viewport().get_mouse_position(), sphere_center, rad)
		if new_tile != current_tile:
			if current_tile:
				current_tile.unhighlight()
			current_tile = new_tile
			current_tile.highlight()


func sphericalcoordinate(x, y) :
	var pos = Vector3(rad * cos(x) * cos(y), rad * sin(x) * cos(y), rad * sin(y))
	tile_angles.append(cartesian_to_spherical(pos, Vector3(0,0,0)))
	return pos
	
func NX(n, x) :
	var start = (-1.0 + 1.0 / (n - 1.0))
	var increment = (2.0 - 2.0 / (n - 1.0) ) / (n - 1.0)
	for j in range(0 , n) :
		var s = start + j * increment
		pts.append(sphericalcoordinate(s * x , PI / 2.0 * sign(s) * (1.0 - sqrt(1.0 - abs(s)))))
	return pts
	
func generatepoints(n) :
	return NX(n , 0.1 + 1.2 * n)
	
func _calc_rotation(tile_pos : Vector3):
	
	var dx = tile_pos.x# - center.x
	var dy = tile_pos.y# - center.y
	var dz = tile_pos.z# - center.z

	var up = Vector3(dx, dy, dz)

	# Choose reference that’s not parallel to up
	var ref = Vector3.UP
	if abs(up.dot(ref)) > 0.99:
		ref = Vector3.RIGHT

	var fwd = up.cross(ref)
	var right = up.cross(fwd)

	var transform = Transform3D()
	transform.basis.x = right.normalized()
	transform.basis.y = up.normalized()
	transform.basis.z = fwd.normalized()
	transform.origin = tile_pos

	return transform

func clicked():
	if is_showing:
		visible = false
		hide()
		is_showing = false
		process_mode = 4
	else:
		visible = true
		show()
		is_showing = true
		process_mode = 0
	
func cartesian_to_spherical(point: Vector3, center: Vector3) -> Vector2:
	var rel = point - center
	var r = rel.length()
	var θ = atan2(rel.z, rel.x)  # Azimuth (longitude)
	var φ = acos(clamp(rel.y / r, -1.0, 1.0))  # Polar (latitude)

	return Vector2(θ, φ)
	
func get_tile_under_mouse(camera: Camera3D, mouse_pos: Vector2, sphere_center: Vector3, radius: float) -> Node3D:
	var hit_point = camera.get_parent().get_parent().get_mouse_hit_point_on_sphere(camera, mouse_pos, sphere_center, radius)
	if hit_point == null:
		return null
	
	#print("POSITION: ", hit_point)
	return tiles[find_closest_tile_index(hit_point, pts)]


func _on_area_3d_mouse_entered():
	if is_showing:
		#print("ENTERING")
		internal = true
		
func _on_area_3d_mouse_exited():
	if is_showing:
		#print("EXITING")
		internal = false


func find_closest_tile_index(hit_pos: Vector3, tile_positions: Array) -> int:
	var closest_tile = null
	var min_distance := INF

	for tile in tiles:
		var tile_pos = tile.global_transform.origin
		var dist = hit_pos.distance_squared_to(tile_pos)  # faster than .distance_to()

		if dist < min_distance:
			min_distance = dist
			closest_tile = tile

	return tiles.find(closest_tile)
