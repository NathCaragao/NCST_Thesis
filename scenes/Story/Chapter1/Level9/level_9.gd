extends Node2D

@export var victory_screen : Control
@export var fail_screen : Control
@export var pause_screen : Control


func _ready() -> void:
	Dialogic.signal_event.connect(on_level_complete)

# when player dies: fail screen opens
func on_player_fail() -> void:
	fail_screen.open()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_game"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pause_screen.open()
		get_tree().paused = true

func on_level_complete(argument : String) -> void:
	if argument == "10laborcomplete":
		level_completed_screen()

func level_completed_screen() -> void:
	await get_tree().create_timer(2).timeout
	
	victory_screen.visible = true
	victory_screen.update_scores()
