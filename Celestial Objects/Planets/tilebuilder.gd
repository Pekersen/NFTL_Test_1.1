extends Node3D

var tiles : Array
#var design = [1, 3, 5, 7, 9, 7, 5, 3, 1]
#var temp : Array
#var size = 48
var rad

#var step = 12
var number = 256
var pts = []
var radius
var object_clicked = false
var is_showing = false

var tile_distances : Array

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
	#tile_distances.resize(number)
	print("I AM BUILDING ", tiles.size()," TILES")
	
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
	pass

func _calc_position(radius, ring_count, j, sin_phi, φ):

	var θ = TAU * float(j) / float(ring_count)  # azimuth angle

	var x = radius * sin_phi * cos(θ)
	var y = radius * cos(φ)
	var z = radius * sin_phi * sin(θ)

	var pos = Vector3(x, y, z)
	
	return pos


func _new_calc_position(i: int, n: int):
	var z = ((2 * i) - 1) / (n - 1)
	var phi = 2.39 * i
	
	#var angle1 = deg_to_rad(azimuth)
	#var angle2 = deg_to_rad(polar)
	
	#var radius = range
	#var pos = Vector3(radius * cos(phi) * sqrt(1 - (z * z)), radius * sin(phi) * sqrt(1 - (z * z)), z)
	
	return #pos


func sphericalcoordinate(x, y) :
	return Vector3(rad * cos(x) * cos(y), rad * sin(x) * cos(y), rad * sin(y))
	
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
	
