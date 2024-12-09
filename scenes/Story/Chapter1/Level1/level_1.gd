extends Node2D
var scene_path : String = "res://scenes/cutscenes-collection/level 1/level_1_opening.tscn"
@onready var cutscene_layer: CanvasLayer = $CanvasLayer

@onready var lively: AudioStreamPlayer = $bgm/lively



@export var player : PlayerHercules
@export var fail_screen: Control
@export var pause_screen : Control
@export var victory_screen : Control
@export var nemean_lion : CharacterBody2D

var paused : bool = false

func _ready() -> void:
	# set the canvas layer for cutscene instantiation
	CutsceneManager.set_canvas_layer(cutscene_layer)
	
	# resets the score and player inventory for a clean state
	player_state_reset()
	
	# show the score UI
	enable_score_ui()
	
	# signals connection
	player.connect("PlayerFail", Callable(self, "on_player_fail"))
	nemean_lion.connect("LionDefeated", Callable(self, "on_lion_defeated"))
	
	# Connect Dialogic "end" signal to handle audio playback
	Dialogic.signal_event.connect(on_dialogic_signal_play_bgm)
	
	# play opening cutscene
	opening_cutscene()

# Handles the "end" signal from Dialogic
func on_dialogic_signal_play_bgm(event: String) -> void:
	if event == "end":
		# Play the lively audio
		if lively:
			lively.play()
		else:
			print("Error: 'lively' AudioStreamPlayer not found!")

# when player dies: fail screen opens
func on_player_fail() -> void:
	fail_screen.open()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_game") and !get_tree().paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pause_screen.open()
		get_tree().paused = true



func on_lion_defeated() -> void:
	level_cleared()
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
	
	
	
# function for the opening scene
func opening_cutscene() -> void:
	CutsceneManager.add_cutscene(scene_path, "opening1")
	CutsceneManager.play_cutscene("opening1")

func level_cleared() -> void:
	victory_screen.visible = true # shows the victory screen
	victory_screen.update_scores() # updates the scores
	ScoreUi.get_node('CanvasLayer').hide()

# displays the score UI in the viewport
func enable_score_ui() -> void:
	ScoreUi.get_node('CanvasLayer').show()

func player_state_reset() -> void:
	# reset score
	ScoreManager.reset_score()
	
	# reset player inventory
	player.inv.reset()
