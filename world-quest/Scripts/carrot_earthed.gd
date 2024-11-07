extends Area2D

@export var item: InvItem
var player = null
var interactable = false
var dead

func _ready():
	# these are broken rn for some reason
	#$FullSprite.z_index = position.y
	#$DeadSprite.z_index = position.y
	$FullSprite.z_index = 5
	$DeadSprite.z_index = 5
	if not FragmentHandler.east_complete:
		$FullSprite.hide()
		dead = true
	else:
		$DeadSprite.hide()
		dead = false

func _process(delta):
	if Input.is_action_just_pressed('interact'):
		if dead:
			water_plant()
		else:
			playercollect()


func playercollect():
	''' add carrot to player inventory '''
	if interactable:
		player.collect(item)
		$PickupSound.play()
		await get_tree().create_timer(0.1).timeout
		queue_free()
		FragmentHandler.num_carrots += 1

func water_plant():
	''' water the plant '''
	if interactable:
		dead = false
		remove_from_group('dead_plant')
		await get_tree().create_timer(1).timeout
		$DeadSprite.hide()
		$FullSprite.show()

func _on_body_entered(body: Node2D) -> void:
	''' player enters area '''
	if body.has_method("player"):
		player = body
		interactable = true


func _on_body_exited(body: Node2D) -> void:
	''' player leaves area '''
	if body.has_method("player"):
		player = body
		interactable = false
