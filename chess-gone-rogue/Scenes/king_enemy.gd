extends Node2D
 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	while true:
		var range_int_x = randi_range(-1, 1)
		var range_int_y = randi_range(-1, 1)
		#moving it by 16 pixals in any direction moves it on spuare that way
		await get_tree().create_timer(0.5).timeout
		var x_movment = range_int_x * 16
		var y_movment = range_int_y * 16
		print("test")
		
		if position.x == 56 and not position.y == 55:
			move_local_y(y_movment)	
			
		move_local_x(x_movment)
			
		
		
		print("test2")
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
