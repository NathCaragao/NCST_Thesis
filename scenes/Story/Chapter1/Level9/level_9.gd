extends Node2D

@onready var cutscene_layer: CanvasLayer = $CanvasLayer
var scene_path : String = "res://scenes/cutscenes-collection/level 9/level_9_opening.tscn"
var scene_path_ed : String = "res://scenes/cutscenes-collection/level 9/level_9_ending.tscn"

@export var victory_screen : Control
@export var fail_screen : Control
@export var pause_screen : Control


func _ready() -> void:
	CutsceneManager.set_canvas_layer(cutscene_layer)
	Dialogic.signal_event.connect(on_level_complete)
	
	opening_cutscene()

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
	CutsceneManager.set_canvas_layer(cutscene_layer)
	ending_cutscene()
	await get_tree().create_timer(2).timeout
	
	victory_screen.visible = true
	victory_screen.update_scores()
	
func opening_cutscene() -> void:
	CutsceneManager.add_cutscene(scene_path, "opening6")
	CutsceneManager.play_cutscene("opening6")

func ending_cutscene() -> void:
	CutsceneManager.add_cutscene(scene_path, "opening6")
	CutsceneManager.play_cutscene("opening6")
