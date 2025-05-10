extends CharacterBody2D

var direction = 1

@onready var raycast_right = $"Raycast Right"
@onready var raycast_left = $"Raycast Left"

@onready var animated_sprite = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()
