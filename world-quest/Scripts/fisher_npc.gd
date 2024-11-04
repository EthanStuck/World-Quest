extends StaticBody2D
@onready var text_bubble = $TextureRect
var interactable = false

func _ready():
	$Sprite2D.z_index = position.y + 32
	text_bubble.visible = false
	$InteractLabel.visible = false

func _process(delta):
	if Input.is_action_just_pressed('interact'):
		toggle_text()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		$InteractLabel.visible = true
		interactable = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$InteractLabel.visible = false
		interactable = false
		text_bubble.visible = false


func toggle_text():
	if interactable:
		if not text_bubble.visible:
			text_bubble.visible = true
		else:
			text_bubble.visible = false
