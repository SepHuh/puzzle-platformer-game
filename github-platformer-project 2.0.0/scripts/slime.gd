extends CharacterBody2D

const SPEED = 60
var direction = -1

@onready var raycast_right = $"Raycast Right"
@onready var raycast_left = $"Raycast Left"

@onready var animated_sprite = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	position.x += direction * SPEED * delta
	
	if raycast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if raycast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	
	
	move_and_slide()
