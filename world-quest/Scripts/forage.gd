extends Node

var total_pickup = 0
@onready var fragment = preload("res://Scenes/fragment_south.tscn")
signal traveling

func _ready():
	FragmentHandler.at = 'foraging'

func _on_travel_back_area_entered(area: Area2D) -> void:
	''' Travel back to town '''
	transition('north')
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/town.tscn")


func _on_yellowrock_body_entered(body: Node2D) -> void:
	''' track number of items collected to see when to spawn fragment '''
	total_pickup += 1
	
	# when all pieces collected, spawn fragment
	if total_pickup == 11:
		if not FragmentHandler.south_fragment and not FragmentHandler.south_complete:
			$PickupSound.play()
			var fragment_instance = fragment.instantiate()
			get_parent().add_child(fragment_instance)
			fragment_instance.global_position = $FragmentSpawnLocation.position
			FragmentHandler.south_complete = true


func transition(direction : String):
	$TransitionRect.show()
	$TransitionRect/AnimationPlayer.play('Fade')
	traveling.emit(direction)
