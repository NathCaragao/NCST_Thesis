extends Node2D

var scene_path_1 : String = "res://scenes/cutscenes-collection/level 5-1/level_5_opening.tscn"
var scene_path_2 : String = "res://scenes/cutscenes-collection/level 5-1/level_5_opening_2.tscn"
@onready var canvas_layer: CanvasLayer = $CanvasLayer

func _ready() -> void:
	# set canvas layer for cutscenes to be added
	CutsceneManager.set_canvas_layer(canvas_layer)
	Dialogic.signal_event.connect(on_op1) # opening 1 dialog signal ending
	opening_1()

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
