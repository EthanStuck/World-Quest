extends Node

@export var cast_range : float = 150.0
@export var bubble_count : int = 1  # Number of bubbles that spawn
@export var catch_radius : float = 15.0
@export var cast_delay : float = 0.5  # Delay time to catch a fish

@onready var fragment = preload("res://Scenes/fragment_north.tscn")
@onready var bobber_scene = preload("res://Scenes/bobber.tscn")  # Path to the bobber scene
@onready var bubble_scene = preload("res://Scenes/bubbles.tscn")  # Path to the bubble scene
@onready var rod_load = preload("res://Scenes/fishing_rod.tscn")
@onready var ui_text = $Label  # UI text for showing messages
@export var catfish_item: InvItem

var fish_caught : int = 0  # Number of fish caught
var is_casting : bool = false  # Whether the player has casted or not
var bobber : Node2D = null  # Reference to the bobber node
var frag : Area2D = null
var bubbles : Array = []  # List of bubbles currently in the scene
var bobbers : Array = []  # List of bobbers currently in the scene
var cast_timer : float = 0.0  # Timer to track cast delay
signal traveling
signal fragment_collected
signal camera_control
signal camera_end

func _ready() -> void:
	# playing music and water animation
	$PondSounds.play()
	$Water_animations/Animated_water.play()
	$Water_animations/Animated_water2.play()
	$Water_animations/Animated_water3.play()
	FragmentHandler.at = 'fishing'
	reverse_transition('north')
	fish_caught = FishSave.num_fish
	
	if not FragmentHandler.rod_pickup:
		var rod = rod_load.instantiate()
		add_child.call_deferred(rod)
		rod.global_position = $RodSpawn.position
		rod.collected.connect(on_collected)
	
	if FragmentHandler.north_spawned:
		frag = fragment.instantiate()
		frag.position = Vector2(505, 400)
		frag.destination = Vector2(505, 400)
		add_child.call_deferred(frag)
		FragmentHandler.north_complete = true
		FragmentHandler.north_spawned = true
		frag.collected.connect(on_collected)
		camera_control.emit(frag.global_position)
		await get_tree().create_timer(3).timeout
		camera_end.emit()

# Input event: listen for the cast action
func _input(event):
	if FragmentHandler.rod_pickup:
		if event.is_action_pressed("cast"):  # Check if the cast action was triggered
			if is_casting:
				check_for_fish()  # Check if fish is caught on second cast
				$CastSound.play()
				bobber.queue_free()
				await get_tree().create_timer(1.0).timeout
				$CastSound.stop()
			else:
				cast_bobber()  # Cast the bobber for the first time

# Cast the bobber and start the fishing process
func cast_bobber():
	is_casting = true
	cast_timer = cast_delay  # Reset the timer for the cast delay
	
	# Spawn the bobber at a random position in front of the player
	var spawn_position = Vector2(505, 359 - cast_range)
	spawn_position.x += randf_range(-60, 60)  # Randomize a little in x
	spawn_position.y += randf_range(-30, 30)  # Randomize a little in y
	
	bobber = bobber_scene.instantiate()  # Instantiate the bobber scene
	bobber.position = spawn_position  # Set its position
	add_child(bobber)  # Add bobber to the scene
	bobbers.append(bobber)  # Add bobber to the list
	
	# Spawn bubbles towards the bobber
	spawn_bubbles()

	# Update the UI text
	ui_text.text = "Wait for the bubbles to reach the bobber..."

# Spawn bubbles that move towards the bobber
func spawn_bubbles():
	bubbles.clear()  # Clear any old bubbles
	for _i in range(bubble_count):
		var bubble = bubble_scene.instantiate()  # Instantiate a bubble
		var random_position = $Player.position + Vector2(randf_range(-100, 100), randf_range(-100, 100))
		bubble.position = random_position  # Set its random position
		add_child(bubble)  # Add it to the scene
		bubble.set_target_position(bobber.position)  # Set the target position for each bubble
		bubbles.append(bubble)  # Add bubble to the list

# Check if the player catches a fish
func check_for_fish():
	is_casting = false  # Reset casting state
	var caught_fish = false  # Flag for whether a fish is caught
	
	# Check if any bubble is within the catch radius of the bobber
	for bubble in bubbles:
		if bobber.position.distance_to(bubble.position) <= catch_radius:
			caught_fish = true
			break  # Stop checking once we know the fish is caught

	# Handle the result of the cast
	if caught_fish:
		fish_caught += 1  # Increment the fish count
		FishSave.num_fish += 1
		ui_text.text = "You caught a fish!"
		$Player.collect(catfish_item)
	else:
		ui_text.text = "Try again!"

	# Remove all bubbles after the cast
	for bubble in bubbles:
		bubble.queue_free()

	# Check if the quest is complete (10 fish caught), spawns fragment
	if fish_caught >= 10 and not FragmentHandler.north_spawned:
		ui_text.text = "Quest Complete!"
		frag = fragment.instantiate()
		frag.position = Vector2(505, 400)
		frag.destination = Vector2(505, 400)
		add_child(frag)
		FragmentHandler.north_complete = true
		FragmentHandler.north_spawned = true
		frag.collected.connect(on_collected)
		camera_control.emit(frag.global_position)
		await get_tree().create_timer(3).timeout
		camera_end.emit()

	# Reset for next cast
	bubbles.clear()

func on_collected(item):
	''' send signal to player that item was collected '''
	fragment_collected.emit(item)

func _on_travel_back_area_entered(area: Area2D) -> void:
	''' Travel back to town '''
	transition('south')
	$Music.stop()
	$TransitionSound.play()
	await get_tree().create_timer(1).timeout
	$TransitionSound.stop()
	get_tree().change_scene_to_file("res://Scenes/town.tscn")


func transition(direction : String):
	$TransitionRect.show()
	$TransitionRect/AnimationPlayer.play('Fade')
	traveling.emit(direction)

func reverse_transition(direction : String):
	$ReverseTransitionRect.show()
	$ReverseTransitionRect/AnimationPlayer.play('Fade')
	traveling.emit(direction)
