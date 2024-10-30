extends Area2D

func _ready():
	$BaseSprite.z_index = position.y + 10
	$GlowSprite.z_index = position.y + 13

func _on_area_entered(area: Area2D) -> void:
	''' gets collected '''
	FragmentHandler.north_fragment = true
	$PickupSound.play()
	await get_tree().create_timer(0.1).timeout
	queue_free()


func _on_timer_timeout() -> void:
	''' delay until player can interact with fragment '''
	$CollisionShape2D.disabled = false
	$GlowSprite.hide()
