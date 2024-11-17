extends Area2D

@export var item: InvItem
var player = null
var interactable = false

func _ready():
	$InteractLabel.hide()
	z_index = position.y + 14


func _on_interactable_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		interactable = true
		$InteractLabel.show()
		
func playercollect():
	player.collect(item)


func _process(delta):
	if interactable:
		if Input.is_action_just_pressed('interact'):
			playercollect()
			$PickupSound.play()
			await get_tree().create_timer(0.1).timeout
			self.queue_free()

func _on_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		interactable = false
		$InteractLabel.hide()
