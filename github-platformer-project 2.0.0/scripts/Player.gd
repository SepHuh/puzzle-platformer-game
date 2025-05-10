extends CharacterBody2D

const SPEED = 120
const JUMP_VELOCITY = -350
var push_force = 20

@onready var coyote_timer = $"Coyote Timer"
var was_on_floor = false

@onready var jump_timer = $"Jump Buffer Timer"
var jump_pressed = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	
	was_on_floor = is_on_floor()
	
	# Add the gravity.
	if !is_on_floor():
		velocity.y += gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		jump_pressed = true
		jump_timer.start()
	if (is_on_floor() or !coyote_timer.is_stopped()) and jump_pressed:
		jump()
		was_on_floor = false
		
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
		
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
	if (is_on_floor() or !coyote_timer.is_stopped()) and jump_pressed:
		animated_sprite.play("jump")
	elif is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("walk")
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
	
	if was_on_floor and !is_on_floor():
		coyote_timer.start()
		
func jump():
	velocity.y = JUMP_VELOCITY
	
func _on_jump_buffer_timer_timeout():
	jump_pressed = false
