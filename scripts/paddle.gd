extends Area2D


export var SPEED = 1000
export var BallRef: NodePath
onready var halfsize_x = round($Sprite.get_rect().size.x / 2)
onready var ball: KinematicBody2D = get_node(BallRef)


func _ready():
	pass


func _physics_process(delta):
	if Input.is_action_pressed("paddle_move_left"):
		position.x -= SPEED * delta
	if Input.is_action_pressed("paddle_move_right"):
		position.x += SPEED * delta
	position.x = clamp(position.x, 0 + halfsize_x, 1024 - halfsize_x)


func _on_Paddle_body_entered(body: PhysicsBody2D):
	
	body.paddle_bounce(position)
	
#
#	body.bounced = true
#	body.direction.y *= -1
#
#	# Corner handling
#	var diff_vector = body.position - position
#	var normal_diff_vector = diff_vector.normalized()
#	var abs_diff_x = abs(normal_diff_vector.x)
#	if abs_diff_x >= 0.95:
#		if normal_diff_vector.x >= 0:
#			body.direction.x = 1
#		else:
#			body.direction.x = -1

