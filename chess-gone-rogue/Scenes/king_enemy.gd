extends Node2D



@onready var sprite: Sprite2D = $"Sprite2D"
@export var piece = 1
@export var chessPosition = Vector2(4, 7)
var paused = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.hit_enemy.connect(tryDelete)
	EventBus.pause.connect(setPaused)
	await get_tree().create_timer(randf()).timeout
	if piece == 1:
		sprite.texture = load("res://Assets/Pieces/King.png")
		while true:
			await get_tree().create_timer(2.0).timeout
			if paused == false:
				while true:
					var range_int_x = randi_range(-1, 1)
					var range_int_y = randi_range(-1, 1)
					
					var simPosition = chessPosition
					simPosition.x += range_int_x
					simPosition.y += range_int_y
					
					if int(simPosition.x) in range(8) and int(simPosition.y) in range(8):
						position.x = simPosition.x * 16 - 56
						position.y = simPosition.y * 16 - 56
						chessPosition = simPosition
						break
			
	elif piece == 2:
		sprite.texture = load("res://Assets/Pieces/Rook.png")
		while true:
			await get_tree().create_timer(2).timeout
			if paused == false:
				var simPosition = chessPosition
				var x_or_y = randi() % 2
				var square = randi_range(0, 8)
				if x_or_y == 0:
					simPosition.x = square
				elif x_or_y == 1:
					simPosition.y = square
				
				position = Vector2(simPosition.x * 16 - 56, simPosition.y * 16 - 56)
				chessPosition = simPosition
					
			
	elif piece == 3:
		sprite.texture = load("res://Assets/Pieces/Pawn.png")
		while true:
			await get_tree().create_timer(2).timeout	
			if paused == false:
				if chessPosition.y != 0:
					position.y += 16
					chessPosition.y -= 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func tryDelete(inEnemy) -> void:
	if get_node("./hit box") == inEnemy:
		EventBus.enemyDied.emit()
		queue_free()
		
func setPaused() -> void:
	paused = !paused
