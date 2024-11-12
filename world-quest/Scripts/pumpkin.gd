extends StaticBody2D
var state : int # handles how healthy the pumpkin is
var interactable = false
var in_zone = false
@onready var spirit_load = preload("res://Scenes/tiny_spirit.tscn")
@onready var leaf_load = preload("res://Scenes/leaf.tscn")
signal weeded
signal watered
var picked_up = false
var pickupable = false

func _ready():
	$Sprites.z_index = position.y + 30
	if not FragmentHandler.east_complete:
		$Sprites.play('weeded')
		state = 0
	else:
		$Sprites.play('alive')
		state = 3

func _process(delta):

	if interactable:
		if Input.is_action_just_pressed('interact'):
			if state == 0 or state == 1:
				deweed()
			elif state == 2:
				revive()
			elif state == 3:
				picked_up = true
				hide()
				$CollisionShape2D.disabled = true
				$InteractZone/CollisionShape2D.disabled = true

func deweed():
	''' Remove layer of weeds from pumpkin '''
	interactable = false
	if state == 0:
		await get_tree().create_timer(2).timeout
		var leaf = leaf_load.instantiate()
		get_parent().add_child(leaf)
		leaf.global_position = global_position
		leaf.z_index = position.y + 31
		$Sprites.play('weeded2')
		state = 1
	elif state == 1:
		await get_tree().create_timer(2).timeout
		var leaf = leaf_load.instantiate()
		get_parent().add_child(leaf)
		leaf.global_position = global_position
		leaf.z_index = position.y + 31
		$Sprites.play('dead')
		state = 2
		$InteractZone.remove_from_group('weed')
		$InteractZone.add_to_group('dead_plant')
		weeded.emit()
	if in_zone:
		interactable = true

func revive():
	''' Restore life to pumpkin '''
	interactable = false
	if state == 2:
		await get_tree().create_timer(2).timeout
		$Sprites.play('alive')
		var spirit = spirit_load.instantiate()
		get_parent().add_child(spirit)
		spirit.global_position = global_position
		$InteractZone.remove_from_group('dead_plant')
		$InteractZone.add_to_group('pumpkin')
		state = 3
		watered.emit()
	if in_zone:
		interactable = true

#func placed(pos):
	#show()
	#$CollisionShape2d.disabled = false
	#$InteractZone/CollisionShape2D.disabled = false
	#position = pos

func _on_interact_zone_area_entered(area: Area2D) -> void:
	if area.is_in_group('player_zone'):
		interactable = true
		in_zone = true


func _on_interact_zone_area_exited(area: Area2D) -> void:
	if area.is_in_group('player_zone'):
		interactable = false
		in_zone = false
		


func _on_player_place(pos) -> void:
	if picked_up and pickupable:
		show()
		$CollisionShape2D.disabled = false
		$InteractZone/CollisionShape2D.disabled = false
		position = pos
		picked_up = false


func _on_player_pickup() -> void:
	pickupable = true
