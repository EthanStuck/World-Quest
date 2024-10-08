extends Node

var items_collected = 0

func on_ready():
	$NumItemsLabel.text = 'Items found: ' + str(items_collected)

func _on_travel_back_area_entered(area: Area2D) -> void:
	''' Travel back to town '''
	get_tree().change_scene_to_file("res://Scenes/town.tscn")


func _on_forage_item_collected() -> void:
	items_collected += 1
	$NumItemsLabel.text = 'Items found: ' + str(items_collected)
	$PickupSound.play()
	
#func _process(delta):
	#if Input.is_action_pressed('move_down'):
		#$Player/FootStep.play()
	#elif Input.is_action_pressed('move_up'):
		#$Player/FootStep.play()
	#elif Input.is_action_pressed('move_right'):
		#$Player/FootStep.play()
	#elif Input.is_action_pressed('move_left'):
		#$Player/FootStep.play()
