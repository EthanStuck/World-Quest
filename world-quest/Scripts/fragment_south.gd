extends Area2D

@export var item: InvItem
var player = null

func _ready():
	$BaseSprite.z_index = position.y + 7
	$GlowSprite.z_index = position.y + 10

#func _on_area_entered(area: Area2D) -> void:
	#''' gets collected '''
	#FragmentHandler.west_fragment = true
	#$PickupSound.play()
	#await get_tree().create_timer(0.1).timeout
	#queue_free()

func _on_timer_timeout() -> void:
	''' delay until player can interact with fragment '''
	$CollisionShape2D.disabled = false
	$GlowSprite.hide()

func playercollect():
	''' add to player inventory '''
	player.collect(item)
	#pass


func _on_body_entered(body: Node2D) -> void:
	''' gets collected '''
	if body.has_method("player"):
		player = body
		playercollect()
		FragmentHandler.south_fragment = true
		$PickupSound.play()
		await get_tree().create_timer(0.1).timeout
		queue_free()
