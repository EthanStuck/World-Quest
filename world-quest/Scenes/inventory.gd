extends Node
var inventory = {}
@onready var inventory_container = $VBoxContainer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func add_item(item_name: String):
	if inventory.has(item_name):
		inventory[item_name] += 1  # Increase the count if the item already exists
	else:
		inventory[item_name] = 1  # Add a new item with count 1
	update_inventory_display()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func update_inventory_display():
	# Clear the old labels
	inventory_container.clear()
	
	# Add a label for each item in the inventory
	for item_name in inventory.keys():
		var label = Label.new()  # Create a new Label
		label.text = item_name + ": " + str(inventory[item_name])  # Set text to item name and count
		inventory_container.add_child(label)  # Add the label to the VBoxContainer
