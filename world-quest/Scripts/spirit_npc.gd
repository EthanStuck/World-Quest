extends StaticBody2D

@onready var text_bubble1 = $TextureRect
@onready var text_bubble2 = $TextureRect2
@onready var text_bubble3 = $TextureRect3
@onready var text_bubble4 = $TextureRect4
@onready var text_bubble5 = $TextureRect5
@onready var text_bubble6 = $TextureRect6
var interactable = false
var progress = 0
var state = 0

func _ready():
	$AnimatedSprite2D.play('idle')
	z_index = position.y + 45
	text_bubble1.visible = false
	text_bubble2.visible = false
	text_bubble3.visible = false
	text_bubble4.visible = false
	text_bubble5.visible = false
	text_bubble6.visible = false
	$InteractLabel.visible = false

func _process(delta):
	if Input.is_action_just_pressed('interact'):
		toggle_text()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		$InteractLabel.visible = true
		interactable = true

func solved():
	''' player has earned fragment '''
	state = 1
	progress = 6
	text_bubble1.visible = false
	text_bubble2.visible = false
	text_bubble3.visible = false
	text_bubble4.visible = false
	text_bubble5.visible = false
	text_bubble6.visible = false

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$InteractLabel.visible = false
		interactable = false
		text_bubble1.visible = false
		text_bubble2.visible = false
		text_bubble3.visible = false
		text_bubble4.visible = false
		text_bubble5.visible = false
		text_bubble6.visible = false
		if state == 0:
			progress = 0
		elif state == 1:
			progress = 6


func toggle_text():
	if interactable:
		if progress == 0 and state == 0:
			text_bubble1.visible = true
			progress = 1
		elif progress == 1 and state == 0:
			text_bubble2.visible = true
			text_bubble1.visible = false
			progress = 2
		elif progress == 2 and state == 0:
			text_bubble2.visible = false
			text_bubble3.visible = true
			progress = 3
		elif progress == 3 and state == 0:
			text_bubble3.visible = false
			text_bubble4.visible = true
			progress = 4
		elif progress == 4 and state == 0:
			text_bubble4.visible = false
			text_bubble5.visible = true
			progress = 5
		elif progress == 5 and state == 0:
			text_bubble5.visible = false
			progress = 0
		elif progress == 6 and state == 1:
			text_bubble6.visible = true
			progress = 7
		elif progress == 7 and state == 1:
			text_bubble6.visible = false
			progress = 6
