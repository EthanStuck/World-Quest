extends Node2D
var end

# end position y = -100

func _ready():
	$Music.play()
	FragmentHandler.at = 'town'
	
func _process(delta):
	if not end:
		$Sprite2D.position.y -= 10 * delta
	if $Sprite2D.position.y <= -100:
		end = true
	if Input.is_action_just_pressed("menu") or Input.is_action_just_pressed("strike") or Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file("res://Scenes/town.tscn")
	

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/town.tscn")
