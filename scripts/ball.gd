extends KinematicBody2D

export var SPEED = 500

var direction = Vector2(0.4,-1)
var velocity: Vector2

onready var max_x = get_viewport_rect().size.x
onready var max_y = get_viewport_rect().size.y

onready var ball_rect = $Sprite.get_rect().size
onready var ball_midsize_x = ball_rect.x/2
onready var ball_midsize_y = ball_rect.y/2

func _ready():
	pass


func _physics_process(delta):
	# Calculate ball movement
	velocity = SPEED * direction
	var collision = move_and_collide(velocity * delta)
	
	# Restrict ball to the playfield
	position.x = clamp(position.x, 0, max_x)
	position.y = clamp(position.y, 0, max_y)
	
	# Walls collision
	if (direction.y >= 0 and position.y >= (max_y - ball_midsize_y)) or (direction.y < 0 and position.y <= (0 + ball_midsize_y)):
		direction.y *= -1
	if (direction.x >= 0 and position.x >= (max_x - ball_midsize_x)) or (direction.x < 0 and position.x <= (0 + ball_midsize_x)):
		direction.x *= -1
	
	# Check collisions with objects
	if collision:
		velocity = velocity.bounce(collision.normal)
		direction = velocity.normalized()


