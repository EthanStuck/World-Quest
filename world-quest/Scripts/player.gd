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


var foot_step = false

func _ready():
	''' player startup '''
	#screen_size = get_viewport_rect().size
	$Death/Death_message.hide()
	$Animations.play()
	
	
func _process(delta):
	''' continuous processes '''
	if not dead:
		move(delta)
		$Animations.z_index = position.y + 44
		if Input.is_action_just_pressed('strike'):
			strike(delta)
		if Input.is_action_just_pressed('interact'):
			if weed_range:
				deweed()
			elif water_range:
				water()


func move(delta):
	''' controls player movement '''
	
	# player movement y direction
	if not interacting:
		if Input.is_action_pressed('move_down'):
			velocity.y = 1
			if not Input.is_action_pressed('move_right') and not Input.is_action_pressed('move_left'):
				$Animations.animation = 'walk_front'
		elif Input.is_action_pressed('move_up'):
			velocity.y = -1
			if not Input.is_action_pressed('move_right') and not Input.is_action_pressed('move_left'):
				$Animations.animation = 'walk_back'
		else:
			velocity.y = 0
		
		# player movement x direction
		if Input.is_action_pressed('move_right'):
			velocity.x = 1
			if not Input.is_action_pressed('strike'):
				$Animations.animation = 'walk_right'
		elif Input.is_action_pressed('move_left'):
			velocity.x = -1
			if not Input.is_action_pressed('strike'):
				$Animations.animation = 'walk_left'
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
	if FragmentHandler.sword_pickup:
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
		await get_tree().create_timer(.55).timeout
		foot_step = false

func player():
	pass
func collect(item):
	inv.insert(item)


func deweed():
	interacting = true
	var prev_anim = $Animations.animation
	$Animations.animation = 'deweed_right'
	await get_tree().create_timer(0.5).timeout
	$Animations.animation = prev_anim
	weed_range = false
	interacting = false
	
func water():
	interacting = true
	var prev_anim = $Animations.animation
	$Animations.stop()
	$Animations.play('water_right')
	await get_tree().create_timer(1).timeout
	#$Animations.animation = prev_anim
	$Animations.play(prev_anim)
	water_range = false
	interacting = false
	
func _on_interact_area_body_entered(body: Node2D) -> void:
	if body.is_in_group('weed'):
		weed_range = true

func _on_interact_area_body_exited(body: Node2D) -> void:
	if body.is_in_group('weed'):
		weed_range = true

func _on_interact_area_area_entered(area: Area2D) -> void:
	if area.is_in_group('dead_plant'):
		water_range = true
		
func _on_interact_area_area_exited(area: Area2D) -> void:
	if area.is_in_group('dead_plant'):
		water_range = false

func _on_hurt_box_area_entered(area: Area2D) -> void:
	$HurtSound.play()
	currentHealth -= 10
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
