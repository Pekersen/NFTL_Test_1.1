extends Control

@onready var time_slider = $TimeSlider
@onready var fps_counter = $FpsCounter
@onready var system_name = $SystemName

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fps_counter.set_text("FPS %d" % Engine.get_frames_per_second())
	if !Starmap.is_visible:
		system_name.set_text("System Name: %d" % Start4.current_system_id)
		if Start4.current_system_id == 0:
			system_name.set_text("System Name: Home System")
	else:
		system_name.set_text("Star Map")

func _on_time_slider_drag_ended(_value_changed):
	Global.ticks_per_second = time_slider.value
	print("ticks per sec: " + str(Global.ticks_per_second))
	
# TODO: Fuking makin bettern o shod
var previous_time_value = 8
func _input(event):
	if event.is_action_pressed("space"):
		if(time_slider.value == 0):
			time_slider.value = previous_time_value
		else:
			previous_time_value = time_slider.value
			time_slider.value = 0
		Global.ticks_per_second = time_slider.value
