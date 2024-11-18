extends RigidBody2D

@export var bubble_speed : float = 60.0  # Speed at which the bubble moves
var target_position : Vector2  # The position to which the bubble moves

func _ready() -> void:
	$bub_animation.play()
	$BubbleSound.play()
	
# Set the target position for the bubble to move towards
func set_target_position(position: Vector2):
	target_position = position

# Move the bubble towards the target position
func _process(delta):
	if target_position:
		var direction = (target_position - position).normalized()  # Get direction to target
		position += direction * bubble_speed * delta  # Move the bubble towards the target
