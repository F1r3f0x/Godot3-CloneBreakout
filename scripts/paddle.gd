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
