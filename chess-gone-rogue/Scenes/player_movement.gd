extends CharacterBody2D

@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_down: RayCast2D = $RayCastDown
@onready var ray_cast_up: RayCast2D = $RayCastUp
@onready var attack_left: RayCast2D = $AttackLeft
@onready var attack_right: RayCast2D = $AttackRight
@onready var attack_down: RayCast2D = $AttackDown
@onready var attack_up: RayCast2D = $AttackUp
@onready var texture: AnimatedSprite2D = $AnimatedSprite2D
@onready var slash: Sprite2D = $Slash

signal enemyDied

const SPEED = 100.0
# Increase for less slide, decrease for more
const FRICTION:float = 0.05
const AIR_FRICTION = 0.02
const GRAVITY = 0.02
const JUMP_VELOCITY = -200.0
const WALLJUMP_DELAY = 10
const DASH_DURATION = 15
const DASH_VELOCITY = 175
const TOTAL_DASH_DELAY = 20
const MAX_I_FRAMES = 50
const KING_PATH = "../king enemy/hit box"
const SLASH_DURATION = 20
const SLASH_DELAY = 20
const SLASH_LENGTH = 7
const KNOCKBACK = 50
const FREEZE_TOTAL = 10
const POGO_BOOST = -300

var jumps = 2
var walljumping = 0
var dashing = false
var dashFrames = 0
var lastDirection = Vector2(0, 0)
var lastHorizontalDirection = 1
var canDash = true
var dashDelay = 0
var iFrames = 0
var health = 3
var enemiesLeft = 1
var slashFrames = 0
var slashDirection = Vector2(0, 0)
var noControl = 0

func reduceEnemy() -> void:
	enemiesLeft -= 1
	if enemiesLeft == 0:
		get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")

func _ready() -> void:
	EventBus.enemyDied.connect(reduceEnemy)
	slash.hide()

func getInputs() -> Vector2:
	return Vector2(Input.get_axis("a", "d"), Input.get_axis("w", "s"))

func checkHit():
	var isHit = false
	if enemiesLeft > 0:
		if ray_cast_down.get_collider() == get_node(KING_PATH):
			isHit = true
		if ray_cast_up.get_collider() == get_node(KING_PATH):
			isHit = true
		if ray_cast_left.get_collider() == get_node(KING_PATH):
			velocity.x += KNOCKBACK
			isHit = true
		if ray_cast_right.get_collider() == get_node(KING_PATH):
			velocity.x += -KNOCKBACK
			isHit = true
			
	if isHit:
		noControl = FREEZE_TOTAL
	
	return isHit

func checkHitting(direction:Vector2):
	var collider = null
	if direction.y == -1:
		collider = attack_up.get_collider()
	elif direction.y == 1:
		collider = attack_down
		print(collider)
		if collider not in [get_node(""), get_node("../bottom boundary"), get_node("./AttackDown")]:
			velocity.y += POGO_BOOST
			jumps = 1
			canDash = true
	else:
		if direction.x == -1:
			collider = attack_left.get_collider()
		if direction.x == 1:
			collider = attack_right.get_collider()
			
	if slashFrames > 0:
		slash.show()
		if enemiesLeft > 0:
			if collider:
				EventBus.hit_enemy.emit(collider)
				
	else:
		slash.hide()

func attack(direction:Vector2) -> Vector2:
	slashFrames = SLASH_DURATION
	var slashDirection = direction
	if direction == Vector2(0, 0):
			slashDirection = lastDirection
			
	if slashDirection.y != 0:
		slash.flip_h = false
		slash.rotation_degrees = [null, 90, 270][slashDirection.y]
		slash.position.x = 0
		slash.position.y = SLASH_LENGTH * slashDirection.y
	else:
		slash.rotation_degrees = 0
		slash.flip_h = [null, false, true][slashDirection.x]
		slash.position.x = SLASH_LENGTH * slashDirection.x
		slash.position.y = 0
		
	return slashDirection
		
func _physics_process(delta: float) -> void:
	# Get temporary variables
	var hit = checkHit()
	var direction = getInputs()
	
	# Reduce timers
	walljumping -= 1
	dashFrames -= 1
	dashDelay -= 1
	iFrames -= 1
	slashFrames -= 1
	noControl -= 1
	
	# Check getting hit
	if enemiesLeft > 0:
		if hit:
			if iFrames <= 0:
				iFrames = MAX_I_FRAMES
				health -= 1
				if health == 0:
					get_tree().reload_current_scene()
	
	# Get movement
	texture.flip_h = false if direction.x == 1 else true if direction.x == -1 else texture.flip_h
	
	if direction.x != 0:
		lastHorizontalDirection = direction.x
	if dashing == false and canDash:
		dashing = Input.is_action_just_pressed("dash")
		if direction == Vector2(0, 0):
			lastDirection = Vector2(lastHorizontalDirection, 0)
		
		else:
			lastDirection = direction
			
		if dashing:
			canDash = false
			dashFrames = DASH_DURATION
			
	if dashFrames == 0:
		dashing = false
	
	# Get Jump Count
	if is_on_wall():
		jumps = 1
		if dashDelay < 1: canDash = true
	
	if is_on_floor():
		jumps = 2
		if dashDelay < 1: canDash = true
		
	if dashing:
		velocity = Vector2(lastDirection.x * DASH_VELOCITY, lastDirection.y * DASH_VELOCITY)
		if dashFrames == 0:
			velocity = Vector2(0, 0)
			dashDelay = TOTAL_DASH_DELAY
		
	else:
	# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * GRAVITY

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
					
		if direction.x != 0 and walljumping < 1 and noControl < 1:
			velocity.x = direction[0] * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED * (FRICTION if is_on_floor() else AIR_FRICTION))
	
	# Attacking
	var slashDirection = Vector2(0, 0)
	if Input.is_action_pressed("attack") and slashFrames < -SLASH_DELAY:
		slashDirection = attack(direction)
	checkHitting(slashDirection)

	move_and_slide()
