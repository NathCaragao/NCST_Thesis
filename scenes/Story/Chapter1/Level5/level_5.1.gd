extends Node2D

var scene_path_1 : String = "res://scenes/cutscenes-collection/level 5-1/level_5_opening.tscn"
var scene_path_2 : String = "res://scenes/cutscenes-collection/level 5-1/level_5_opening_2.tscn"
@onready var canvas_layer: CanvasLayer = $CutsceneLayer


@export var player : PlayerHercules
@export var fail_screen: Control
@export var pause_screen : Control
@export var victory_screen : Control

func _ready() -> void:
	# set canvas layer for cutscenes to be added
	CutsceneManager.set_canvas_layer(canvas_layer)
	Dialogic.signal_event.connect(on_op1) # opening 1 dialog signal ending
	Dialogic.signal_event.connect(on_dialog_done) # dialogic signal
	
	opening_1()
	
# victory after dialog 3
func on_dialog_done(argument: String) -> void:
	if argument == "level5complete":
		on_finish()

func on_finish() -> void:
	await get_tree().create_timer(1.5).timeout
	
	victory_screen.visible = true
	victory_screen.update_scores()

# cutscenes
func opening_1() -> void:
	CutsceneManager.add_cutscene(scene_path_1, "opening_1")
	CutsceneManager.play_cutscene("opening_1")

func opening_2() -> void:
	CutsceneManager.add_cutscene(scene_path_2, "opening_2")
	CutsceneManager.play_cutscene("opening_2")

func on_op1(argument : String) -> void:
	if argument == "nextScene":
		CutsceneManager.stop_cutscene("opening_1")
		opening_2()
