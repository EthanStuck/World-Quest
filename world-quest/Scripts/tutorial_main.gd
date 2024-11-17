extends Control
signal continued

func _ready():
	$DummyPlayer.direction = Vector2(0,0)
	$Continue.play('Continue')

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('strike'):
		continued.emit('strike_right_2')
		$StartSound.play()
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://Scenes/town.tscn")
