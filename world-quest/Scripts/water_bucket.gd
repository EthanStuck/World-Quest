extends Area2D

@export var item: InvItem
var player = null


func _on_interactable_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		playercollect()
		$PickupSound.play()
		await get_tree().create_timer(0.1).timeout
		self.queue_free()
		FragmentHandler.bucket_collected = true

func playercollect():
	player.collect(item)
