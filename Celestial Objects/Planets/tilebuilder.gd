extends Node3D

@onready var tile = preload("res://Building UI/Planet Arrangement/single_tile.tscn")

var tiles : Array
var design = [1, 3, 5, 7, 9, 7, 5, 3, 1]
var temp : Array
var size = 9
var range = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	tiles.resize(size)
	
	for i in range(size):
		for j in range(design[i]):
			var tile_instance = tile.instantiate()
			tile_instance.position = _calc_position(range)
			tile_instance.global_transform = _calc_rotation(tile_instance.position)
			tiles.append(tile_instance)
			add_child(tile_instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _calc_position(range):
	var angle1 = randf_range(0, TAU)  # Random azimuth angle
	var angle2 = randf_range(0, TAU)  # Random polar angle
	var radius = range  # Distance from center
	var pos = Vector3(
		radius * sin(angle2) * cos(angle1),
		radius * sin(angle2) * sin(angle1),
		radius * cos(angle2)
	)
	return pos
	
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
