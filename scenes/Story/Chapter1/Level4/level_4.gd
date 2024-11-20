extends Node2D

@export var player : PlayerHercules
@export var fail_screen: Control
@export var pause_screen : Control
@export var victory_screen : Control
@export var boss_boar : CharacterBody2D

var paused : bool = false

func _ready() -> void:
	player.connect("PlayerFail", Callable(self, "on_player_fail"))
	boss_boar.connect("BossBoarDefeated", Callable(self, "on_defeat"))
	
	# snow particle
	$Player/Camera2D/Snow.local_coords = false

# when player dies: fail screen opens
func on_player_fail() -> void:
	fail_screen.open()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_game"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pause_screen.open()
		get_tree().paused = true

func on_defeat() -> void:
	after_battle_dialog()

func after_battle_dialog() -> void:
	Dialogic.start("S4_11")
	await Dialogic.timeline_ended # waits for the dialog to finish
	
	level_complete()

func level_complete() -> void:
	victory_screen.visible = true
	victory_screen.update_scores()
