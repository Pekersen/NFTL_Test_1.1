extends Node3D

@onready var console = $ConsoleWindow

var rng = RandomNumberGenerator.new()

func general_system_gen():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("console_switch"):
		console.visible = !console.visible
