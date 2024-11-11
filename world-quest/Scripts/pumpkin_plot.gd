extends Area2D
signal pumpkin_added
signal pumpkin_removed

func _ready():
	$FenceTop.z_index = position.y - 200
	$FenceBottom.z_index = position.y + 243
	$FenceSides.z_index = position.y + 235
	



func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group('pumpkin'):
		pumpkin_added.emit()
		$RewardSound.play(0)
		await get_tree().create_timer(1).timeout
		$RewardSound.stop()


func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group('pumpkin'):
		pumpkin_removed.emit()
