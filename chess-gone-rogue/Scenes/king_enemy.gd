extends Node2D

signal enemy_hit(enemy)

var chessPosition = Vector2(4, 7)
 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.hit_enemy.connect(tryDelete)
	await get_tree().create_timer(3.0).timeout
	while true:
		var range_int_x = randi_range(-1, 1)
		var range_int_y = randi_range(-1, 1)
		
		var simPosition = chessPosition
		simPosition.x += range_int_x
		simPosition.y += range_int_y
		
		if int(simPosition.x) not in Array(range(0, 8)):
			print("running X")
			continue
			
		if int(simPosition.y) not in Array(range(0, 8)):
			print("running Y")
			continue
			
		#moving it by 16 pixals in any direction moves it on spuare that way
		
		position.x = simPosition.x * 16 - 56
		position.y = simPosition.y * 16 - 56
		chessPosition = simPosition
		await get_tree().create_timer(3.0).timeout


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func tryDelete(inEnemy) -> void:
	if get_node("./hit box") == inEnemy:
		queue_free()
