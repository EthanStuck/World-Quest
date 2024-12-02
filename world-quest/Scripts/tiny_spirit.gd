extends Node2D
@export var speed = 75

func _ready():
	$Animations.z_index = position.y + 9
	$Animations.play('run')
	$Sound.play()

func _process(delta):
	position += Vector2(1,0) * speed  * delta
