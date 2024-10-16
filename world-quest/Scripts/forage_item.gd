extends Area2D

@export var item: InvItem
signal collected
var player = null

func _ready():
	player = get_parent().get_node("Player") 
func _on_area_entered(area: Area2D) -> void:
	''' become collected '''
	if area.is_in_group("Player"):  # Ensure the area entered is the player
		collect(item)
		collected.emit()
		queue_free()
	

func collect(item):
	# Ensure player is valid before calling collect
	if player != null and player.inv != null:
		player.inv.insert(item)  # Call player's inventory insert method
		player.collect(item)  # Call the collect method on the player
	else:
		print("Player reference is missing!")
