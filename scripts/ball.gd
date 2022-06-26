extends KinematicBody2D

export var SPEED = 500
export var direction: Vector2
var velocity: Vector2

onready var max_x = get_viewport_rect().size.x
onready var max_y = get_viewport_rect().size.y

onready var ball_rect = $Sprite.get_rect().size
onready var ball_midsize_x = ball_rect.x/2
onready var ball_midsize_y = ball_rect.y/2

func _ready():
	pass


func bounce(normal: Vector2):
	velocity = velocity.bounce(normal)
	direction = velocity.normalized()

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

			# This will remove the tile
			brickMap.set_cellv(tile_pos, -1)
		
		bounce(collision.normal)

