extends Node


var final_time: float = 0.0
var final_hp : int = 0

func save_grade_result (time: float, hp: int):
	final_time = time
	final_hp = hp
	get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")
