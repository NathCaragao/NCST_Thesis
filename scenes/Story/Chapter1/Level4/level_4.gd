extends Node2D

var scene_path : String = "res://scenes/cutscenes-collection/level 4/level_4_opening.tscn"
@onready var cutscene_layer: CanvasLayer = $CanvasLayer
@onready var bgm = $bgm

@export var player : PlayerHercules
@export var fail_screen: Control
@export var pause_screen : Control
@export var victory_screen : Control
@export var boss_boar : CharacterBody2D

var paused : bool = false

func _ready() -> void:
	enable_score_ui()
	CutsceneManager.set_canvas_layer(cutscene_layer) # sets where the cutscene.tscn will go
	
	player.connect("PlayerFail", Callable(self, "on_player_fail"))
	boss_boar.connect("BossBoarDefeated", Callable(self, "on_defeat"))
	Dialogic.signal_event.connect(on_dialogic_signal_play_bgm)
	
	opening_cutscene()
	# snow particle
	%Snow.local_coords = false
func on_dialogic_signal_play_bgm(event: String) -> void:
	if event == "end":
		# Play the lively audio
		if bgm:
			bgm.play()
# when player dies: fail screen opens
func on_player_fail() -> void:
	fail_screen.open()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_game") and !get_tree().paused:
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
	
func opening_cutscene() -> void:
	CutsceneManager.add_cutscene(scene_path, "opening1")
	CutsceneManager.play_cutscene("opening1")

func enable_score_ui() -> void:
	ScoreUi.get_node('CanvasLayer').show()
