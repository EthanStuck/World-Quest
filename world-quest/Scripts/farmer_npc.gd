extends Area2D

func _ready():
	$Sprite2D.z_index = position.y + 32
