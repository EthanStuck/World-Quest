extends Node

func ready(delta):
	$Bobber.hide()
	$Bubbles.hide()

func _on_travel_back_area_entered(area: Area2D) -> void:
	''' Travel back to town '''
	get_tree().change_scene_to_file("res://Scenes/town.tscn")

func process(delta):
	if Input.is_action_just_pressed('cast'):
			$Bobber.position = Player.position.y + 50
			$Bobber.show()
			bubbles(delta)
			
func bubbles(delta):
	$Bubbles.position = Player.position.y + 150
	$Bubbles.show()
	

	
