extends Node

@onready var fragment = preload("res://Scenes/fragment_east.tscn")
@onready var bucket_load = preload("res://Scenes/water_bucket.tscn")
@onready var pumpkin_load = preload("res://Scenes/pumpkin.tscn")
signal traveling
signal fragment_collected
signal first_watered
signal first_weeded
signal camera_control
signal camera_end
signal first_placed

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
	
	if FragmentHandler.east_spawned:
		var fragment_instance = fragment.instantiate()
		add_child.call_deferred(fragment_instance)
		fragment_instance.global_position = $FragmentSpawnLocation.position
		fragment_instance.collected.connect(on_collected)
	
	# save/load pumpkin positions
	if not FarmSave.entered:
		FarmSave.PumPos0 = $Pumpkins/Pumpkin0.position
		FarmSave.PumPos1 = $Pumpkins/Pumpkin1.position
		FarmSave.PumPos2 = $Pumpkins/Pumpkin2.position
		FarmSave.PumPos3 = $Pumpkins/Pumpkin3.position
		FarmSave.PumPos4 = $Pumpkins/Pumpkin4.position
		FarmSave.PumPos5 = $Pumpkins/Pumpkin5.position
		FarmSave.PumPos6 = $Pumpkins/Pumpkin6.position
		FarmSave.entered = true
		
	else:
		$Pumpkins/Pumpkin0.state = FarmSave.PumState0
		$Pumpkins/Pumpkin1.state = FarmSave.PumState1
		$Pumpkins/Pumpkin2.state = FarmSave.PumState2
		$Pumpkins/Pumpkin3.state = FarmSave.PumState3
		$Pumpkins/Pumpkin4.state = FarmSave.PumState4
		$Pumpkins/Pumpkin5.state = FarmSave.PumState5
		$Pumpkins/Pumpkin6.state = FarmSave.PumState6
		$Pumpkins/Pumpkin0.position = FarmSave.PumPos0
		$Pumpkins/Pumpkin1.position = FarmSave.PumPos1
		$Pumpkins/Pumpkin2.position = FarmSave.PumPos2
		$Pumpkins/Pumpkin3.position = FarmSave.PumPos3
		$Pumpkins/Pumpkin4.position = FarmSave.PumPos4
		$Pumpkins/Pumpkin5.position = FarmSave.PumPos5
		$Pumpkins/Pumpkin6.position = FarmSave.PumPos6


func _on_travel_back_area_entered(area: Area2D) -> void:
	''' Travel back to town '''
	transition('west')
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/town.tscn")


func _on_pumpkin_plot_pumpkin_added() -> void:
	''' pumpkin added to pumpkin plot '''
	FarmSave.num_pumpkins += 1
	if not FarmSave.first_placed:
		FarmSave.first_placed = true
		await get_tree().create_timer(.5).timeout
		first_placed.emit()
		camera_control.emit($NPCs/FarmerNPC2.global_position - Vector2(30, 0))
		await get_tree().create_timer(5).timeout
		camera_end.emit()
	if FarmSave.num_pumpkins == 6 and not FragmentHandler.east_complete:
		var fragment_instance = fragment.instantiate()
		add_child(fragment_instance)
		fragment_instance.global_position = $FragmentSpawnLocation.position
		FragmentHandler.east_complete = true
		FragmentHandler.east_spawned = true
		fragment_instance.collected.connect(on_collected)

func on_collected(item):
	''' send signal to player that item was collected '''
	fragment_collected.emit(item)

func _on_pumpkin_plot_pumpkin_removed() -> void:
	FarmSave.num_pumpkins -= 1


func transition(direction : String):
	''' transition out of farm area '''
	$TransitionRect.show()
	$TransitionRect/AnimationPlayer.play('Fade')
	traveling.emit(direction)

func reverse_transition(direction : String):
	''' transition into farm area '''
	$ReverseTransitionRect.show()
	$ReverseTransitionRect/AnimationPlayer.play('Fade')
	traveling.emit(direction)


func open_gates():
	''' open tutorial area gate '''
	$Fences/FenceSide/Sprite2D.hide()
	$Fences/FenceSide/CollisionShape2D.set_deferred('disabled', true)
	FragmentHandler.east_opened = true


func bucket_spawn():
	''' spawn the water bucket '''
	if not FragmentHandler.bucket_collected:
		var bucket = bucket_load.instantiate()
		add_child(bucket)
		bucket.global_position = $BucketLocation.position
		bucket.collected.connect(on_collected)
	
	
# pumpkin state saving functions
func _on_pumpkin_0_placed(pos) -> void:
	''' Save new pumpkin position '''
	FarmSave.PumPos0 = pos

func _on_pumpkin_0_watered(state) -> void:
	''' Save new pumpkin state '''
	FarmSave.PumState0 = state
	first_watered.emit()

func _on_pumpkin_0_weeded(state) -> void:
	''' Save new pumpkin state '''
	FarmSave.PumState0 = state
	first_weeded.emit()

func _on_pumpkin_1_placed(pos) -> void:
	''' Save new pumpkin position '''
	FarmSave.PumPos1 = pos

func _on_pumpkin_1_watered(state) -> void:
	''' Save new pumpkin state '''
	FarmSave.PumState1 = state

func _on_pumpkin_1_weeded(state) -> void:
	''' Save new pumpkin state '''
	FarmSave.PumState1 = state

func _on_pumpkin_2_placed(pos) -> void:
	''' Save new pumpkin position '''
	FarmSave.PumPos2 = pos

func _on_pumpkin_2_watered(state) -> void:
	''' Save new pumpkin state '''
	FarmSave.PumState2 = state

func _on_pumpkin_2_weeded(state) -> void:
	''' Save new pumpkin state '''
	FarmSave.PumState2 = state

func _on_pumpkin_3_placed(pos) -> void:
	''' Save new pumpkin position '''
	FarmSave.PumPos3 = pos

func _on_pumpkin_3_watered(state) -> void:
	''' Save new pumpkin state '''
	FarmSave.PumState3 = state

func _on_pumpkin_3_weeded(state) -> void:
	''' Save new pumpkin state '''
	FarmSave.PumState3 = state

func _on_pumpkin_4_placed(pos) -> void:
	''' Save new pumpkin position '''
	FarmSave.PumPos4 = pos

func _on_pumpkin_4_watered(state) -> void:
	''' Save new pumpkin state '''
	FarmSave.PumState4 = state

func _on_pumpkin_4_weeded(state) -> void:
	''' Save new pumpkin state '''
	FarmSave.PumState4 = state

func _on_pumpkin_5_placed(pos) -> void:
	''' Save new pumpkin position '''
	FarmSave.PumPos5 = pos

func _on_pumpkin_5_watered(state) -> void:
	''' Save new pumpkin state '''
	FarmSave.PumState5 = state

func _on_pumpkin_5_weeded(state) -> void:
	''' Save new pumpkin state '''
	FarmSave.PumState5 = state
	
func _on_pumpkin_6_placed(pos) -> void:
	''' Save new pumpkin position '''
	FarmSave.PumPos6 = pos

func _on_pumpkin_6_watered(state) -> void:
	''' Save new pumpkin state '''
	FarmSave.PumState6 = state

func _on_pumpkin_6_weeded(state) -> void:
	''' Save new pumpkin state '''
	FarmSave.PumState6 = state
