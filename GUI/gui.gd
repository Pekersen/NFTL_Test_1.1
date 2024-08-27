extends Control

@onready var time_slider = $TimeSlider
var time_speed = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_time_slider_drag_ended(value_changed):
	Global.time_speed = time_slider.value
