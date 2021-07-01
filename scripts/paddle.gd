extends KinematicBody2D

export var SPEED = 1000

func _ready():
	pass

func _physics_process(delta):

	if Input.is_action_pressed("paddle_move_left"):
		position.x -= SPEED * delta
	if Input.is_action_pressed("paddle_move_right"):
		position.x += SPEED * delta
