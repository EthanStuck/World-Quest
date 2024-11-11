extends CharacterBody2D
class_name Player

signal health_update

@export var speed = 75
var screen_size = Vector2(1000,1000)

@export var inv: Inv

@export var maxHealth = 300
@export var currentHealth: int = maxHealth

var dead = false
var water_range = false
var weed_range = false
var interacting = false
var facing = 'right'
var colliding_pos : Vector2
var foot_step = false
var carrying = false
var pickup_range = false
var foot_timer = 0.55
signal place



# setup for screenshake (from tutorial)
@export var shake_decay_rate : float = 5.0
@export var noise_shake_speed : float = 30.0
@export var noise_shake_strength : float = 60.0
@onready var noise = FastNoiseLite.new()
var noise_i : float = 0.0
var shake_strength = 0.0


func _ready():
	''' player startup '''
	#screen_size = get_viewport_rect().size
	$Death/Death_message.hide()
	$Animations.play()
	
	
func _process(delta: float):
	''' continuous processes '''
	if not dead:
		$Animations.z_index = position.y + 44
		if Input.is_action_just_pressed('strike'):
			strike(delta)
		if Input.is_action_just_pressed('interact'):
			if not carrying:
				if weed_range:
					deweed(delta)
				elif water_range:
					water()
				elif pickup_range:
					carry()
			elif carrying:
				uncarry()
		if Input.is_action_just_pressed('cast'):
			cast(delta)
		else:
			move(delta)
	
	# camera shake stuff
	shake_strength = lerp(shake_strength, 0.0, shake_decay_rate * delta)
	$Camera2D.offset = get_noise_offset(delta, noise_shake_speed, shake_strength)


func move(delta):
	''' controls player movement '''
	
	# player movement y direction
	if not interacting:
		if Input.is_action_pressed('move_down'):
			velocity.y = 1
			if not Input.is_action_pressed('move_right') and not Input.is_action_pressed('move_left') and not carrying:
				$Animations.animation = 'walk_front'
			elif not Input.is_action_pressed('move_right') and not Input.is_action_pressed('move_left') and carrying:
				$Animations.animation = 'carry_right'
				if $Animations.frame == 1:
					apply_shake()
		elif Input.is_action_pressed('move_up'):
			velocity.y = -1
			if not Input.is_action_pressed('move_right') and not Input.is_action_pressed('move_left') and not carrying:
				$Animations.animation = 'walk_back'
			elif not Input.is_action_pressed('move_right') and not Input.is_action_pressed('move_left') and carrying:
				$Animations.animation = 'carry_left'
				if $Animations.frame == 1:
					apply_shake()
		else:
			velocity.y = 0
		
		# player movement x direction
		if Input.is_action_pressed('move_right'):
			velocity.x = 1
			facing = 'right'
			if not Input.is_action_pressed('strike') and not carrying:
				$Animations.animation = 'walk_right'
			elif not Input.is_action_pressed('strike') and carrying:
				$Animations.animation = 'carry_right'
				if $Animations.frame == 1:
					apply_shake()
		elif Input.is_action_pressed('move_left'):
			velocity.x = -1
			facing = 'left'
			if not Input.is_action_pressed('strike') and not carrying:
				$Animations.animation = 'walk_left'
			elif not Input.is_action_pressed('strike') and carrying:
				$Animations.animation = 'carry_left'
				if $Animations.frame == 1:
					apply_shake()
		else:
			velocity.x = 0
	else:
		velocity.y = 0
		velocity.x = 0
	
	# normalize movement
	if velocity.length() > 0:
		$Animations.play()
		velocity = velocity.normalized() * speed
		foot_step_sound()
		
	
	else:
		#$Animations.animation = 'idle'
		if not interacting:
			$Animations.stop()

	
	# update position and control animation direction
	#$Animations.flip_h = velocity.x < 0
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# control collisions
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.slide(collision.get_normal())

func strike(delta):
	if FragmentHandler.sword_pickup and not carrying and not interacting:
		$StrikeSound.play()
		if velocity.x >= 0:
			$Animations.animation = 'strike_right'
			$HitBox/HitBoxShape.disabled = false
			await get_tree().create_timer(.25).timeout
			$HitBox/HitBoxShape.disabled = true
			$Animations.animation = 'walk_right'
		else:
			#$Animations.flip_h = velocity.x < 0
			$Animations.animation = 'strike_left'
			$HitBox/HitBoxShape.disabled = false
			await get_tree().create_timer(.25).timeout
			$HitBox/HitBoxShape.disabled = true
			$Animations.animation = 'walk_left'

func foot_step_sound():
	''' make foot step sounds when walking '''
	if not foot_step:
		$FootStep.play()
		# make sound slightly less repetitive
		$FootStep.pitch_scale = randf_range(.95, 1.05)
		foot_step = true
		await get_tree().create_timer(foot_timer).timeout
		foot_step = false

func player():
	pass
func collect(item):
	inv.insert(item)

func get_noise_offset(delta: float, speed: float, strength: float) -> Vector2:
	''' used for camera shake, gotten from youtube tutorial '''
	noise_i += delta * speed
	# Set the x values of each call to 'get_noise_2d' to a different value
	# so that our x and y vectors will be reading from unrelated areas of noise
	return Vector2(
		noise.get_noise_2d(1, noise_i) * strength,
		noise.get_noise_2d(100, noise_i) * strength
	)

func apply_shake():
	''' activate camera shake (from tutorial) '''
	shake_strength = noise_shake_strength

func deweed(delta):
	''' remove weeds from plant '''
	interacting = true # used to disable other animations/actions
	
	# knockdirection found taking difference from player position and object position
	var knockback_direction = (global_position - colliding_pos + Vector2(0, 44) - Vector2(0, 30)).normalized()
	var prev_anim = $Animations.animation
	if facing == 'right':
		$Animations.play('deweed_right')
		await get_tree().create_timer(2).timeout
		apply_shake()
		position += knockback_direction * 20
	elif facing == 'left':
		$Animations.play('deweed_left')
		await get_tree().create_timer(2).timeout
		apply_shake()
		position += knockback_direction * 20
	await get_tree().create_timer(.25).timeout
	$Animations.play(prev_anim)
	weed_range = false
	interacting = false

func cast(delta):
	interacting = true
	if $Animations.animation != 'cast':
		$Animations.play('cast_up')
		await get_tree().create_timer(2).timeout
		interacting = false
	
func water():
	''' water plants '''
	if FragmentHandler.bucket_collected:
		interacting = true
		var prev_anim = $Animations.animation
		$Animations.stop()
		if facing == 'right':
			$Animations.play('water_right')
		elif facing == 'left':
			$Animations.play('water_left')
		await get_tree().create_timer(1).timeout
		$Animations.play(prev_anim)
		water_range = false
		interacting = false
	
func carry():
	carrying = true
	speed = 15
	foot_timer = 3 + 2/3
	if facing == 'right':
		$Animations.play('carry_right')
	else:
		$Animations.play('carry_left')


func uncarry():
	carrying = false
	speed = 75
	foot_timer = .55
	$Animations.play('idle')
	if facing == 'right':
		place.emit(position + Vector2(50,15))
	elif facing == 'left':
		place.emit(position + Vector2(-50,15))

func _on_interact_area_area_entered(area: Area2D) -> void:
	''' check to see what interaction zone player entered, 
		change state accordingly '''
	if area.is_in_group('dead_plant'):
		water_range = true
	if area.is_in_group('weed'):
		weed_range = true
	if area.is_in_group('pumpkin'):
		pickup_range = true
	colliding_pos = area.global_position
		
func _on_interact_area_area_exited(area: Area2D) -> void:
	''' disable state change when interaction zone left '''
	if area.is_in_group('dead_plant'):
		water_range = false
	if area.is_in_group('weed'):
		weed_range = false
	if area.is_in_group('pumpkin'):
		pickup_range = false
	colliding_pos = Vector2.ZERO

func _on_hurt_box_area_entered(area: Area2D) -> void:
	$HurtSound.play()
	currentHealth -= 10
	apply_shake()
	# Detects player death and restarts lvl
	if currentHealth < 0:
		dead = true
		$Animations.modulate = Color(1,0,0)
		await get_tree().create_timer(.25).timeout
		$Death/Death_message.show()
		$Death/Death_timer.start()
		position = Vector2(1000,477)
		await $Death/Death_timer.timeout
		$Death/Death_message.hide()
		currentHealth = maxHealth

	else:
		$Animations.modulate = Color(1,0,0)
		await get_tree().create_timer(.25).timeout
		$Animations.modulate = Color(1,1,1)
		
	health_update.emit()
	

func _on_health_pickup_box_area_entered(area: Area2D) -> void:
	currentHealth += 30
	$PickupSound.play()


func shake_receiver() -> void:
	apply_shake()
