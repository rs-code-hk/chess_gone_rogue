extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.hit_enemy.connect(getHit)
	
func getHit() -> void:
	print("Enemy hit")
