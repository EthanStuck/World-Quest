extends Control

func _ready():
	$DummyPlayer.direction = Vector2(1,0)
	$Continue.play('Continue')

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('strike'):
		get_tree().change_scene_to_file("res://Scenes/farm.tscn")
