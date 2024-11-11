extends Area2D

@export var item: InvItem
var player = null

func _ready():
	$BaseSprite.z_index = position.y + 10
	$GlowSprite.z_index = position.y + 13
	$Glow.play()
	$SpawnSound.play()

#func _on_area_entered(area: Area2D) -> void:
	#''' gets collected '''
	#FragmentHandler.north_fragment = true
	#$PickupSound.play()
	#await get_tree().create_timer(0.1).timeout
	#queue_free()


func _on_timer_timeout() -> void:
	''' delay until player can interact with fragment '''
	$CollisionShape2D.disabled = false
	$GlowSprite.hide()

func _on_interactable_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		FragmentHandler.north_fragment = true
		player = body
		playercollect()
		await get_tree().create_timer(0.1).timeout
		self.queue_free()


func playercollect():
	''' add to player inventory '''
	player.collect(item)
