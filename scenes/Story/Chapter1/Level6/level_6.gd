extends Node2D

@onready var cutscene_layer: CanvasLayer = $CutsceneLayer
var scene_path1 : String = "res://scenes/cutscenes-collection/level 6/level_6_opening.tscn"
var scene_path2 : String = "res://scenes/cutscenes-collection/level 6/level_6_ending.tscn"

@export var player : PlayerHercules
@export var fail_screen: Control
@export var pause_screen : Control
@export var victory_screen : Control

var paused : bool = false

func _ready() -> void:
	CutsceneManager.set_canvas_layer(cutscene_layer)
	player.connect("PlayerFail", Callable(self, "on_player_fail"))
	opening_cutscene_lvl6()
	
	Dialogic.signal_event.connect(_on_bull_defeated)
	Dialogic.signal_event.connect(_on_level_complete)
	
# when player dies: fail screen opens
func on_player_fail() -> void:
	fail_screen.open()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_game"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pause_screen.open()
		get_tree().paused = true
		
func opening_cutscene_lvl6() -> void:
	CutsceneManager.add_cutscene(scene_path1, "opening6")
	CutsceneManager.play_cutscene("opening6")

func _on_bull_defeated(argument: String) -> void:
	if argument == "7labordone":
		CutsceneManager.add_cutscene(scene_path2, "ending6")
		CutsceneManager.play_cutscene("ending6")

func _on_level_complete(argument : String) -> void:
	if argument == "level7complete":
		await get_tree().create_timer(2).timeout
	
		victory_screen.visible = true
		victory_screen.update_scores()
