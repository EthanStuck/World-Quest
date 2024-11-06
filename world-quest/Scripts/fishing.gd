extends Node

@onready var bobber_scene = preload("res://Scenes/bobber.tscn")
@onready var bubble_scene = preload("res://Scenes/bubbles.tscn")
@onready var player = get_node("Player")
@onready var ui = get_node("UI")
@onready var fragment = preload("res://Scenes/fragment_north.tscn")

# Parameters
var spawn_area: Rect2 = Rect2(Vector2(-300, -300), Vector2(600, 600))
var bubble_spawn_interval: float = 5.0
var cast_distance: float = 100.0 
var cast_time_limit: float = 1.5 
var fish_caught: int = 0

# Timer for spawning bubbles
@onready var spawn_timer = Timer.new()
@onready var cast_timer = Timer.new()

var bobber: Area2D = null
var is_casting: bool = false
var time_since_cast: float = 0.0

func bub_timers() -> void:
	# Set up a timer for spawning bubbles
	add_child(spawn_timer)
	spawn_timer.wait_time = bubble_spawn_interval
	spawn_timer.one_shot = false
	spawn_timer.connect("timeout", Callable(self, "_on_bubble_spawn"))
	
	# Set up a timer for catching fish
	add_child(cast_timer)
	cast_timer.wait_time = cast_time_limit
	cast_timer.one_shot = true
	cast_timer.connect("timeout", Callable(self, "_on_cast_timeout"))
	
	spawn_timer.start()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('cast'):
		if is_casting:  # If the bobber is already in the water, the player is trying to catch a fish
			catch_fish()
			bub_timers()
		else:
			cast_bobber()  # Cast the bobber if it's not already in the water
			bub_timers()

# Called when the cast input is received
func cast_bobber() -> void:
	if is_casting:
		return  # Prevent casting if a bobber is already in the water
	
	# Get the position in front of the player for casting
	var cast_position = Vector2(player.position.x, player.position.y - cast_distance)
	
	# Spawn the bobber at the cast position
	bobber = bobber_scene.instantiate()
	bobber.position = cast_position
	add_child(bobber)
	
	# Start the fishing time window
	is_casting = true
	time_since_cast = 0.0
	cast_timer.start()
	
	# Start spawning bubbles
	spawn_bubbles_towards_bobber()

# Spawns bubbles that move towards the bobber
func spawn_bubbles_towards_bobber() -> void:
	spawn_timer.start()  # Start the bubble spawning timer

# Called when the bubble timer times out
func _on_bubble_spawn() -> void:
	if bobber == null:
		return  # No bobber to spawn bubbles towards
	
	# Create a new bubble instance
	var bubble = bubble_scene.instantiate()
	
	# Random spawn position within the lake area
	#var spawn_pos = Vector2(
		#randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x),
		#randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
	#)
	var spawn_pos = Vector2(player.position.x, player.position.y - 110)
	
	bubble.position = spawn_pos
	
	# Set the bobber as the target for the bubble
	bubble.target_position = bobber.position
	
	# Add the bubble to the scene
	add_child(bubble)
	print("bubbles spawned")
	print(bubble.position)
	print(bubble.target_position)

# Called when the cast timer times out (the player missed)
func _on_cast_timeout() -> void:
	if is_casting:
		ui.show_message("Try again")
		reset_cast()

# Called when the player casts again within the time window
func catch_fish() -> void:
	if time_since_cast <= cast_time_limit:
		fish_caught += 1
		ui.show_message("You caught a fish!")
		
		# Spawning fragment when 10 fish are caught
		if fish_caught >= 10:
			ui.show_message("Quest Complete!")
			var frag = fragment.instantiate()
			frag.position = Vector2(player.position.x, player.position.y + 100)
			add_child(frag)
		
		reset_cast()

# Resets the cast state and cleans up
func reset_cast() -> void:
	is_casting = false
	bobber.queue_free()
	bobber = null
	time_since_cast = 0.0
	cast_timer.stop()
	spawn_timer.stop()

# UI message display (Assumes there's a Label node in the UI)
func show_message(message: String) -> void:
	ui.message_label.text = message
	ui.message_label.show()
	await(get_tree().create_timer(2.0))
	ui.message_label.hide()
	
	
func _on_travel_back_area_entered(area: Area2D) -> void:
	''' Travel back to town '''
	get_tree().change_scene_to_file("res://Scenes/town.tscn")
