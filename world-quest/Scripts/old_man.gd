extends StaticBody2D
@onready var text_bubble = $TextureRect
@onready var text_bubble2 = $TextureRect2
@onready var text_bubble3 = $TextureRect3
@onready var text_bubble4 = $TextureRect4
var interactable = false
signal camera_control
signal camera_end
signal sword_spawn
signal spirit_cam

func _ready():
	z_index = position.y + 32
	text_bubble.visible = false
	text_bubble2.visible = false
	text_bubble3.visible = false
	text_bubble4.visible = false
	$InteractLabel.visible = false
	if not FightSave.entered or not FragmentHandler.sword_pickup:
		await get_tree().create_timer(1.01).timeout
		intro_player()

func _process(delta):
	if Input.is_action_just_pressed('interact'):
		toggle_text()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		$InteractLabel.visible = true
		interactable = true

func intro_player():
	''' give player sword if they need it/ tell them to use it '''
	camera_control.emit(global_position + Vector2(30, 0))
	text_bubble2.visible = true
	$Speech.play()
	await get_tree().create_timer(2).timeout
	spirit_cam.emit(global_position + Vector2(30, 0))
	text_bubble2.visible = false
	await get_tree().create_timer(1.5).timeout
	if FragmentHandler.sword_pickup:
		text_bubble3.visible = true
		$Speech.play()
	else:
		text_bubble4.visible = true
		$Speech.play()
		await get_tree().create_timer(.5).timeout
		sword_spawn.emit(global_position + Vector2(0, 50))
		$PickupSound.play()
	await get_tree().create_timer(2).timeout
	text_bubble3.visible = false
	text_bubble4.visible = false
	camera_end.emit()
	
	


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$InteractLabel.visible = false
		interactable = false
		text_bubble.visible = false
		text_bubble2.visible = false
		text_bubble3.visible = false
		text_bubble4.visible = false


func toggle_text():
	if interactable:
		if not text_bubble.visible:
			text_bubble.visible = true
			$Speech.play()
		else:
			text_bubble.visible = false
