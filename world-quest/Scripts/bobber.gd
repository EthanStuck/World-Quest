extends Area2D

var target_position : Vector2  # Target position to move towards

func _ready() -> void:
	$Bobber_animation.play()

# Set the target position for the bubble to move towards
func set_target_position(position: Vector2):
	target_position = position

# Move the bobber towards the target position (the bobber floats towards the target)
func _process(delta):
	if target_position:
		var direction = (target_position - position).normalized()  # Get direction to target
		position += direction * 2 * delta  # Move bobber towards the target
