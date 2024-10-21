extends Node

var forage_scene = preload("res://Scenes/forage.tscn").instantiate()

func _on_to_foraging_area_entered(area: Area2D) -> void:
	''' Send player to foraging scene '''
	get_tree().change_scene_to_file("res://Scenes/forage.tscn")

func _on_to_fishing_area_entered(area: Area2D) -> void:
	''' Send player to fishing scene '''
	get_tree().change_scene_to_file("res://Scenes/fishing.tscn")

func _on_to_fighting_area_entered(area: Area2D) -> void:
	''' Send player to fighting scene '''
	get_tree().change_scene_to_file("res://Scenes/fight.tscn")

func _on_to_farming_area_entered(area: Area2D) -> void:
	''' Send player to farming scene '''
	get_tree().change_scene_to_file("res://Scenes/farm.tscn")


func _on_statue_interact_zone_area_entered(area: Area2D) -> void:
	''' early version of adding to statue mechanic '''
	if $Player.left_piece:
		$Statue.modulate = Color(0,1,0)
		
	if $Player.right_piece:
		$Statue.modulate = Color(1,0,0)
	
	if $Player.top_piece:
		$Statue.modulate = Color(0,0,1)
		
	if $Player.south_piece:
		$Statue.modulate = Color(0,1,1)
