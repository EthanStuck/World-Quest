extends Area2D

@export var item: InvItem
var player = null
var interactable = false
signal collected

func _ready():
	z_index = position.y + 10
	$InteractLabel.hide()

func _on_interactable_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		interactable = true
		player = body
		$InteractLabel.show()

func playercollect():
	player.collect(item)


func _on_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		interactable = false
		$InteractLabel.hide()


func _process(delta):
	if interactable:
		if Input.is_action_just_pressed('interact'):
			playercollect()
			$PickupSound.play()
			await get_tree().create_timer(0.1).timeout
			FragmentHandler.bucket_collected = true
			collected.emit('bucket')
			self.queue_free()
