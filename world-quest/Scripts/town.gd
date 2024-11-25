extends Node

var forage_scene = preload("res://Scenes/forage.tscn").instantiate()
@onready var sword_load = preload("res://Scenes/sword.tscn")
signal traveling
signal collected
signal hey

func _ready():
	#$Tutorial.hide()
	var from = FragmentHandler.at
	if from == 'fighting':
		$Player.position = $"Travel Areas/FromFighting".position
		reverse_transition('east')
	elif from == 'foraging':
		$Player.position = $"Travel Areas/FromForaging".position
		reverse_transition('north')
	elif from == 'fishing':
		$Player.position = $"Travel Areas/FromFishing".position
		reverse_transition('south')
	elif from == 'farming':
		$Player.position = $"Travel Areas/FromFarming".position
		reverse_transition('west')
	else:
		$Player.position = $"Travel Areas/Spawn".position
		reverse_transition('north')
	FragmentHandler.at = 'town'
	$TransitionRect.hide()
	if not FragmentHandler.town_entered:
		FragmentHandler.town_entered = true
		await get_tree().create_timer(1).timeout
		hey.emit()
	if FragmentHandler.west_complete:
		$PurpleGradient.hide()
		
	if not FragmentHandler.sword_pickup:
		var sword = sword_load.instantiate()
		add_child.call_deferred(sword)
		sword.global_position = $SwordSpawn.position
		sword.collected.connect(on_collected)
	
func on_collected(item):
	''' send signal to player that item was collected '''
	collected.emit(item)

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

func reverse_transition(direction : String):
	$ReverseTransitionRect.show()
	$ReverseTransitionRect/AnimationPlayer.play('Fade')
	traveling.emit(direction)
