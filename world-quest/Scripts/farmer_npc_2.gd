extends StaticBody2D
@onready var text_bubble_intro = $TextureRect
@onready var text_bubble_intro2 = $TextureRect2
@onready var text_bubble1 = $TextureRect3
@onready var text_bubble2 = $TextureRect4
@onready var text_bubble3 = $TextureRect5
@onready var text_bubble4 = $TextureRect6
@onready var text_bubble5 = $TextureRect7
@onready var text_bubble6 = $TextureRect8
@onready var text_bubble7 = $TextureRect9
@onready var text_bubble8 = $TextureRect10
@onready var text_bubble9 = $TextureRect11
@onready var text_bubble10 = $TextureRect12
@onready var text_bubble11 = $TextureRect13
var interactable = false
var progress = 0
var state = 0
signal shake
signal bucket_spawn
signal open_gates
var bucket_spawned = false
var gates_open = false
signal camera_control
signal camera_end

func _ready():
	# hide all text bubbles
	text_bubble_intro.visible = false
	text_bubble_intro2.visible = false
	text_bubble1.visible = false
	text_bubble2.visible = false
	text_bubble3.visible = false
	text_bubble4.visible = false
	text_bubble5.visible = false
	text_bubble6.visible = false
	text_bubble7.visible = false
	text_bubble8.visible = false
	text_bubble9.visible = false
	text_bubble10.visible = false
	text_bubble11.visible = false
	
	# handle rest of text bubbles
	$InteractLabel.visible = false
	$Sprites.z_index = position.y + 32
	if not FragmentHandler.east_complete:
		intro()
	else:
		$Sprites.play('stand')
	
	if FragmentHandler.east_complete and not FragmentHandler.game_complete:
		state = 4
		text_bubble9.visible = true
		progress = 13
	
	if FragmentHandler.game_complete:
		state = 5
		text_bubble10.visible = true
		progress = 15


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
		text_bubble4.visible = false
		text_bubble5.visible = false
		text_bubble6.visible = false
		text_bubble7.visible = false
		text_bubble8.visible = false
		text_bubble9.visible = false
		text_bubble10.visible = false
		text_bubble11.visible = false
		if state == 0:
			progress == 0
		elif state == 1:
			progress = 5
		elif state == 2:
			progress = 7
		elif state == 3:
			progress = 10

func intro():
	''' play intro cutscene '''
	$Sprites.play('pull')
	await get_tree().create_timer(1).timeout
	camera_control.emit(global_position - Vector2(30,0))
	text_bubble_intro.visible = true
	$Speech.play()
	await get_tree().create_timer(3).timeout
	shake.emit()
	$FallSound.play()
	text_bubble_intro.visible = false
	text_bubble_intro2.visible = true
	$Speech.play()
	$Sprites.play('sit')
	position.x -= 40
	camera_control.emit(global_position - Vector2(30,0))
	await get_tree().create_timer(4).timeout
	$Sprites.play('stand')
	text_bubble_intro2.visible = false
	await get_tree().create_timer(1).timeout
	camera_end.emit()
	text_bubble1.visible = true
	$Speech.play()
	

func weed_pulled():
	''' trigger when player pulls weeds off first pumpkin '''
	await get_tree().create_timer(.25).timeout
	camera_control.emit(global_position - Vector2(30,0))
	text_bubble_intro.visible = false
	text_bubble_intro2.visible = false
	text_bubble1.visible = false
	text_bubble2.visible = false
	text_bubble3.visible = false
	text_bubble4.visible = false
	progress = 6
	text_bubble5.visible = true
	$Speech.play()
	state = 1
	await get_tree().create_timer(2).timeout
	if not bucket_spawned:
		bucket_spawned = true
		bucket_spawn.emit()
		$PickupSound.play()
	await get_tree().create_timer(2).timeout
	camera_end.emit()
	
func watered():
	''' triggered when player waters the first pumpkin '''
	await get_tree().create_timer(.25).timeout
	camera_control.emit(global_position - Vector2(30,0))
	progress = 8
	text_bubble6.visible = true
	text_bubble5.visible = false
	$Speech.play()
	state = 2
	await get_tree().create_timer(4).timeout
	progress = 9
	text_bubble6.visible = false
	text_bubble7.visible = true
	$Speech.play()
	await get_tree().create_timer(2).timeout
	if not gates_open:
		var gate_position = get_parent().get_parent().get_node('Fences').get_node('FenceSide').global_position
		camera_control.emit(gate_position - Vector2(250,0))
		await get_tree().create_timer(1).timeout
		open_gates.emit()
		gates_open = true
	await get_tree().create_timer(2).timeout
	camera_end.emit()
	
func first_placed():
	''' triggered when player places first pumpkin in the area '''
	text_bubble1.visible = false
	text_bubble2.visible = false
	text_bubble3.visible = false
	text_bubble4.visible = false
	text_bubble5.visible = false
	text_bubble6.visible = false
	text_bubble7.visible = false
	text_bubble8.visible = false
	text_bubble9.visible = false
	text_bubble10.visible = false
	text_bubble11.visible = true
	await get_tree().create_timer(4).timeout
	text_bubble11.visible = false
	
func completed():
	''' triggered when player brings all pumpkins to the area '''
	text_bubble6.visible = false
	text_bubble7.visible = false
	progress = 10
	#text_bubble8.visible = true
	#$Speech.play()
	state = 3
	
func toggle_text():
	if interactable:
		if progress == 0:
			text_bubble1.visible = true
			$Speech.play()
			progress = 1
		elif progress == 1:
			text_bubble1.visible = false
			text_bubble2.visible = true
			$Speech.play()
			progress = 2
		elif progress == 2:
			text_bubble2.visible = false
			text_bubble3.visible = true
			$Speech.play()
			progress = 3
		elif progress == 3:
			text_bubble3.visible = false
			text_bubble4.visible = true
			$Speech.play()
			progress = 4
		elif progress == 4:
			text_bubble4.visible = false
			progress = 0
		elif progress == 5:
			text_bubble5.visible = true
			$Speech.play()
			progress = 6
		elif progress == 6:
			text_bubble5.visible = false
			progress = 5
		elif progress == 7:
			text_bubble6.visible = true
			$Speech.play()
			progress = 8
		elif progress == 8:
			text_bubble6.visible = false
			text_bubble7.visible = true
			$Speech.play()
			progress = 9
		elif progress == 9:
			text_bubble7.visible = false
			progress = 7
		elif progress == 10:
			text_bubble8.visible = true
			$Speech.play()
			progress = 11
		elif progress == 11:
			text_bubble8.visible = false
			progress = 10
		elif progress == 12:
			text_bubble9.visible = true
			$Speech.play()
			progress = 13
		elif progress == 13:
			text_bubble9.visible = false
			progress = 12
		elif progress == 14:
			text_bubble10.visible = true
			$Speech.play()
			progress = 15
		elif progress == 15:
			text_bubble10.visible = false
			progress = 14
