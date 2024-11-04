extends Node

var forage_scene = preload("res://Scenes/forage.tscn").instantiate()
@onready var sword = preload("res://Scenes/sword.tscn")

func _ready():
	if not FragmentHandler.sword_pickup:
		var sword_instance = sword.instantiate()
		get_parent().add_child(sword_instance)
		sword_instance.global_position = $SwordSpawnLocation.position

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
