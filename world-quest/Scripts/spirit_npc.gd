extends StaticBody2D

@onready var text_bubble1 = $TextureRect
@onready var text_bubble2 = $TextureRect2
@onready var text_bubble3 = $TextureRect3
@onready var text_bubble4 = $TextureRect4
@onready var text_bubble5 = $TextureRect5
@onready var text_bubble6 = $TextureRect6
@onready var text_bubble7 = $TextureRect7
var interactable = false
var progress = 0
var state = 0
signal camera_control
signal camera_end

func _ready():
	$AnimatedSprite2D.play('idle')
	z_index = position.y + 45
	text_bubble1.visible = false
	text_bubble2.visible = false
	text_bubble3.visible = false
	text_bubble4.visible = false
	text_bubble5.visible = false
	text_bubble6.visible = false
	text_bubble7.visible = false
	$InteractLabel.visible = false

func _process(delta):
	if Input.is_action_just_pressed('interact'):
		toggle_text()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		$InteractLabel.visible = true
		interactable = true

func intro():
	''' introduce player to area '''
	text_bubble7.visible = true
	camera_control.emit(global_position - Vector2(30,0))
	$Speech.play()
	await get_tree().create_timer(2).timeout
	camera_end.emit()
	text_bubble7.visible = false

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
			$Speech.play()
			progress = 1
		elif progress == 1 and state == 0:
			text_bubble2.visible = true
			text_bubble1.visible = false
			$Speech.play()
			progress = 2
		elif progress == 2 and state == 0:
			text_bubble2.visible = false
			text_bubble3.visible = true
			$Speech.play()
			progress = 3
		elif progress == 3 and state == 0:
			text_bubble3.visible = false
			text_bubble4.visible = true
			$Speech.play()
			progress = 4
		elif progress == 4 and state == 0:
			text_bubble4.visible = false
			text_bubble5.visible = true
			$Speech.play()
			progress = 5
		elif progress == 5 and state == 0:
			text_bubble5.visible = false
			progress = 0
		elif progress == 6 and state == 1:
			text_bubble6.visible = true
			$Speech.play()
			progress = 7
		elif progress == 7 and state == 1:
			text_bubble6.visible = false
			progress = 6
