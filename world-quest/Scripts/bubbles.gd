extends RigidBody2D
var target_position: Vector2
var speed: float = 30.0
var player_position
@onready var bub_animation = $bub_animation
@onready var player = get_parent().get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$bub_animation.play()
	target_position = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	player_position = player.position
	target_position = (player_position - position).normalized()
	move_and_collide(target_position * speed)
