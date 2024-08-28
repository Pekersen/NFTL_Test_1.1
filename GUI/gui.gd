extends Control

@onready var time_slider = $TimeSlider
@onready var fps_counter = $FpsCounter
var time_speed = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fps_counter.set_text("FPS %d" % Engine.get_frames_per_second())


func _on_time_slider_drag_ended(_value_changed):
	Global.ticks_per_second = time_slider.value
	print("ticks per sec: " + str(Global.ticks_per_second))
