extends Control

#refrences to ui elements
@onready var label: Label = $timer_display

#stopwatch states
var time_elapsed: float = 0.0
var is_running: bool = false

func _ready() -> void:
	start() # This kicks off the timer immediately


func _process(delta: float) -> void:
	if is_running:
		time_elapsed += delta
		update_ui()

func update_ui() -> void:
	var minutes: int = int(time_elapsed / 60)
	var secounds: int = int(time_elapsed) % 60
	var millisecounds: int = int(fmod(time_elapsed, 1.0 ) * 100 )
	label.text = "%02d:%02d:%02d" % [minutes, secounds, millisecounds]
	
func start() -> void:
	is_running = true

func stop() -> void:
	is_running = false
	
func reset() -> void:
	time_elapsed = 0.0
	update_ui()
