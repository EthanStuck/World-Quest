extends StaticBody2D
@onready var text_bubble1 = $TextureRect
@onready var text_bubble2 = $TextureRect2
var interactable = false
var progress = -1

func _ready():
	$Sprite2D.z_index = position.y + 32
	text_bubble1.visible = true
	text_bubble2.visible = false
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
		progress = 0


func toggle_text():
	if interactable:
		if progress == -1:
			text_bubble1.visible = false
			text_bubble2.visible = true
			$Speech.play()
			progress = 1
		elif progress == 0:
			text_bubble2.visible = true
			$Speech.play()
			progress = 1
		else:
			text_bubble2.visible = false
			progress = 0
