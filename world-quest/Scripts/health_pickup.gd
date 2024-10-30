extends Area2D

func _ready():
	$Sprite2D.z_index = position.y + 11

func _on_area_entered(area: Area2D) -> void:
	''' gets collected '''
	#$PickupSound.play()
	await get_tree().create_timer(0.1).timeout
	queue_free()


func _on_timer_timeout() -> void:
	''' delay until player can interact with fragment '''
	$CollisionShape2D.disabled = false
