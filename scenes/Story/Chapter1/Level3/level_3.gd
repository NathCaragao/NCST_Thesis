# level3.gd
extends Node2D

var scene_path : String = "res://scenes/cutscenes-collection/level 3/level_3_opening.tscn"
@onready var cutscene_layer: CanvasLayer = $CutsceneLayer
@onready var bgm_lvl_3 = $bgm_lvl3


@export var player : PlayerHercules
@export var fail_screen: Control
@export var pause_screen : Control
@export var victory_screen : Control

var paused : bool = false

func _ready() -> void:
	# resets player score and inv
	player_state_reset()
	
	# shows score UI
	enable_score_ui()
	
	CutsceneManager.set_canvas_layer(cutscene_layer) # sets where the cutscene.tscn will go
	player.connect("PlayerFail", Callable(self, "on_player_fail"))
	Dialogic.signal_event.connect(on_complete)
	Dialogic.signal_event.connect(on_dialogic_signal_play_bgm)
	
	opening_cutscene()


func on_dialogic_signal_play_bgm(event: String) -> void:
	if event == "end":
		# Play the lively audio
		if bgm_lvl_3:
			bgm_lvl_3.play()
# when player dies: fail screen opens
func on_player_fail() -> void:
	fail_screen.open()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_game") and !get_tree().paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pause_screen.open()
		get_tree().paused = true

func on_complete(argument: String) -> void:
	if argument == "lvl3Complete":
		level_complete()
		# Await sending rewards update to server
		var freeCurrencyCollectedThisLevel = ScoreManager.collected_items["coin"]
		# once done, enable buttons in victory screen
		for i in range(1, 4):
			if await ServerManager.updateUserFreeCurrency(freeCurrencyCollectedThisLevel) == OK:
				victory_screen.enableButtons()
				break
			elif i == 3:
				Notification.showMessage("Failed to save rewards to Server. Please restart the game", 5.0)
		# reset score manager for future use
		ScoreManager.reset_score()

func level_complete() -> void:
	victory_screen.visible = true
	victory_screen.update_scores()
	ScoreUi.get_node('CanvasLayer').hide()
	
# function for the opening scene
func opening_cutscene() -> void:
	CutsceneManager.add_cutscene(scene_path, "opening1")
	CutsceneManager.play_cutscene("opening1")

# displays the score UI in the viewport
func enable_score_ui() -> void:
	ScoreUi.get_node('CanvasLayer').show()

func player_state_reset() -> void:
	# reset score
	ScoreManager.reset_score()
	
	# reset player inventory
	player.inv.reset()
