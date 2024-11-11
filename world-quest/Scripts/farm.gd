extends Node

@onready var fragment = preload("res://Scenes/fragment_east.tscn")
var num_pumpkins = 0 # number pumpkins brought to plot

func _ready():
	FragmentHandler.at = 'farming'


func _on_travel_back_area_entered(area: Area2D) -> void:
	''' Travel back to town '''
	get_tree().change_scene_to_file("res://Scenes/town.tscn")
	
#func _process(delta):
	#if FragmentHandler.num_carrots >= 30 and not FragmentHandler.east_complete:
		#var fragment_instance = fragment.instantiate()
		#get_parent().add_child(fragment_instance)
		#fragment_instance.global_position = $FragmentSpawnLocation.position
		#FragmentHandler.east_complete = true


func _on_pumpkin_plot_pumpkin_added() -> void:
	num_pumpkins += 1
	if num_pumpkins == 6 and not FragmentHandler.east_complete:
		var fragment_instance = fragment.instantiate()
		get_parent().add_child(fragment_instance)
		fragment_instance.global_position = $FragmentSpawnLocation.position
		FragmentHandler.east_complete = true


func _on_pumpkin_plot_pumpkin_removed() -> void:
	num_pumpkins -= 1
