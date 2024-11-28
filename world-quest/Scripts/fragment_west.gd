extends Area2D

@export var item: InvItem
var player = null
var interactable = false
signal collected
var destination = global_position
var wait = true
var direction
var vel
const speed = 50
var giving = false


func _ready():
	$BaseSprite.z_index = position.y + 10
	$GlowSprite.z_index = position.y + 13
	$Glow.play()
	$SpawnSound.play()
	$InteractLabel.hide()
	await get_tree().create_timer(1).timeout
	wait = false


func _process(delta):
	if interactable:
		if Input.is_action_just_pressed('interact'):
			FragmentHandler.west_fragment = true
			FragmentHandler.west_spawned = false
			playercollect()
			$PickupSound.play()
			await get_tree().create_timer(0.1).timeout
			collected.emit('west')
			self.queue_free()
	if abs(destination - global_position) > Vector2.ZERO and not wait:
		giving = true
		direction = (destination - global_position).normalized()
		vel = (direction * speed)
		#linear_velocity = (direction.normalized() * speed)
		#move_and_collide(direction.normalized() * speed)
		global_position += vel * delta
		dequeue()

func _on_interactable_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		interactable = true
		$InteractLabel.show()

func _on_timer_timeout() -> void:
	''' delay until player can interact with fragment '''
	$CollisionShape2D.disabled = false
	$GlowSprite.hide()

func playercollect():
	''' add to player inventory '''
	player.collect(item)


func _on_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		interactable = false
		$InteractLabel.hide()

func dequeue():
	''' despawn fragment '''
	await get_tree().create_timer(4).timeout
	queue_free()
