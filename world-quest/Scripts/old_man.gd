extends StaticBody2D
@onready var text_bubble = $TextureRect

func _ready():
	$StaticBody2D/Sprite2D.z_index = position.y + 32
	text_bubble.visible = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Entered")
	if body is CharacterBody2D:
		text_bubble.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		text_bubble.visible = false
