extends StaticBody2D

func _ready():
	$FullSprite.z_index = position.y
