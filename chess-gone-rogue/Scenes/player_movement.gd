extends CharacterBody2D

@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight

const SPEED = 100.0
const FRICTION:float = 0.03
const JUMP_VELOCITY = -200.0

var jumps = 2
var walljumping = 0

func _physics_process(delta: float) -> void:
	walljumping -= 1
	
	# Get Jump Count
	if is_on_floor():
		jumps = 2
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and jumps > 0:
		velocity.y = JUMP_VELOCITY
		jumps -= 1
		if not is_on_floor() and is_on_ceiling():
			walljumping = 10
			if ray_cast_left.is_colliding():
				velocity.x += SPEED
			if ray_cast_right.is_colliding():
				velocity.x += -SPEED

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction and walljumping < 1:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * FRICTION)

	move_and_slide()
