extends Node2D

@onready var canvas_layer: CanvasLayer = $CanvasLayer
var scene_path : String = "res://scenes/cutscenes-collection/hypolita_sidestory/hypolita_side_story.tscn"
@onready var bgm = $bgm

@export var player : PlayerHypolita

@export_category("UI Screens")
@export var fail_screen : Control
@export var pause_screen : Control
@export var victory_screen : Control

var paused : bool = false
var isDialogPlaying = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# set the canvas layer for cutscene instantiation
	CutsceneManager.set_canvas_layer(canvas_layer)
	
	# resets the score and player inventory for a clean state
	player_state_reset()
	
	# show the score UI
	enable_score_ui()
	
	# signals connection
	player.connect("PlayerFail", Callable(self, "on_player_fail"))
	
	Dialogic.signal_event.connect(on_dialogic_signal_play_bgm)
	
	opening_cutscene()

# when player dies: fail screen opens
func on_player_fail() -> void:
	fail_screen.open()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_game") and !get_tree().paused and !isDialogPlaying:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pause_screen.open()
		get_tree().paused = true

func on_dialogic_signal_play_bgm(event: String) -> void:
	if event == "end":
		# Play the lively audio
		if bgm:
			bgm.play()
		else:
			print("Error: 'lively' AudioStreamPlayer not found!")

func opening_cutscene() -> void:
	CutsceneManager.add_cutscene(scene_path, "opening")
	CutsceneManager.play_cutscene("opening")

# displays the score UI in the viewport
func enable_score_ui() -> void:
	ScoreUi.get_node('CanvasLayer').show()

func player_state_reset() -> void:
	# reset score
	ScoreManager.reset_score()
	
	# reset player inventory
	player.inv.reset()
