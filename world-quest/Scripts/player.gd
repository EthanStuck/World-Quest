extends CharacterBody2D
@export var speed = 100
var screen_size

# testing github commit changes

func _ready():
	''' player startup '''
	screen_size = get_viewport_rect().size
	$Animations.play()
	
func _process(delta):
	''' continuous processes '''
	move(delta)


func move(delta):
	''' controls player movement '''
	
	# player movement y direction
	if Input.is_action_pressed('move_down'):
		velocity.y = 1
		$Animations.animation = 'walk_front'
	elif Input.is_action_pressed('move_up'):
		velocity.y = -1
		$Animations.animation = 'walk_back'
	else:
		velocity.y = 0
	
	# player movement x direction
	if Input.is_action_pressed('move_right'):
		velocity.x = 1
		$Animations.animation = 'walk_side'
	elif Input.is_action_pressed('move_left'):
		velocity.x = -1
		$Animations.animation = 'walk_side'
	else:
		velocity.x = 0
	
	# normalize movement
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	else:
		$Animations.animation = 'idle'
	
	# update position and control animation direction
	$Animations.flip_h = velocity.x < 0
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# control collisions
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.slide(collision.get_normal())
