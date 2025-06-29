extends Control

@onready var time_slider = $TimeSlider
@onready var fps_counter = $FpsCounter
@onready var system_name = $SystemName

@onready var resource_panel = $Info/ResourcesContainer/ResourcePanel
@onready var total_resource_bar = $Info/ResourcesContainer/ResourcePanel/TotalResourceBar

@onready var energy = $Info/ResourcesContainer/ResourcePanel/TotalResourceBar/PanelContainer1/Energy

var gui_visible = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	fps_counter.set_text("FPS %d" % Engine.get_frames_per_second())
	if !Starmap.is_visible:
		system_name.set_text("System: %s" % Start4.system_names[Start4.SYSTEM_COUNT - Start4.current_system_id - 1])
		if Start4.current_system_id == 0:
			system_name.set_text("Home System")
	else:
		system_name.set_text("Star Map")
	
	energy.set_text(" Energy: %d " % Resources.energy)

func _on_time_slider_drag_ended(_value_changed):
	GlobalVariables.ticks_per_second = time_slider.value
	print("ticks per sec: " + str(GlobalVariables.ticks_per_second))
	
# TODO: Fuking makin bettern o shod
var previous_time_value = 8
func _input(event):
	if event.is_action_pressed("space"):
		if(time_slider.value == 0):
			time_slider.value = previous_time_value
		else:
			previous_time_value = time_slider.value
			time_slider.value = 0
		GlobalVariables.ticks_per_second = time_slider.value
		
	if event.is_action_pressed("lines") and gui_visible == true:
		self.visible = false
		gui_visible = false
	elif event.is_action_pressed("lines") and gui_visible == false:
		self.visible = true
		gui_visible = true
