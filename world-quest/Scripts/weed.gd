extends StaticBody2D
@onready var carrot1 = preload("res://Scenes/carrot_earthed_1.tscn")
@onready var carrot2 = preload("res://Scenes/carrot_earthed_2.tscn")
@onready var carrot3 = preload("res://Scenes/carrot_earthed_3.tscn")
var interactable = false

func _ready():
	$Sprite2D.z_index = position.y

func _process(delta):
	if Input.is_action_just_pressed('interact'):
		deweed()


func deweed():
	''' remove the weed and make a carrot in its place '''
	if interactable:
		await get_tree().create_timer(0.5).timeout
		queue_free()
		var num = int(randf_range(1,3))
		if num == 1:
			var carrot = carrot1.instantiate()
			get_parent().add_child(carrot)
			carrot.global_position = global_position
		elif num == 2:
			var carrot = carrot2.instantiate()
			get_parent().add_child(carrot)
			carrot.global_position = global_position
		else:
			var carrot = carrot3.instantiate()
			get_parent().add_child(carrot)
			#carrot.global_position = position



func _on_interact_zone_body_entered(body: Node2D) -> void:
	''' player in interact zone '''
	interactable = true


func _on_interact_zone_body_exited(body: Node2D) -> void:
	''' player not in interact zone '''
	interactable = false
