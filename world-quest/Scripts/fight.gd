extends Node
var currentWave: int
var enemy = preload("res://Scenes/phantom.tscn")
var boss = preload("res://Scenes/phantom_boss.tscn")
@onready var fragment = preload("res://Scenes/fragment_west.tscn")
var wave_spawn_count = 0
var wave_num = 0
@onready var timer = get_node("SpawnTimer")
signal traveling
var boss_alive = false
signal fragment_collected

func _ready():
	''' player startup '''
	#screen_size = get_viewport_rect().size
	$fight_music.play()
	FragmentHandler.at = 'fighting'
	reverse_transition('west')
	if FragmentHandler.west_complete:
		$TextureRect.hide()
		$TownMusic.play()
		$fight_music.stop()
	else:
		$Player.currentHealth = $Player.maxHealth - 31
		$Player.health_update.emit()
	
	if FragmentHandler.west_spawned:
		var fragment_instance = fragment.instantiate()
		add_child.call_deferred(fragment_instance)
		fragment_instance.global_position = $FragmentSpawn.position
		fragment_instance.collected.connect(on_fragment_collected)

func _process(delta):
	#if wave_spawn_count == 14:
		#spawn_boss()
	if boss_alive:
		$FragmentSpawn.position = get_node('Phantom_Boss').position
	if $Player.currentHealth == $Player.maxHealth:
		$Player.currentHealth = $Player.maxHealth - 1

		
func spawn_boss():
	if not FragmentHandler.west_complete:
		timer.set_wait_time(6)
		var boss_instance = boss.instantiate()
		boss_instance.position = $Spawner.position
		add_child(boss_instance)
		timer.stop()
		boss_alive = true
		boss_instance.died.connect(on_boss_dead)

		
func on_boss_dead():
	''' boss is killed, spawn fragment '''
	boss_alive = false
	var fragment_instance = fragment.instantiate()
	add_child(fragment_instance)
	fragment_instance.global_position = $FragmentSpawn.position
	FragmentHandler.west_complete = true
	FragmentHandler.west_spawned = true
	fragment_instance.collected.connect(on_fragment_collected)
	
func on_fragment_collected(item):
	''' send signal to player that fragment was collected '''
	fragment_collected.emit(item)
	
	
func _on_travel_back_area_entered(area: Area2D) -> void:
	''' Travel back to town '''
	transition('east')
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/town.tscn")
	
	
func _on_spawn_timer_timeout() -> void:
	if not FragmentHandler.west_complete:
		_wave_counter()
		var enemy_instance = enemy.instantiate()
		add_child(enemy_instance)
		enemy_instance.position = $Spawner.position
		
		var nodes = get_tree().get_nodes_in_group("Spawn")
		var node = nodes[randi() % nodes.size()]
		var position = node.position
		$Spawner.position = position
	
func _wave_counter():
	wave_spawn_count += 1
	if wave_spawn_count == 8:
		timer.set_wait_time(1)
		
	#print_debug("wave spawn count:", wave_spawn_count)
	#print_debug("wave num:", wave_num)
	if wave_spawn_count % 7 == 0:
		wave_num +=1
		timer.set_wait_time(10)
		
	if wave_spawn_count == 14:
		spawn_boss()
		
func reset():
	wave_spawn_count = 0

func transition(direction : String):
	$TransitionRect.show()
	$TransitionRect/AnimationPlayer.play('Fade')
	traveling.emit(direction)

func reverse_transition(direction : String):
	$ReverseTransitionRect.show()
	$ReverseTransitionRect/AnimationPlayer.play('Fade')
	traveling.emit(direction)
