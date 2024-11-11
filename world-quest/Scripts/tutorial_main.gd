extends Control

func _ready():
	$DummyPlayer.direction = Vector2(0,0)
	$Continue.play('Continue')

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('strike'):
		$StartSound.play()
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://Scenes/town.tscn")
