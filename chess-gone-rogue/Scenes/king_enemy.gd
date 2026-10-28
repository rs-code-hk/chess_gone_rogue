extends Node2D
 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	while true:
		var range_int_x = randi_range(-1, 1)
		var range_int_y = randi_range(-1, 1)
		#moving it by 16 pixals in any direction moves it on spuare that way
		
		var x_movment = range_int_x * 16
		var y_movment = range_int_y * 16
		var final_postion_x = x_movment + position.x
		var final_postion_y = y_movment + position.y
		var did_move = false
		if final_postion_x > -72 and final_postion_x < 72:
			move_local_x(x_movment) 
			did_move = true
		if final_postion_y > -73 and final_postion_y < 71:
			move_local_y(y_movment) 
			did_move = true
		if did_move == true:
			await get_tree().create_timer(3).timeout
			
	
		
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
