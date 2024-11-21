extends Node2D

@onready var cutscene_layer: CanvasLayer = $CutsceneLayer
var scene_path : String = "res://scenes/Story/Chapter1/Level6/level_6.tscn"

@export var player : PlayerHercules
@export var fail_screen: Control
@export var pause_screen : Control
@export var victory_screen : Control

var paused : bool = false

func _ready() -> void:
	CutsceneManager.set_canvas_layer(cutscene_layer)
	player.connect("PlayerFail", Callable(self, "on_player_fail"))
	
	
	opening_cutscene_lvl6()
# when player dies: fail screen opens
func on_player_fail() -> void:
	fail_screen.open()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_game"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pause_screen.open()
		get_tree().paused = true
		
func opening_cutscene_lvl6() -> void:
	CutsceneManager.add_cutscene(scene_path, "opening6")
	CutsceneManager.play_cutscene("opening6")
