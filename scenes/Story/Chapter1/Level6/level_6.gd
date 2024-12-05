extends Node2D

@onready var canvas_layer = $CanvasLayer

var scene_path1 : String = "res://scenes/cutscenes-collection/level 6/level_6_opening.tscn"
var scene_path2 : String = "res://scenes/cutscenes-collection/level 6/level_6_ending.tscn"

@export var player : PlayerHercules
@export var fail_screen: Control
@export var pause_screen : Control
@export var victory_screen : Control
@onready var bgm = $bgm

var paused : bool = false

func _ready() -> void:
	player_state_reset()
	
	enable_score_ui()
	
	CutsceneManager.set_canvas_layer(canvas_layer)
	player.connect("PlayerFail", Callable(self, "on_player_fail"))
	Dialogic.signal_event.connect(on_dialogic_signal_play_bgm)
	
	opening_cutscene_lvl6()
	
	Dialogic.signal_event.connect(_on_bull_defeated)
	Dialogic.signal_event.connect(_on_level_complete)
	
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
		
func opening_cutscene_lvl6() -> void:
	CutsceneManager.add_cutscene(scene_path1, "opening6")
	CutsceneManager.play_cutscene("opening6")

func _on_bull_defeated(argument: String) -> void:
	if argument == "7labordone":
		CutsceneManager.add_cutscene(scene_path2, "ending6")
		CutsceneManager.play_cutscene("ending6")

func _on_level_complete(argument : String) -> void:
	if argument == "level7complete":
		await get_tree().create_timer(2).timeout
	
		victory_screen.visible = true
		victory_screen.update_scores()
		ScoreUi.get_node('CanvasLayer').hide()
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

func enable_score_ui() -> void:
	ScoreUi.get_node('CanvasLayer').show()

# resets player score and inventory
func player_state_reset() -> void:
	# reset score
	ScoreManager.reset_score()
	
	# reset player inventory
	player.inv.reset()
