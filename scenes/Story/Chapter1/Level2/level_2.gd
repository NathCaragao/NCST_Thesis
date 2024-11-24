extends Node2D

@export var player : PlayerHercules
@export var fail_screen: Control
@export var pause_screen : Control
@export var victory_screen : Control
@export var hydra : EnemyHydra

var paused : bool = false

func _ready() -> void:
	player.connect("PlayerFail", Callable(self, "on_player_fail"))
	hydra.connect("HydraDefeated", Callable(self, "on_hydra_defeat"))

# when player dies: fail screen opens
func on_player_fail() -> void:
	fail_screen.open()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_game"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pause_screen.open()
		get_tree().paused = true

func on_hydra_defeat() -> void:
	victory_screen.visible = true
	victory_screen.update_scores() # updates scores
