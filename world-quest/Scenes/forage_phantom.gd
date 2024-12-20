extends Area2D
signal wave_counter
#@onready var player = preload("res://Scenes/player.tscn")
const speed = 150
var player_position
var target_position
@onready var player = get_parent().get_parent().get_node("Player")
var chasing = false
var wander = false
var target
var target_place
var maxHealth = 20
var currentHealth: int = maxHealth
var knockbackPower = 300
var dead = false
var destination = global_position
var vel
var direction
var wait = true
@onready var health_pickup = preload("res://Scenes/health_pickup.tscn")

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	wait = false
	#linear_velocity = Vector2.ZERO
	#angular_velocity = 0

func _physics_process(delta: float) -> void:
	if not dead:
		$Animations.animation = 'floating'
		$Animations.z_index = position.y + 24
		$Animations.play()
		if abs(destination - global_position) > Vector2.ZERO and not wait:
			direction = (destination - global_position).normalized()
			vel = (direction * speed)
			#linear_velocity = (direction.normalized() * speed)
			#move_and_collide(direction.normalized() * speed)
			global_position += vel * delta
			
		#player_position = player.position
		#target_position = target_position
		#if position.distance_to(player_position) < 150:
			#chasing = false
			#wander = false
			#move_and_collide(target_position * speed)
		#else:
			#chasing = false
			#
		#if wander:
			#move_and_collide(target_place * speed)
			#


func _on_hurt_box_area_entered(area: Area2D) -> void:
	''' phantom boss gets hit/killed '''
	$DeathSound.play(1.09)
	currentHealth -= 100
	#knockback()
	if currentHealth <= 0:
		dead = true
		modulate = Color(1,0,0)
		$CollisionBox.disabled = true
		$HurtBox/HurtBoxShape.disabled = true
		await get_tree().create_timer(.25).timeout
		
		# 'roll dice' to see if drop health
		var num = randf()
		if num > 0.8:
			var health_pickup_instance = health_pickup.instantiate()
			get_parent().add_child(health_pickup_instance)
			health_pickup_instance.global_position = global_position
			
		queue_free()
		wave_counter.emit()
	else:
		modulate = Color(1,0,0)
		await get_tree().create_timer(.25).timeout
		modulate = Color(1,1,1)
		
#func knockback():
	#var kb_position = (player_position + position).normalized()
	#move_and_collide(kb_position * knockbackPower)

#func _on_wander_timer_timeout() -> void:
	#''' make phantoms wander when player not around '''
	#if not dead:
		#$WanderTimer.stop()
		#if not chasing:
			#target = Vector2(randf_range(0,1000), randf_range(0,1000))
			#target_place = (target - position).normalized()
			##move_and_collide(target_place * speed) # need to make this apply over duration of timer
			#wander = false
		#await get_tree().create_timer(randf_range(0,4)).timeout
		#$WanderTimer.start()
	
