extends RigidBody2D


const speed = 2
var player_position
var target_position
@onready var player = get_parent().get_parent().get_node("Player")

func _physics_process(delta: float) -> void:
	$Animations.play()
	player_position = player.position
	target_position = (player_position - position).normalized()
	if position.distance_to(player_position) < 400:
		move_and_collide(target_position * speed)



func _on_hurt_box_area_entered(area: Area2D) -> void:
	queue_free()
