extends Node
var currentWave: int


func _ready():
	''' player startup '''
	#screen_size = get_viewport_rect().size
	$fight_music.play()
	
func _on_travel_back_area_entered(area: Area2D) -> void:
	''' Travel back to town '''
	get_tree().change_scene_to_file("res://Scenes/town.tscn")
	
#func firstWaveOver():
	
