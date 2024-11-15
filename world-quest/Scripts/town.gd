extends Node

var forage_scene = preload("res://Scenes/forage.tscn").instantiate()
signal traveling

func _ready():
	var from = FragmentHandler.at
	if from == 'fighting':
		$Player.position = $"Travel Areas/FromFighting".position
	elif from == 'foraging':
		$Player.position = $"Travel Areas/FromForaging".position
	elif from == 'fishing':
		$Player.position = $"Travel Areas/FromFishing".position
	elif from == 'farming':
		$Player.position = $"Travel Areas/FromFarming".position
	FragmentHandler.at = 'town'
	$TransitionRect.hide()
	

func _on_to_foraging_area_entered(area: Area2D) -> void:
	''' Send player to foraging scene '''
	transition('south')
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/tutorial_forage.tscn")

func _on_to_fishing_area_entered(area: Area2D) -> void:
	''' Send player to fishing scene '''
	transition('north')
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/tutorial_fish.tscn")

func _on_to_fighting_area_entered(area: Area2D) -> void:
	''' Send player to fighting scene '''
	transition('west')
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/tutorial_fight.tscn")

func _on_to_farming_area_entered(area: Area2D) -> void:
	''' Send player to farming scene '''
	transition('east')
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/tutorial_farm.tscn")


func transition(direction : String):
	$TransitionRect.show()
	$TransitionRect/AnimationPlayer.play('Fade')
	traveling.emit(direction)
