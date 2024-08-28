extends Node3D

@onready var console = $ConsoleWindow
@onready var system = $System
@onready var star = $Star
var rng = RandomNumberGenerator.new()

func general_system_gen():
	pass

func _input(event):
	if event.is_action_pressed("console_switch"):
		console.visible = !console.visible
		
func set_time_scale(value: float):
	if value < 0:
		value = 0
	Global.ticks_per_second = value
	return "Time scale was set to " + str(Global.ticks_per_second)
