extends Node2D



signal enemy_hit(enemy)

@export var piece = 1
var chessPosition = Vector2(4, 7)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if piece == 1:
		EventBus.hit_enemy.connect(tryDelete)
		await get_tree().create_timer(3.0).timeout
		while true:
			var range_int_x = randi_range(-1, 1)
			var range_int_y = randi_range(-1, 1)
			
			var simPosition = chessPosition
			simPosition.x += range_int_x
			simPosition.y += range_int_y
			
			if int(simPosition.x) not in Array(range(0, 8)):
				continue
				
			if int(simPosition.y) not in Array(range(0, 8)):
				continue
				
			#moving it by 16 pixals in any direction moves it on spuare that way
			
			position.x = simPosition.x * 16 - 56
			position.y = simPosition.y * 16 - 56
			chessPosition = simPosition
			await get_tree().create_timer(3.0).timeout
	elif piece == 2:
		while true:
			var x_or_y = randf()
			if x_or_y > 0.5:
				var how_many_squaresx = randi_range(-8, 8)
				print("move x")
			elif x_or_y < 0.5:
				var how_many_squaresy = randi_range(-8, 8)
				print("move y")
			await get_tree().create_timer(4).timeout
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func tryDelete(inEnemy) -> void:
	if get_node("./hit box") == inEnemy:
		EventBus.enemyDied.emit()
		queue_free()
