extends Control

#refrences to ui elements
@onready var label: Label = $Label

#stopwatch states
var time_elapsed: float = 0.0
var is_running: bool = false

func _process(delta: float) -> void:
	if is_running:
		time_elapsed += delta
		update_ui()

func update_ui() -> void:
	var minutes: int = int(time_elapsed / 60)
	var secounds: int = int(time_elapsed) % 60
	var millisecounds: int = int(time_elapsed - int(time_elapsed))
	label.text = "%02d:%02d:%02d" % [minutes, secounds, millisecounds]
	
func start_stopwatch() -> void
	is_running = true
