extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


func toggle_menu():
	#show/hide menu
	visible = !visible
	#pause/unpause game
	get_tree().paused = visible
	EventBus.emit_signal("pause")
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		toggle_menu()
		
	
	



func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	




func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
	
