extends RigidBody2D


const speed = 2
var player_position
var target_position
@onready var player = get_parent().get_parent().get_node("Player")
var chasing = false
var wander = false
var target
var target_place

func _physics_process(delta: float) -> void:

		$Animations.play()
		player_position = player.position
		target_position = (player_position - position).normalized()
		if position.distance_to(player_position) < 200:
			chasing = true
			wander = false
			move_and_collide(target_position * speed)
		else:
			chasing = false
			
		if wander:
			move_and_collide(target_place * speed)
			




func _on_hurt_box_area_entered(area: Area2D) -> void:

	''' phantom gets killed '''
	queue_free()



func _on_wander_timer_timeout() -> void:
	''' make phantoms wander when player not around '''
	$WanderTimer.stop()
	if not chasing:
		target = Vector2(randf_range(0,1000), randf_range(0,1000))
		target_place = (target - position).normalized()
		#move_and_collide(target_place * speed) # need to make this apply over duration of timer
		wander = true
	await get_tree().create_timer(randf_range(0,4)).timeout
	$WanderTimer.start()
	

