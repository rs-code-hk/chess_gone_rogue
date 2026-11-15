extends Node2D



@onready var sprite: Sprite2D = $"Sprite2D"
@export var piece = 1
@export var chessPosition = Vector2(4, 7)
var paused = false
# Called when the node enters the scene tree for the first time.
func playMove() -> void:
	match piece:
		1:
			while true:
				var range_int_x = randi_range(-1, 1)
				var range_int_y = randi_range(-1, 1)
				
				var simPosition = chessPosition
				simPosition.x += range_int_x
				simPosition.y += range_int_y
				
				if validPosition(simPosition):
					goToPosition(simPosition)
					chessPosition = simPosition
					break
			
		2:
			var simPosition = chessPosition
			var x_or_y = randi() % 2
			var square = randi_range(0, 8)
			if x_or_y == 0:
				simPosition.x = square
			elif x_or_y == 1:
				simPosition.y = square
			
			goToPosition(simPosition)
			chessPosition = simPosition
					
			
		3:
			while true:
				var direction = Vector2(randi_range(-1, 1), randi_range(-1, 1))
				if direction == Vector2(0, 0):
					continue
				var distance = randi_range(-7, 7)
				var simPosition = chessPosition
				simPosition.x += direction.x * distance
				simPosition.y += direction.y * distance
				
				if validPosition(simPosition):
					goToPosition(simPosition)
					chessPosition = simPosition
					break
					
		4:
			while true:
				var direction = Vector2(0, 0)
				direction.x = [-1, 1][randi() % 2]
				direction.y = [-1, 1][randi() % 2]
				
				var simPosition = chessPosition
				var length = randi_range(-7, 7)
				simPosition.x += length * direction.x
				simPosition.y += length * direction.y
				if validPosition(simPosition):
					goToPosition(simPosition)
					chessPosition = simPosition
					break
		5:
			while true:
				var squaresUp = [-2, -1, 1, 2][randi_range(0, 3)]
				var squaresRight = [null, 2, 1][abs(squaresUp)] * [-1, 1][randi_range(0, 1)]
				var simPosition = chessPosition
				simPosition.x += squaresRight
				simPosition.y += squaresUp
				
				if validPosition(simPosition):
					goToPosition(simPosition)
					chessPosition = simPosition
					break
		
		6:
			if chessPosition.y != 7:
				chessPosition.y += 1
				goToPosition(chessPosition)
			else:
				piece = randi_range(1, 5)
				loadPiece()

func loadPiece() -> void:
	var texture = "res://Assets/Pieces/"
	match piece:
		1: texture += "King.png"
		2: texture += "Rook.png"
		3: texture += "Queen.png"
		4: texture += "Bishop.png"
		5: texture += "Knight.png"
		6: texture += "Pawn.png"
	sprite.texture = load(texture)
	
func goToPosition(chessPos:Vector2) -> void:
	position.x = chessPos.x * 16 - 56
	position.y = chessPos.y * 16 - 56
	
func validPosition(chessPos:Vector2) -> bool:
	if int(chessPos.x) in range(8) and int(chessPos.y) in range(8):
		return true
	
	return false

func _ready() -> void:
	EventBus.hit_enemy.connect(tryDelete)
	EventBus.pause.connect(setPaused)
	loadPiece()
	goToPosition(chessPosition)
	await get_tree().create_timer(randf()).timeout
	while true:
		await get_tree().create_timer(2).timeout
		if paused == false:
			playMove()

func _process(_delta: float) -> void:
	pass
	
func tryDelete(inEnemy) -> void:
	if get_node("./hit box") == inEnemy:
		EventBus.enemyDied.emit()
		queue_free()
		
func setPaused() -> void:
	paused = !paused
