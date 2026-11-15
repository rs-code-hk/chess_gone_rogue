extends Button

var levelRestart = ""
func setRestart(level):
	levelRestart = "res://Scenes/level_" + level + ".tscn"

func _ready() -> void:
	EventBus.levelRestart.connect(setRestart)


func _on_pressed() -> void:
	get_tree().quit()
	


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")


func _on_quick_restart_pressed() -> void:
	get_tree().change_scene_to_file(levelRestart)
