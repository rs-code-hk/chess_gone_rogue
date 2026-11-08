extends Button


# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")


func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
