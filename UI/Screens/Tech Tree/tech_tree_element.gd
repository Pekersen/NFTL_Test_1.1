@tool
class_name TechTreeElement
extends GraphNode

signal obtained(TechTreeElement)

@export var texture : Texture2D
@export_multiline var description_string : String
@export_group("Connections")
@export var prerequisites : Array[TechTreeElement]
@export var other_prerequisites : Array[String]
@export var dependents : Array[TechTreeElement]
@export var other_dependents : Array[String]

@onready var element_texture := $HBoxContainer/CenterTexture/ElementTexture
@onready var description := $HBoxContainer/CenterDescription/Description

var is_unlocked := false
var is_obtained := false
var item_name := ""

func _ready():
	element_texture.texture = texture
	if !Engine.is_editor_hint():
		description.text = description_string
		selectable = false
		unlock(is_unlocked)
		item_name = title

func _process(_delta):
	if Engine.is_editor_hint():
		element_texture.texture = texture

func obtain(b : bool) -> void:
	if b and !is_obtained:
		# do obtaining stuff
		is_obtained = true
		obtained.emit(self)

func unlock(b : bool) -> void:
	is_unlocked = b
	if b:
		modulate = Color.WHITE
	else:
		modulate = Color.DIM_GRAY

func _enable_spacecraft(spacecraft) -> void:
	pass

func _enable_building(building) -> void:
	pass

func _enable_resource(resource) -> void:
	pass

func _enable_computing(computing) -> void:
	pass
	
func _enable_physics(physics) -> void:
	pass
	
func _enable_weapon(weapon) -> void:
	pass

func _enable_bio(bio) -> void:
	pass


func _on_mouse_entered():
	if selectable:
		modulate = Color.WHITE


func _on_mouse_exited():
	if !is_obtained:
		modulate = Color.DIM_GRAY


func _on_node_selected():
	obtain(true)
	selected = false
	
