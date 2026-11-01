extends Button



func _on_pressed() -> void:
	get_tree().exit()
	


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")



func _on_quick_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
