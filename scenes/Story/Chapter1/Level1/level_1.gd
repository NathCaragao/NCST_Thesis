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
var isDialogPlaying = false
func _ready() -> void:
	CutsceneManager.set_canvas_layer(cutscene_layer)
	player_state_reset()
	enable_score_ui()
	player.connect("PlayerFail", Callable(self, "on_player_fail"))
	nemean_lion.connect("LionDefeated", Callable(self, "on_lion_defeated"))
	Dialogic.signal_event.connect(on_dialogic_signal_play_bgm)
	Dialogic.timeline_started.connect(on_dialog_start)
	Dialogic.timeline_ended.connect(on_dialog_end)
	opening_cutscene()
func on_dialog_start():
	isDialogPlaying = true
	print_debug("Started dialog, isDialogPlaying: %s" % str(isDialogPlaying))
func on_dialog_end():
	isDialogPlaying = false
	print_debug("Ended dialog, isDialogPlaying: %s" % str(isDialogPlaying))
func on_dialogic_signal_play_bgm(event: String) -> void:
	if event == "end":
		if lively:
			lively.play()
		else:
			print("Error: 'lively' AudioStreamPlayer not found!")
func on_player_fail() -> void:
	fail_screen.open()
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_game") and !get_tree().paused and !isDialogPlaying:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pause_screen.open()
		get_tree().paused = true
func on_lion_defeated() -> void:
	level_cleared()
	var freeCurrencyCollectedThisLevel = ScoreManager.collected_items["coin"]
	for i in range(1, 4):
		if await ServerManager.updateUserFreeCurrency(freeCurrencyCollectedThisLevel) == OK:
			victory_screen.enableButtons()
			break
		elif i == 3:
			Notification.showMessage("Failed to save rewards to Server. Please restart the game", 5.0)
	ScoreManager.reset_score()
func opening_cutscene() -> void:
	CutsceneManager.add_cutscene(scene_path, "opening1")
	CutsceneManager.play_cutscene("opening1")
func level_cleared() -> void:
	victory_screen.visible = true
	victory_screen.update_scores()
	ScoreUi.get_node('CanvasLayer').hide()
func enable_score_ui() -> void:
	ScoreUi.get_node('CanvasLayer').show()
func player_state_reset() -> void:
	ScoreManager.reset_score()
	player.inv.reset()
