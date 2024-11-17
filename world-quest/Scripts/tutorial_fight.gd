extends Control
signal continued
var passed = false
var continue_pressed = false

func _ready():
	$DummyPlayer.direction = Vector2(-1,0)
	$Continue.play('Continue')

func _process(delta: float) -> void:
	if not continue_pressed:
		if Input.is_action_just_pressed('strike'):
			continue_pressed = true
			$DummyPlayer.direction = Vector2(0,0)
			if passed:
				$DummyPlayer.position = $Marker2D.position
				continued.emit('strike_right_1')
			else:
				continued.emit('strike_left_1')
			$StartSound.play()
			await get_tree().create_timer(1).timeout
			get_tree().change_scene_to_file("res://Scenes/fight.tscn")


func _on_leave_area_body_entered(body: Node2D) -> void:
	''' player walked outside of screen view '''
	passed = true
