# level 8.gd
extends Node2D

@export var enemy_scenes : Array[PackedScene] = []
@onready var spawn_points : Array = [$SpawnArea/Spawn1, $SpawnArea/Spawn2, $SpawnArea/Spawn3]
@export var fail_screen: Control
@export var pause_screen : Control
@export var victory_screen : Control

var paused : bool = false

# npc interaction reference
@onready var interaction_area: InteractionArea = $NPCs/InteractionArea
@onready var interaction_area_2: InteractionArea = $NPCs/InteractionArea2


func _ready() -> void:
	interaction_area.interact = Callable(self, "on_interact")
	interaction_area_2.interact = Callable(self, "on_interact2")
	Dialogic.signal_event.connect(on_wave1)

# when player dies: fail screen opens
func on_player_fail() -> void:
	fail_screen.open()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_game"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pause_screen.open()
		get_tree().paused = true

func spawn_enemy(index : int, spawn_point_index: int) -> void:
	if enemy_scenes.is_empty():
		return
	
	var enemy = enemy_scenes[index].instantiate()
	enemy.global_position = spawn_points[spawn_point_index].global_position
	#get_parent().add_child(enemy)
	call_deferred("add_child", enemy)
	print("Enemy spawned")

# trigger for spawning enemies
func spawn_activate():
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	
	# spawn enemy here
	spawn_enemy(1, 0)
	spawn_enemy(1, 1)
	spawn_enemy(1, 2)
	
	# remove the amazon npcs
	$NPCs/AmasonNPC4.queue_free()
	$NPCs/AmasonNPC5.queue_free()
	$NPCs/AmasonNPC6.queue_free()

# npc interaction code
func on_interact() -> void:
	Dialogic.start("S9_1")

func on_interact2() -> void:
	Dialogic.start("S9_2")

func on_wave1(argument: String) -> void:
	if argument == "1Wave":
		spawn_activate()
