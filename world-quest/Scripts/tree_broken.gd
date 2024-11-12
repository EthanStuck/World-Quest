extends StaticBody2D
var conditional
@onready var tree_load = preload('res://Scenes/tree.tscn')

func _ready():
	z_index = position.y + 100
	
	print(get_tree().current_scene.to_string())
	if get_tree().current_scene.to_string() == 'Town:<Node#55750690063>':
		conditional = FragmentHandler.game_complete
	elif get_tree().current_scene.to_string() == 'Fishing:<Node#43738203407>':
		conditional = FragmentHandler.north_complete
	elif get_tree().current_scene.to_string() == 'Fight:<Node#46690993423>':
		conditional = FragmentHandler.west_complete
	elif get_tree().current_scene.to_string() == 'Farm:<Node#55381591311>':
		conditional = FragmentHandler.east_complete
	elif get_tree().current_scene.to_string() == 'Forage:<Node#47999616271>':
		conditional = FragmentHandler.south_complete
	
	if conditional:
		var tree = tree_load.instantiate()
		get_parent().add_child(tree)
		tree.global_position = global_position
		tree.z_index = position.y + 100

		
