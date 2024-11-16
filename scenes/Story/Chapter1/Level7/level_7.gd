extends Node2D

@export var enemy_scenes : Array[PackedScene] = []
@export var player : PlayerHercules
@export var fail_screen: Control
@export var pause_screen : Control
@export var victory_screen : Control
@onready var spawn_points : Array = [$SpawnArea/Spawn1, $SpawnArea/Spawn2, $SpawnArea/Spawn3]

var paused : bool = false

func _ready() -> void:
	player.connect("PlayerFail", Callable(self, "on_player_fail"))

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


func _on_spawn_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		# in-game screen fade out transition
		LevelScreenTransition.transition()
		await LevelScreenTransition.on_transition_finished
		spawn_enemy(0, 0)
		spawn_enemy(1, 1)
		spawn_enemy(2, 2)
