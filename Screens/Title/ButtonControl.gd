extends VBoxContainer




func _on_start_pressed():
	var main_scene = preload("res://Map/base.tscn")
	get_tree().current_scene.queue_free()
	var instances_scene := main_scene.instantiate()
	get_tree().root.add_child(instances_scene)
	get_tree().current_scene = instances_scene
	# previous lines are doing this: 
	# get_tree().change_scene_to_file("res://Map/base.tscn")	
	
	Start4.generate_universe()
	Starmap.startup()	


func _on_settings_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	pass # Replace with function body.
