extends Node
var currentWave: int
var enemy = preload("res://Scenes/phantom.tscn")
var boss = preload("res://Scenes/phantom_boss.tscn")
var wave_spawn_count = 0
var wave_num = 0
@onready var timer = get_node("SpawnTimer")

func _ready():
	''' player startup '''
	#screen_size = get_viewport_rect().size
	$fight_music.play()

func _process(delta):
	#if wave_spawn_count == 14:
		#spawn_boss()
	pass
		
func spawn_boss():
	timer.set_wait_time(6)
	var boss_instance = boss.instantiate()
	boss_instance.position = $Spawner.position
	add_child(boss_instance)
	timer.stop()
	
func _on_travel_back_area_entered(area: Area2D) -> void:
	''' Travel back to town '''
	get_tree().change_scene_to_file("res://Scenes/town.tscn")
	
	
func _on_spawn_timer_timeout() -> void:
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
		
	print_debug("wave spawn count:", wave_spawn_count)
	print_debug("wave num:", wave_num)
	if wave_spawn_count % 7 == 0:
		wave_num +=1
		timer.set_wait_time(10)
		
	if wave_spawn_count == 14:
		spawn_boss()
		
func reset():
	wave_spawn_count = 0
