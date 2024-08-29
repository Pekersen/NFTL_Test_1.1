extends Node3D

@onready var camera = $PlayerCamera
@onready var console = $ConsoleWindow
@onready var system = $System
@onready var star = $Star
var rng = RandomNumberGenerator.new()

func _ready():
	console.hid_console.connect(on_console_visibility_change)

func general_system_gen():
	pass

func _input(event):
	if event.is_action_pressed("console_switch"):
		console.visible = !console.visible
		on_console_visibility_change()
		
func on_console_visibility_change():
	camera.movement_enabled = !console.visible
		
func set_ticks_per_second(value: float):
	if value < 0:
		value = 0
	Global.ticks_per_second = value
	return "Ticks per second were set to " + str(Global.ticks_per_second)
