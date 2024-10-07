extends Area2D

signal collected

func _on_area_entered(area: Area2D) -> void:
	''' become collected '''
	collected.emit()
	queue_free()
