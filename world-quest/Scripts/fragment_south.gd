extends Area2D

@export var item: InvItem
var player = null

func _ready():
	$BaseSprite.z_index = position.y + 7
	$GlowSprite.z_index = position.y + 10
	$Glow.play()
	$SpawnSound.play()

func _on_interactable_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		FragmentHandler.south_fragment = true
		player = body
		playercollect()
		$PickupSound.play()
		await get_tree().create_timer(0.1).timeout
		self.queue_free()

func _on_timer_timeout() -> void:
	''' delay until player can interact with fragment '''
	$CollisionShape2D.disabled = false
	$GlowSprite.hide()

func playercollect():
	''' add to player inventory '''
	player.collect(item)
