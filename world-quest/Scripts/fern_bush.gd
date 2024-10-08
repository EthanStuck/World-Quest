extends StaticBody2D

func _ready():
	$Sprite2D.z_index = position.y + 15
