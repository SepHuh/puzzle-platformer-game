extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -300
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var isJumping = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if !is_on_floor():
		velocity += get_gravity() * delta
		
	if is_on_floor():
		isJumping = false

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	# Puts player in the right direction
	if direction < 0:
		animated_sprite.flip_h = true
	elif direction > 0:
		animated_sprite.flip_h = false
		
	# Plays the right animation
	if (isJumping):
		animated_sprite.play("jump")
	else:
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("walk")

	move_and_slide()
	
func jump():
	velocity.y = JUMP_VELOCITY
	isJumping = true
