extends Area2D

signal fragment()

@onready var player = get_parent().get_node("Player")

func _ready():
	$CollisionShape2D.disabled = true
	
func _on_area_entered(area: Area2D) -> void:
	''' become collected '''
	FragmentHandler.west_fragment = true
	print('entered')
	queue_free()



func _on_timer_timeout() -> void:
	$CollisionShape2D.disabled = false
