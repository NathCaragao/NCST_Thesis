extends Node2D

@onready var cutscene_layer: CanvasLayer = $CanvasLayer
var scene_path : String = "res://scenes/cutscenes-collection/level 9/level_9_opening.tscn"
var scene_path_ed : String = "res://scenes/cutscenes-collection/level 9/level_9_ending.tscn"


@export var player : PlayerHercules
@export var victory_screen : Control
@export var fail_screen : Control
@export var pause_screen : Control

@onready var bgm = $bgm


func _ready() -> void:
	player_state_reset()
	
	enable_score_ui()
	player.connect("PlayerFail", Callable(self, "on_player_fail"))
	CutsceneManager.set_canvas_layer(cutscene_layer)
	Dialogic.signal_event.connect(ending_scene)
	Dialogic.signal_event.connect(on_level_complete)
	Dialogic.signal_event.connect(on_dialogic_signal_play_bgm)
	opening_cutscene()
	
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

func on_level_complete(argument : String) -> void:
	if argument == "10laborcomplete":
		level_completed_screen()
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
		ScoreUi.get_node('CanvasLayer').hide()
		ScoreManager.reset_score()

func level_completed_screen() -> void:
	await get_tree().create_timer(2).timeout
	
	victory_screen.visible = true
	victory_screen.update_scores()
	
	
func opening_cutscene() -> void:
	CutsceneManager.add_cutscene(scene_path, "opening_scene")
	CutsceneManager.play_cutscene("opening_scene")

func ending_cutscene() -> void:
	CutsceneManager.add_cutscene(scene_path_ed, "ending_scene")
	CutsceneManager.play_cutscene("ending_scene")
	print("Playing Ending Scene")

func ending_scene(argument : String) -> void:
	if argument == "S10_Ending":
		ending_cutscene()

func enable_score_ui() -> void:
	ScoreUi.get_node('CanvasLayer').show()

# resets player score and inventory
func player_state_reset() -> void:
	# reset score
	ScoreManager.reset_score()
	
	# reset player inventory
	player.inv.reset()
