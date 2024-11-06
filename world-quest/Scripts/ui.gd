extends Node


func show_message(message: String) -> void:
	$MessageLabel.text = message
	$MessageLabel.show()
	await(get_tree().create_timer(2.0))
	$MessageLabel.hide()
	print("text changed")
