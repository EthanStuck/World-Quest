extends StaticBody2D

func _ready():
	$Sprite2D.z_index = 1
	$FenceTop.z_index = position.y - 63
	$FenceSides.z_index = 2
	$FenceBottom.z_index = position.y + 92
