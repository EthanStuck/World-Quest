extends Node

var total_pickup = 0
@onready var fragment = preload("res://Scenes/fragment_south.tscn")
@onready var spirit_load = preload("res://Scenes/tiny_spirit.tscn")
signal traveling
signal fragment_collected
signal solved

func _ready():
	FragmentHandler.at = 'foraging'
	reverse_transition('south')
	spawn_tiny_phantom()
	$YellowRocks/yellowrock8.hide()
	$YellowRocks/yellowrock8/CollisionShape2D.disabled = true
	
	if FragmentHandler.south_spawned:
		var fragment_instance = fragment.instantiate()
		add_child.call_deferred(fragment_instance)
		fragment_instance.global_position = $FragmentSpawnLocation.position
		fragment_instance.collected.connect(on_fragment_collected)

func _on_travel_back_area_entered(area: Area2D) -> void:
	''' Travel back to town '''
	transition('north')
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/town.tscn")

func on_fragment_collected(item):
	''' send signal to player that fragment was collected '''
	fragment_collected.emit(item)

func spawn_tiny_phantom():
	''' randomly spawn tiny phantoms to run around until area complete '''
	var x = randf_range(0.1, 10)
	var spawn_location
	await get_tree().create_timer(x).timeout
	var spawn_indicator = randi_range(1,8)	
	if spawn_indicator == 1:
		spawn_location = $TinyPhantomSpawns/Spawn1.position
	elif spawn_indicator == 2:
		spawn_location = $TinyPhantomSpawns/Spawn2.position
	elif spawn_indicator == 3:
		spawn_location = $TinyPhantomSpawns/Spawn3.position
	elif spawn_indicator == 4:
		spawn_location = $TinyPhantomSpawns/Spawn4.position
	elif spawn_indicator == 5:
		spawn_location = $TinyPhantomSpawns/Spawn5.position
	elif spawn_indicator == 6:
		spawn_location = $TinyPhantomSpawns/Spawn6.position
	elif spawn_indicator == 7:
		spawn_location = $TinyPhantomSpawns/Spawn7.position
	elif spawn_indicator == 8:
		spawn_location = $TinyPhantomSpawns/Spawn8.position
	var spirit = spirit_load.instantiate()
	get_parent().add_child(spirit)
	spirit.global_position = spawn_location
	spirit.z_index = spirit.position.y
	var dir = randi_range(0,1)
	if dir == 1:
		spirit.speed = -spirit.speed
		spirit.get_node('Animations').animation = 'run_left'
	if not FragmentHandler.south_complete:
		spawn_tiny_phantom()
	


func transition(direction : String):
	$TransitionRect.show()
	$TransitionRect/AnimationPlayer.play('Fade')
	traveling.emit(direction)

func reverse_transition(direction : String):
	$ReverseTransitionRect.show()
	$ReverseTransitionRect/AnimationPlayer.play('Fade')
	traveling.emit(direction)


func _on_forage_npc_give_item() -> void:
	$YellowRocks/yellowrock8.show()
	$YellowRocks/yellowrock8/CollisionShape2D.disabled = false


func _on_yellowrock_collected() -> void:
	total_pickup += 1
	
	# when all pieces collected, spawn fragment
	if total_pickup == 11:
		if not FragmentHandler.south_fragment and not FragmentHandler.south_complete:
			solved.emit()
			$PickupSound.play()
			var fragment_instance = fragment.instantiate()
			add_child(fragment_instance)
			fragment_instance.global_position = $FragmentSpawnLocation.position
			FragmentHandler.south_complete = true
			FragmentHandler.south_spawned = true
			fragment_instance.collected.connect(on_fragment_collected)
