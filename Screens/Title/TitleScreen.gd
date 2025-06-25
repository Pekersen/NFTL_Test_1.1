extends Control
@onready var settings_screen := $SettingsScreen
@onready var splash_screen := $SplashScreen
@onready var bg = $Background

# Called when the node enters the scene tree for the first time.
func _ready():
	var disc_integration = DiscordIntegration.new()
	disc_integration.run()
	
	var rng = RandomNumberGenerator.new()
	var random_float = rng.randf()
	if random_float < 0.44:
		splash_screen.stream.file = "res://Screens/Title/NFTL-Splash-v3.ogv"
		splash_screen.play()
	elif random_float < 0.88:
		splash_screen.stream.file = "res://Screens/Title/NFTL-Splash-v4.ogv"
		splash_screen.play()
	else:
		splash_screen.visible = false
		bg.visible = true
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_settings_pressed():
	settings_screen.show()
