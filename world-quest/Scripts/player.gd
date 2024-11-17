extends CharacterBody2D
class_name Player

signal health_update

@export var speed = 75
var screen_size = Vector2(1000,1000)

@export var inv: Inv

@export var maxHealth = 300
@export var currentHealth: int = maxHealth

var dead = false # if player is dead
var water_range = false # if player is in range of waterable plant
var weed_range = false # if player in range of weeds
var interacting = false # # if player is interacting with something
var facing = 'right' # stores which direction is facing (right or left)
var colliding_pos : Vector2
var foot_step = false # if foot step is currently playing
var carrying = false # if player is holding pumpkin
var pickup_range = false # if player is in range of pickup-able pumpkin
var foot_timer = 0.55
signal place # signals that player placed a pumpkin
signal pickup # signals that player picked up a  pumpkin
var direction = 'control' # determine if player has control
var strike_state = 0 # determine which attack player is on
var slashing = false # check if player striking
var buffer = false # allows players to buffer strike inputs
var tutorial = false # if player has tutorial pulled up
var pumpkin_shake = false # dampen pumpkin carry step shaking
var stone_range = false # if player is in range of forage item



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
	$Tutorials.hide()
	
	
func _process(delta: float):
	''' continuous processes '''
	if not dead:
		$Animations.z_index = position.y + 44
		if buffer:
			# continuously input strike if buffered
			strike(delta)
		if Input.is_action_just_pressed('strike'):
			strike(delta)
		if Input.is_action_just_pressed('interact'):
			if not carrying and not interacting:
				# check what interact is being done
				if stone_range:
					stone_collect()
				elif weed_range:
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
		
		if slashing:
			slash_handler()
		
		if currentHealth == maxHealth or $Animations.animation.contains('fragment'):
			$HealthBar.hide()
		else:
			$HealthBar.show()
	# camera shake stuff
	shake_strength = lerp(shake_strength, 0.0, shake_decay_rate * delta)
	$Camera2D.offset = get_noise_offset(delta, noise_shake_speed, shake_strength)
	
	if Input.is_action_just_pressed('menu'):
		tutorial_handler()


func move(delta):
	''' controls player movement '''
	
	# player movement y direction
	if not interacting and not slashing:
		if Input.is_action_pressed('move_down'):
			velocity.y = 1
			if not Input.is_action_pressed('move_right') and not Input.is_action_pressed('move_left') and not carrying:
				$Animations.animation = 'walk_front'
			elif not Input.is_action_pressed('move_right') and not Input.is_action_pressed('move_left') and carrying:
				$Animations.animation = 'carry_right'
				if $Animations.frame == 1:
					apply_pumpkin_shake()
		elif Input.is_action_pressed('move_up'):
			velocity.y = -1
			if not Input.is_action_pressed('move_right') and not Input.is_action_pressed('move_left') and not carrying:
				$Animations.animation = 'walk_back'
			elif not Input.is_action_pressed('move_right') and not Input.is_action_pressed('move_left') and carrying:
				$Animations.animation = 'carry_left'
				if $Animations.frame == 1:
					apply_pumpkin_shake()
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
					apply_pumpkin_shake()
		elif Input.is_action_pressed('move_left'):
			velocity.x = -1
			facing = 'left'
			if not Input.is_action_pressed('strike') and not carrying:
				$Animations.animation = 'walk_left'
			elif not Input.is_action_pressed('strike') and carrying:
				$Animations.animation = 'carry_left'
				if $Animations.frame == 1:
					apply_pumpkin_shake()
		else:
			velocity.x = 0
	else:
		velocity.y = 0
		velocity.x = 0
	
	if direction != 'control':
		if direction == 'north':
			velocity.y = -1
		
		elif direction == 'south':
			velocity.y = 1
		
		elif direction == 'west':
			velocity.x = -1
		
		elif direction == 'east':
			velocity.x = 1
	
	# normalize movement
	if velocity.length() > 0:
		$Animations.play()
		velocity = velocity.normalized() * speed
		foot_step_sound()
		
	
	else:
		#$Animations.animation = 'idle'
		if not interacting and not slashing:
			$Animations.stop()

	
	# update position and control animation direction
	#$Animations.flip_h = velocity.x < 0
	position += velocity * delta
	
	if direction == 'control':
		position = position.clamp(Vector2.ZERO, screen_size)
	
	# control collisions
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.slide(collision.get_normal())

func strike(delta):
	''' Player attacks '''
	if FragmentHandler.sword_pickup and not carrying and not interacting and not slashing:
		#$StrikeSound.play()
		slashing = true
		if facing == 'right':
			if strike_state == 0 or strike_state == 3:
				buffer = false
				$Animations.play('strike_right_1')
				$Animations.frame = 1
				strike_state = 1
				await get_tree().create_timer(.1).timeout
				position.x += 10
				$StrikeSound.play()
				await get_tree().create_timer(.3).timeout
			elif strike_state == 1:
				buffer = false
				$Animations.play('strike_right_2')
				$Animations.frame = 1
				strike_state = 2
				await get_tree().create_timer(.2).timeout
				position.x += 10
				$StrikeSound.play()
				await get_tree().create_timer(.3).timeout
			elif strike_state == 2:
				buffer = false
				$Animations.play('strike_right_3')
				$Animations.frame = 1
				strike_state = 3
				await get_tree().create_timer(.1).timeout
				position.x -= 5
				$StrikeSound.play()
				await get_tree().create_timer(.3).timeout
		elif facing == 'left':
			if strike_state == 0 or strike_state == 3:
				buffer = false
				$Animations.play('strike_left_1')
				$Animations.frame = 1
				strike_state = 1
				await get_tree().create_timer(.1).timeout
				position.x -= 10
				$StrikeSound.play()
				await get_tree().create_timer(.3).timeout
			elif strike_state == 1:
				buffer = false
				$Animations.play('strike_left_2')
				$Animations.frame = 1
				strike_state = 2
				await get_tree().create_timer(.2).timeout
				position.x -= 10
				$StrikeSound.play()
				await get_tree().create_timer(.3).timeout
			elif strike_state == 2:
				buffer = false
				$Animations.play('strike_left_3')
				$Animations.frame = 1
				strike_state = 3
				await get_tree().create_timer(.1).timeout
				position.x += 5
				$StrikeSound.play()
				await get_tree().create_timer(.3).timeout
		slashing = false
		check_stop_slashing()
			
	elif slashing:
		buffer = true

func slash_handler():
	''' handles when to play sounds, when to enable hitboxes, etc. '''
	if strike_state == 1 and facing == 'right':
		if $Animations.frame == 2:
			#$StrikeSound.play()
			$HitBoxes/HitBox1Right/Collision.disabled = false
			#position.x += 10
		elif $Animations.frame == 0:
			$HitBoxes/HitBox1Right/Collision.disabled = true
	elif strike_state == 1 and facing == 'left':
		if $Animations.frame == 2:
			#$StrikeSound.play()
			$HitBoxes/HitBox1Left/Collision.disabled = false
			#position.x -= 10
		elif $Animations.frame == 0:
			$HitBoxes/HitBox1Left/Collision.disabled = true
	elif strike_state == 2 and facing == 'right':
		if $Animations.frame == 3:
			#$StrikeSound.play()
			$HitBoxes/HitBox2Right/Collision.disabled = false
			#position.x += 10
		elif $Animations.frame == 0:
			$HitBoxes/HitBox2Right/Collision.disabled = true
	elif strike_state == 2 and facing == 'left':
		if $Animations.frame == 3:
			#$StrikeSound.play()
			$HitBoxes/HitBox2Left/Collision.disabled = false
			#position.x -= 10
		elif $Animations.frame == 0:
			$HitBoxes/HitBox2Left/Collision.disabled = true
	elif strike_state == 3 and facing == 'right':
		if $Animations.frame == 2:
			#$StrikeSound.play()
			$HitBoxes/HitBox3Right/Collision.disabled = false
			#position.x += 10
		elif $Animations.frame == 0:
			$HitBoxes/HitBox3Right/Collision.disabled = true
	elif strike_state == 3 and facing == 'left':
		if $Animations.frame == 2:
			#$StrikeSound.play()
			$HitBoxes/HitBox3Left/Collision.disabled = false
			#position.x += 10
		elif $Animations.frame == 0:
			$HitBoxes/HitBox3Left/Collision.disabled = true
	

func check_stop_slashing():
	''' determine if player stopped attacking '''
	await get_tree().create_timer(1).timeout
	if not slashing:
		strike_state = 0
		if facing == 'right':
			$Animations.play('walk_right')
		else:
			$Animations.play('walk_left')

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

func apply_pumpkin_shake():
	''' activate camera shake (from tutorial) '''
	if not pumpkin_shake:
		pumpkin_shake = true
		shake_strength = noise_shake_strength
		await get_tree().create_timer(1.5).timeout
		pumpkin_shake = false

func deweed(delta):
	''' remove weeds from plant '''
	interacting = true # used to disable other animations/actions
	$InteractArea.set_collision_layer_value(1, false)
	$InteractArea.set_collision_mask_value(1, false)
	
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
	#weed_range = false
	interacting = false
	$InteractArea.set_collision_layer_value(1, true)
	$InteractArea.set_collision_mask_value(1, true)

func cast(delta):
	if FragmentHandler.rod_pickup:
		interacting = true
		if $Animations.animation != 'cast':
			$Animations.play('cast_up')
			await get_tree().create_timer(2).timeout
			interacting = false
	
func water():
	''' water plants '''
	#$InteractArea.set_collision_layer_value(1, false)
	#$InteractArea.set_collision_mask_value(1, false)
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
		#$InteractArea.set_collision_layer_value(1, true)
		#$InteractArea.set_collision_mask_value(1, true)
	
func carry():
	pickup.emit()
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
	apply_shake()

func stone_collect():
	''' pickup items in forage area '''
	interacting = true
	var prev_anim = $Animations.animation
	if facing == 'right':
		$Animations.play('pickup_right')
	else:
		$Animations.play('pickup_left')
	await get_tree().create_timer(.5).timeout
	$Animations.play(prev_anim)
	interacting = false

func _on_interact_area_area_entered(area: Area2D) -> void:
	''' check to see what interaction zone player entered, 
		change state accordingly '''
	if area.is_in_group('dead_plant'):
		water_range = true
	if area.is_in_group('weed'):
		weed_range = true
	if area.is_in_group('pumpkin'):
		pickup_range = true
	if area.is_in_group('stone'):
		print('here')
		stone_range = true
	colliding_pos = area.global_position
		
func _on_interact_area_area_exited(area: Area2D) -> void:
	''' disable state change when interaction zone left '''
	if area.is_in_group('dead_plant'):
		water_range = false
	if area.is_in_group('weed'):
		weed_range = false
	if area.is_in_group('pumpkin'):
		pickup_range = false
	if area.is_in_group('stone'):
		stone_range = false
	colliding_pos = Vector2.ZERO

func _on_hurt_box_area_entered(area: Area2D) -> void:
	$HurtBox.set_collision_layer_value(2, false)
	$HurtBox.set_collision_mask_value(3, false)
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
		$HurtBox.set_collision_layer_value(2, true)
		$HurtBox.set_collision_mask_value(3, true)

	else:
		$Animations.modulate = Color(1,0,0)
		await get_tree().create_timer(.25).timeout
		$Animations.modulate = Color(1,1,1)
		await get_tree().create_timer(.5).timeout
		$HurtBox.set_collision_layer_value(2, true)
		$HurtBox.set_collision_mask_value(3, true)
		
	health_update.emit()
	

func _on_health_pickup_box_area_entered(area: Area2D) -> void:
	currentHealth += 30
	if currentHealth > maxHealth:
		currentHealth = maxHealth
	health_update.emit()
	$PickupSound.play()


func shake_receiver() -> void:
	apply_shake()

func traveling(received_direction):
	''' Takes control of player when entering travel area '''
	interacting = true
	direction = received_direction
	speed = 30
	if received_direction == 'south':
		$Animations.play('walk_front')
	elif received_direction == 'north':
		$Animations.play('walk_back')
	elif received_direction == 'east':
		$Animations.play('walk_right')
	elif received_direction == 'west':
		$Animations.play('walk_left')
	await get_tree().create_timer(1).timeout
	interacting = false
	direction = 'control'
	speed = 75


func fragment_collected(piece : String):
	''' plays fragment collection animation '''
	interacting = true
	var prev_anim = $Animations.animation
	var anim_string = 'fragment_collected_' + piece
	$Animations.play(anim_string)
	await get_tree().create_timer(2).timeout
	interacting = false
	$Animations.play(prev_anim)


func tutorial_handler():
	''' enable/disable tutorial '''
	var location = get_tree().current_scene.to_string()
	if not tutorial:
		if not interacting:
			interacting = true
		tutorial = true
		$Tutorials.show()
		if location.contains('Town'):
			$Tutorials/TutorialMain.show()
		elif location.contains('Fishing'):
			$Tutorials/TutorialFish.show()
		elif location.contains('Fight'):
			$Tutorials/TutorialFight.show()
		elif location.contains('Farm'):
			$Tutorials/TutorialFarm.show()
		elif location.contains('Forage'):
			$Tutorials/TutorialForage.show()
	else:
		interacting = false
		tutorial = false
		$Tutorials.hide()
		if location.contains('Town'):
			$Tutorials/TutorialMain.hide()
		elif location.contains('Fishing'):
			$Tutorials/TutorialFish.hide()
		elif location.contains('Fight'):
			$Tutorials/TutorialFight.hide()
		elif location.contains('Farm'):
			$Tutorials/TutorialFarm.hide()
		elif location.contains('Forage'):
			$Tutorials/TutorialForage.hide()
		
