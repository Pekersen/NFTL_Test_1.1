extends RichTextLabel

@onready var tech_tree_element := $"../../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	custom_minimum_size = Vector2.ZERO
	if tech_tree_element.texture != null:
		custom_minimum_size.x = tech_tree_element.size.x - tech_tree_element.texture.get_size().x - 100
