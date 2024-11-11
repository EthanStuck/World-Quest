extends Node2D

func _ready():
	$Animation.z_index = position.y + 31
	$Animation.play('fall')
	await get_tree().create_timer(1).timeout
	queue_free()
