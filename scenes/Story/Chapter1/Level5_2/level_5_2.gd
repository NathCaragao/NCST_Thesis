extends Node2D

var scene_path : String = "res://scenes/cutscenes-collection/level 5-2/level_5_2_opening.tscn"
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var bgm = $bgm

@export var player : PlayerHercules
@export var fail_screen: Control
@export var pause_screen : Control
@export var victory_screen : Control

var paused : bool = false

func _ready() -> void:
	enable_score_ui()
	# set canvas layer for cutscenes to be added
	CutsceneManager.set_canvas_layer(canvas_layer)
	
	player.connect("PlayerFail", Callable(self, "on_player_fail"))
	Dialogic.signal_event.connect(on_level_complete)
	Dialogic.signal_event.connect(on_dialogic_signal_play_bgm)
	
	opening_cutscene()
#on dialog end play bgm
func on_dialogic_signal_play_bgm(event: String) -> void:
	if event == "end":
		# Play the lively audio
		if bgm:
			bgm.play()
			
# when player dies: fail screen opens
func on_player_fail() -> void:
	fail_screen.open()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_game"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pause_screen.open()
		get_tree().paused = true

func on_level_complete(argument: String) -> void:
	if argument == "6LaborDone":
		level_complete()

func level_complete() -> void:
	victory_screen.visible = true
	victory_screen.update_scores()
	
func opening_cutscene() -> void:
	CutsceneManager.add_cutscene(scene_path, "opening1")
	CutsceneManager.play_cutscene("opening1")

func enable_score_ui() -> void:
	ScoreUi.get_node('CanvasLayer').show()
