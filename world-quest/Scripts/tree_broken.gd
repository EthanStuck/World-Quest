extends StaticBody2D
var conditional
@onready var location = get_tree().current_scene.to_string()

func _ready():
	z_index = position.y + 100
	
	if location.contains('Town'):
		conditional = FragmentHandler.game_complete
	elif location.contains('Fishing'):
		conditional = FragmentHandler.north_complete
	elif location.contains('Fight'):
		conditional = FragmentHandler.west_complete
	elif location.contains('Farm'):
		conditional = FragmentHandler.east_complete
	elif location.contains('Forage'):
		conditional = FragmentHandler.south_complete
	
	if conditional:
		$Grown.show()
		$Sprite2D.hide()


func area_finished():
	$Grown.show()
	$Sprite2D.hide()
