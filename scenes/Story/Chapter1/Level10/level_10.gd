extends Node2D
@onready var cutscene_layer: CanvasLayer = $CanvasLayer
var scene_path : String = "res://scenes/cutscenes-collection/level 10/level_10_opening.tscn"


@onready var bgm = $bgm

@export var player : PlayerHercules
@export var fail_screen: Control
@export var pause_screen : Control
@export var victory_screen : Control

var isDialogPlaying = false

func _ready() -> void:
	player_state_reset()
	
	enable_score_ui()
	player.connect("PlayerFail", Callable(self, "on_player_fail"))
	CutsceneManager.set_canvas_layer(cutscene_layer)
	Dialogic.signal_event.connect(on_level_complete)
	Dialogic.signal_event.connect(on_dialogic_signal_play_bgm)
	Dialogic.timeline_started.connect(on_dialog_start)
	Dialogic.timeline_ended.connect(on_dialog_end)
	
	opening_cutscene()

# Handles the start signal from Dialogic
func on_dialog_start():
	isDialogPlaying = true
	print_debug("Started dialog, isDialogPlaying: %s" % str(isDialogPlaying))

func on_dialog_end():
	isDialogPlaying = false
	print_debug("Ended dialog, isDialogPlaying: %s" % str(isDialogPlaying))

func on_dialogic_signal_play_bgm(event: String) -> void:
	if event == "end":
		# Play the lively audio
		if bgm:
			bgm.play()
# when player dies: fail screen opens
func on_player_fail() -> void:
	fail_screen.open()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_game") and !get_tree().paused and !isDialogPlaying:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pause_screen.open()
		get_tree().paused = true

func on_level_complete(argument : String) -> void:
	if argument == "11labordone":
		level_complete_screen()
		# Await sending rewards update to server
		var freeCurrencyCollectedThisLevel = ScoreManager.collected_items["coin"]
		# once done, enable buttons in victory screen
		for i in range(1, 4):
			if await ServerManager.updateUserFreeCurrency(freeCurrencyCollectedThisLevel) == OK:
				victory_screen.enableButtons()
				break
			elif i == 3:
				Notification.showMessage("Failed to save rewards to Server. Please restart the game", 5.0)
		# reset score manager 
		ScoreManager.reset_score()

func level_complete_screen() -> void:
	await get_tree().create_timer(2).timeout
	
	victory_screen.visible = true
	victory_screen.update_scores()
	ScoreUi.get_node('CanvasLayer').hide()
	
func opening_cutscene() -> void:
	CutsceneManager.add_cutscene(scene_path, "opening6")
	CutsceneManager.play_cutscene("opening6")
	

func _teleport(body: CharacterBody2D) -> void:
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	
	body.global_position = $Portal/PortalOut.global_position

func enable_score_ui() -> void:
	ScoreUi.get_node('CanvasLayer').show()

# resets player score and inventory
func player_state_reset() -> void:
	# reset score
	ScoreManager.reset_score()
	
	# reset player inventory
	player.inv.reset()
