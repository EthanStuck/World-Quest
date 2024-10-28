extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$loading_animation.play()
	$load_time.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_load_time_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/town.tscn")
