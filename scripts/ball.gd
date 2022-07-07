extends KinematicBody2D


export var SPEED := 500
export var direction: Vector2


onready var AudioNode = $Audio
onready var max_x := get_viewport_rect().size.x
onready var max_y := get_viewport_rect().size.y

onready var ball_rect: Vector2 = $Sprite.get_rect().size
onready var ball_midsize_x = ball_rect.x/2
onready var ball_midsize_y = ball_rect.y/2

onready var bounced = false


var velocity: Vector2


func _ready():
	pass


func bounce(normal: Vector2):
	velocity = velocity.bounce(normal)
	direction = velocity.normalized()

	bounced = true


func paddle_bounce(paddle_pos: Vector2):
	bounced = true
	direction.y *= -1

	# Corner handling
	var diff_vector = position - paddle_pos
	var normal_diff_vector = diff_vector.normalized()
	var abs_diff_x = abs(normal_diff_vector.x)
	if abs_diff_x >= 0.85:
		if normal_diff_vector.x >= 0:
			direction.x = 1
		else:
			direction.x = -1


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
		bounced = true
	if (direction.x >= 0 and position.x >= (max_x - ball_midsize_x)) or (direction.x < 0 and position.x <= (0 + ball_midsize_x)):
		direction.x *= -1
		bounced = true

	# Check collisions with objects
	if collision:
		# Did we hit a brick
		if collision.collider is TileMap:
			var brickMap: TileMap = collision.collider
			var tile_pos = brickMap.world_to_map(position)

			# If any normal component is different than 0 we know the tile is that way
			if collision.normal.y > 0:
				tile_pos.y -= 1
			if collision.normal.y < 0:
				tile_pos.y += 1
			if collision.normal.x > 0:
				tile_pos.x -= 1
			if collision.normal.x < 0:
				tile_pos.x += 1

			brickMap.set_cellv(tile_pos, -1)  # This will remove the tile

		bounce(collision.normal)

	if bounced:
		# Audio
		AudioNode.play()
		AudioNode.pitch_scale = rand_range(0.8, 1.2)  # Randomize pitch to avoid anoying the player

		bounced = false
