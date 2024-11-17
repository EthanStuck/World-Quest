extends Node

@onready var fragment = preload("res://Scenes/fragment_east.tscn")
@onready var bucket_load = preload("res://Scenes/water_bucket.tscn")
var num_pumpkins = 0 # number pumpkins brought to plot
signal traveling
signal fragment_collected

func _ready():
	FragmentHandler.at = 'farming'
	reverse_transition('east')
	$Fences/FenceTop.z_index = $Fences/FenceTop.position.y - 200
	$Fences/FenceTop2.z_index = $Fences/FenceTop.position.y - 200
	$Fences/FenceTop3.z_index = $Fences/FenceTop.position.y - 200
	$Fences/FenceTop4.z_index = $Fences/FenceTop.position.y - 200
	$Fences/FenceSide/Sprite2D2.z_index = $Fences/FenceTop.position.y + 235
	$Fences/FenceSide/Sprite2D3.z_index = $Fences/FenceTop.position.y + - 200
	if FragmentHandler.east_opened or FragmentHandler.east_complete:
		open_gates()


func _on_travel_back_area_entered(area: Area2D) -> void:
	''' Travel back to town '''
	transition('west')
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/town.tscn")


func _on_pumpkin_plot_pumpkin_added() -> void:
	num_pumpkins += 1
	if num_pumpkins == 6 and not FragmentHandler.east_complete:
		var fragment_instance = fragment.instantiate()
		add_child(fragment_instance)
		fragment_instance.global_position = $FragmentSpawnLocation.position
		FragmentHandler.east_complete = true
		fragment_instance.collected.connect(on_collected)

func on_collected(item):
	''' send signal to player that item was collected '''
	fragment_collected.emit(item)

func _on_pumpkin_plot_pumpkin_removed() -> void:
	num_pumpkins -= 1


func transition(direction : String):
	$TransitionRect.show()
	$TransitionRect/AnimationPlayer.play('Fade')
	traveling.emit(direction)

func reverse_transition(direction : String):
	$ReverseTransitionRect.show()
	$ReverseTransitionRect/AnimationPlayer.play('Fade')
	traveling.emit(direction)


func open_gates():
	$Fences/FenceSide/Sprite2D.hide()
	$Fences/FenceSide/CollisionShape2D.set_deferred('disabled', true)
	FragmentHandler.east_opened = true


func bucket_spawn():
	if not FragmentHandler.bucket_collected:
		var bucket = bucket_load.instantiate()
		add_child(bucket)
		bucket.global_position = $BucketLocation.position
		bucket.collected.connect(on_collected)
