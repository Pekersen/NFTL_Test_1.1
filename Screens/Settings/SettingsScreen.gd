extends Window

var padding_scale = 0.2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_visibility_changed():
	size = DisplayServer.window_get_size() - \
	Vector2i(
		padding_scale * DisplayServer.window_get_size().x,
		padding_scale * DisplayServer.window_get_size().y
		)
	position = Vector2i(
		DisplayServer.window_get_size().x * 0.5 * padding_scale,
		DisplayServer.window_get_size().y * 0.5 * padding_scale
	)


func _on_close_requested():
	hide()
