extends StaticBody2D
@onready var text_bubble1 = $TextureRect
@onready var text_bubble2 = $TextureRect2
@onready var text_bubble3 = $TextureRect3
var interactable = false
var progress = 0

func _ready():
	$Sprite2D.z_index = position.y + 32
	text_bubble1.visible = false
	text_bubble2.visible = false
	text_bubble3.visible = false
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
		text_bubble1.visible = false
		text_bubble2.visible = false
		text_bubble3.visible = false
		progress = 0


func toggle_text():
	if interactable:
		if progress == 0:
			text_bubble1.visible = true
			progress = 1
		elif progress == 1:
			text_bubble1.visible = false
			text_bubble2.visible = true
			progress = 2
		elif progress == 2:
			text_bubble2.visible = false
			text_bubble3.visible = true
			progress = 3
		elif progress == 3:
			text_bubble3.visible = false
			progress = 0
