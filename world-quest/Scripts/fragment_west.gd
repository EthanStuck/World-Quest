extends Area2D

@export var item: InvItem
var player = null

func _ready():
	$BaseSprite.z_index = position.y + 10
	$GlowSprite.z_index = position.y + 13


func _on_iiinteractable_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		FragmentHandler.west_fragment = true
		player = body
		playercollect()
		await get_tree().create_timer(0.1).timeout
		self.queue_free()

func _on_timer_timeout() -> void:
	''' delay until player can interact with fragment '''
	$CollisionShape2D.disabled = false
	$GlowSprite.hide()

func playercollect():
	''' add to player inventory '''
	player.collect(item)
