extends RigidBody2D
signal wave_counter
#@onready var player = preload("res://Scenes/player.tscn")
const speed = 2
var player_position
var target_position
@onready var player = get_parent().get_node("Player")
var chasing = false
var wander = false
var target
var target_place
var maxHealth = 100
var currentHealth: int = maxHealth
var knockbackPower = 300
@onready var fragment = preload("res://Scenes/fragment_west.tscn")
var dead = false
signal died

func _physics_process(delta: float) -> void:
	if not dead:
		$Animations.animation = 'float'
		$Animations.z_index = position.y + 24
		$Animations.play()
		player_position = player.position
		target_position = (player_position - position).normalized()
		if position.distance_to(player_position) < 150:
			chasing = true
			wander = false
			move_and_collide(target_position * speed)
		else:
			chasing = false
			
		if wander:
			move_and_collide(target_place * speed)
			




func _on_hurt_box_area_entered(area: Area2D) -> void:
	''' phantom boss gets hit/killed '''
	$DeathSound.play(1.09)
	currentHealth -= 10
	#knockback()
	if currentHealth <= 0:
		dead = true
		modulate = Color(1,0,0)
		$CollisionBox.set_deferred('disabled', true)
		$HurtBox/HurtBoxShape.set_deferred('disabled', true)
		await get_tree().create_timer(.25).timeout
		queue_free()
		wave_counter.emit()
		died.emit()
		#var fragment_instance = fragment.instantiate()
		#get_parent().add_child(fragment_instance)
		#fragment_instance.global_position = global_position
		#FragmentHandler.west_complete = true
	else:
		modulate = Color(1,0,0)
		await get_tree().create_timer(.25).timeout
		modulate = Color(1,1,1)
		
#func knockback():
	#var kb_position = (player_position + position).normalized()
	#move_and_collide(kb_position * knockbackPower)

func _on_wander_timer_timeout() -> void:
	''' make phantoms wander when player not around '''
	if not dead:
		$WanderTimer.stop()
		if not chasing:
			target = Vector2(randf_range(0,1000), randf_range(0,1000))
			target_place = (target - position).normalized()
			#move_and_collide(target_place * speed) # need to make this apply over duration of timer
			wander = true
		await get_tree().create_timer(randf_range(0,4)).timeout
		$WanderTimer.start()
	
