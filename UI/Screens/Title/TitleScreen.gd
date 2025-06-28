extends Control
@onready var settings := $Settings
@onready var splash_screen := $SplashScreen
@onready var bg = $Background
@onready var title_music := $TitleMusic

# Called when the node enters the scene tree for the first time.
func _ready():
	var disc_integration = DiscordIntegration.new()
	disc_integration.run()
	
	var rng = RandomNumberGenerator.new()
	var random_float = rng.randf()
	if random_float < 0.44:
		splash_screen.stream.file = "res://UI/Screens/Title/Assets/NFTL-Splash-v3.ogv"
		splash_screen.play()
	elif random_float < 0.88:
		splash_screen.stream.file = "res://UI/Screens/Title/Assets/NFTL-Splash-v4.ogv"
		splash_screen.play()
	else:
		splash_screen.visible = false
		bg.visible = true
	random_float = rng.randf()
	if random_float < 0.33:
		title_music.stream = load("res://UI/Screens/Title/Assets/Interplanetary.mp3")
	elif random_float < 0.66:
		title_music.stream = load("res://UI/Screens/Title/Assets/Heartbeat of a Star.mp3")
	else:
		title_music.stream = load("res://UI/Screens/Title/Assets/Arriving Fleet.mp3")
	title_music.play()	
	var tween = get_tree().create_tween()
	tween.tween_property(title_music, "volume_db", -20, 3)

func _on_settings_pressed():
	settings.visible = true
