extends Node2D

func _on_continue_button_pressed() -> void:
	FragmentHandler.continued = true
	get_tree().change_scene_to_file("res://Scenes/town.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
