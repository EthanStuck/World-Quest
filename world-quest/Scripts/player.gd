extends CharacterBody2D
@export var speed = 75
var screen_size = Vector2(1000,1000)


var foot_step = false
# testing github commit changes

func _ready():
	''' player startup '''
	#screen_size = get_viewport_rect().size
	$Animations.play()
	$GameMusic.play()
	
func _process(delta):
	''' continuous processes '''
	move(delta)
	$Animations.z_index = position.y + 35
	if Input.is_action_just_pressed('strike'):
		strike(delta)


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
		if not Input.is_action_pressed('strike'):
			$Animations.animation = 'walk_side'
	elif Input.is_action_pressed('move_left'):
		velocity.x = -1
		if not Input.is_action_pressed('strike'):
			$Animations.animation = 'walk_side'
	else:
		velocity.x = 0
	
	# normalize movement
	if velocity.length() > 0:
		$Animations.play()
		velocity = velocity.normalized() * speed
		foot_step_sound()
		
	
	else:
		#$Animations.animation = 'idle'
		$Animations.stop()
	
	# update position and control animation direction
	$Animations.flip_h = velocity.x < 0
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# control collisions
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.slide(collision.get_normal())

func strike(delta):
	if velocity.x >= 0:
		$Animations.animation = 'strike_right'
	else:
		$Animations.animation = 'strike_left'
	$HitBox/HitBoxShape.disabled = false
	await get_tree().create_timer(.25).timeout
	$HitBox/HitBoxShape.disabled = true
	$Animations.animation = 'idle'
		

func foot_step_sound():
	''' make foot step sounds when walking '''
	if not foot_step:
		$FootStep.play()
		# make sound slightly less repetitive
		$FootStep.pitch_scale = randf_range(.95, 1.05)
		foot_step = true
		await get_tree().create_timer(.55).timeout
		foot_step = false



#func _on_hurt_box_area_entered(area: Area2D) -> void:
	#queue_free()
