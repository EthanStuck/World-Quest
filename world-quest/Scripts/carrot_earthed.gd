extends Area2D

@export var item: InvItem
var player = null
var interactable = false

func _ready():
	$Sprite2D.z_index = position.y

func _process(delta):
	if Input.is_action_just_pressed('interact'):
		playercollect()


func playercollect():
	''' add carrot to player inventory '''
	if interactable:
		player.collect(item)
		$PickupSound.play()
		await get_tree().create_timer(0.1).timeout
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	''' player enters area '''
	if body.has_method("player"):
		player = body
		interactable = true


func _on_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
	''' player leaves area '''
	if body.has_method("player"):
		player = body
		interactable = false
