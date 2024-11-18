extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MenuMusic.play()



func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/loading_screen.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
