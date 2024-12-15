extends Node2D
var scene_path : String = "res://scenes/cutscenes-collection/level 1/level_1_opening.tscn"
@onready var cutscene_layer: CanvasLayer = $CanvasLayer

@onready var lively: AudioStreamPlayer = $bgm/lively



@export var player : PlayerHercules
@export var fail_screen: Control
@export var pause_screen : Control
@export var victory_screen : Control
@export var nemean_lion : CharacterBody2D
@export var movement_tutorial : Control
@export var gate_mechanics : Control
@export var battle_tutorial : Control

var paused : bool = false
var isDialogPlaying = false

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
	Dialogic.timeline_started.connect(on_dialog_start)
	Dialogic.timeline_ended.connect(on_dialog_end)
	Dialogic.signal_event.connect(on_level_start)
	Dialogic.signal_event.connect(on_mechanics)
	
	# play opening cutscene
	opening_cutscene()

func on_level_start(argument : String) -> void:
	if argument == "movement":
		await get_tree().create_timer(1).timeout
		movement_tutorial_open()

func on_mechanics(argument: String) -> void:
	if argument == "gatemech":
		tutorial2_open()
func on_dialog_start():
	isDialogPlaying = true
	print_debug("Started dialog, isDialogPlaying: %s" % str(isDialogPlaying))

func on_dialog_end():
	isDialogPlaying = false
	print_debug("Ended dialog, isDialogPlaying: %s" % str(isDialogPlaying))

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
	if Input.is_action_just_pressed("pause_game") and !get_tree().paused and !isDialogPlaying:
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

func tutorial1_open() -> void:
	battle_tutorial.visible = true
	
	# create a tween
	var tween = create_tween()
	
	 # Set the initial position of the almanac window to below the screen
	var screen_size = get_viewport_rect().size
	battle_tutorial.position.y = screen_size.y
	# Animate the window moving from bottom to center
	tween.tween_property(battle_tutorial, "position:y", screen_size.y / 2 - battle_tutorial.size.y / 2, 0.3) \
		.set_trans(Tween.TRANS_BACK) \
		.set_ease(Tween.EASE_OUT)

func _on_tutorial_1_body_entered(body: Node2D) -> void:
	var tutorial1_played : bool = false
	if !tutorial1_played:
		tutorial1_open()
		tutorial1_played = true

func tutorial2_open() -> void:
	gate_mechanics.visible = true
	
	# create a tween
	var tween = create_tween()
	
	 # Set the initial position of the almanac window to below the screen
	var screen_size = get_viewport_rect().size
	gate_mechanics.position.y = screen_size.y
	# Animate the window moving from bottom to center
	tween.tween_property(gate_mechanics, "position:y", screen_size.y / 2 - gate_mechanics.size.y / 2, 0.3) \
		.set_trans(Tween.TRANS_BACK) \
		.set_ease(Tween.EASE_OUT)

func movement_tutorial_open() -> void:
	movement_tutorial.visible = true
	
	# create a tween
	var tween = create_tween()
	
	 # Set the initial position of the almanac window to below the screen
	var screen_size = get_viewport_rect().size
	movement_tutorial.position.y = screen_size.y
	# Animate the window moving from bottom to center
	tween.tween_property(movement_tutorial, "position:y", screen_size.y / 2 - movement_tutorial.size.y / 2, 0.3) \
		.set_trans(Tween.TRANS_BACK) \
		.set_ease(Tween.EASE_OUT)
