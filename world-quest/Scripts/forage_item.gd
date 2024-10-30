extends Area2D

@export var item: InvItem
signal collected
var player = null

func _ready():
	player = get_parent().get_node("Player") 
func _on_area_entered(area: Area2D) -> void:
	''' become collected '''
	if area.is_in_group("Player"):  # Ensure the area entered is the player
		player = area
		collected.emit()
		#$PickupSound.play()
		queue_free()
	
func drop_item():
	player.collect(item)
