extends CharacterBody2D

@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight

const SPEED = 100.0
const FRICTION:float = 0.03
const JUMP_VELOCITY = -200.0
const WALLJUMP_DELAY = 10
const DASH_DURATION = 15
const DASH_VELOCITY = 175
const TOTAL_DASH_DELAY = 20

var jumps = 2
var walljumping = 0
var dashing = false
var dashFrames = 0
var dashingDirection = Vector2(0, 0)
var lastHorizontalDirection = 1
var canDash = true
var dashDelay = 0

func getInputs() -> Vector2:
	return Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))

func _physics_process(delta: float) -> void:
	# Get movement
	var direction = getInputs()
	if direction.x != 0:
		lastHorizontalDirection = direction.x
	if dashing == false and canDash:
		dashing = Input.is_action_just_pressed("dash")
		if direction == Vector2(0, 0):
			dashingDirection = Vector2(lastHorizontalDirection, 0)
		
		else:
			dashingDirection = direction
			
		if dashing:
			canDash = false
			dashFrames = DASH_DURATION
			
	if dashFrames == 0:
		dashing = false

	walljumping -= 1
	dashFrames -= 1
	dashDelay -= 1
	
	# Get Jump Count
	if is_on_wall():
		jumps = 1
		if dashDelay < 1: canDash = true
	
	if is_on_floor():
		jumps = 2
		if dashDelay < 1: canDash = true
		
	if dashing:
		velocity = Vector2(dashingDirection.x * DASH_VELOCITY, dashingDirection.y * DASH_VELOCITY)
		if dashFrames == 0:
			velocity = Vector2(0, 0)
			dashDelay = TOTAL_DASH_DELAY
		
	else:
	# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and jumps > 0:
			velocity.y = JUMP_VELOCITY
			jumps -= 1
			if not is_on_floor() and is_on_wall():
				walljumping = WALLJUMP_DELAY
				jumps = 1
				if ray_cast_left.is_colliding():
					velocity.x += SPEED
				if ray_cast_right.is_colliding():
					velocity.x += -SPEED
					
		if direction.x != 0 and walljumping < 1:
			velocity.x = direction[0] * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED * FRICTION)

	move_and_slide()
