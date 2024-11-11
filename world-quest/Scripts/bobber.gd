extends Area2D

@onready var bobber = $Bobber_animation  # Assuming Bobber has a Sprite node

var target_position: Vector2

func _ready() -> void:
	$Bobber_animation.play()
	
# Function to set the target position (used by bubbles)
func set_target_position(position: Vector2) -> void:
	target_position = position
