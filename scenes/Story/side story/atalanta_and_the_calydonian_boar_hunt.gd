# Atalanta Side story level 1
extends Node2D

# onready
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var cutscene = $Cutscene
var scene_path : String = "res://scenes/cutscenes-collection/Atalanta_and_the_calydonian_boar_hunt/Atalanta_and_the_calydonian_boar_hunt.tscn"
var paused : bool = false
var isDialogPlaying = false
@onready var bgm = $bgm

@export_category("UI Screens")
@export var fail_screen : Control
@export var pause_screen : Control
@export var victory_screen : Control


@export_category("Entities")
@export var player : CharacterBody2D
@export var boss_boar : CharacterBody2D

func _ready() -> void:
	CutsceneManager.set_canvas_layer(cutscene)
	player_state_reset()
	
	enable_score_ui()
	
	player.connect("PlayerFail", Callable(self, "on_player_fail"))
	
	Dialogic.timeline_started.connect(on_dialog_start)
	Dialogic.timeline_ended.connect(on_dialog_end)
	Dialogic.signal_event.connect(on_dialogic_signal_play_bgm)
	
	opening_cutscene()


func on_dialog_start():
	isDialogPlaying = true
	print_debug("Started dialog, isDialogPlaying: %s" % str(isDialogPlaying))

func on_dialog_end():
	isDialogPlaying = false
	print_debug("Ended dialog, isDialogPlaying: %s" % str(isDialogPlaying))

# when player dies: fail screen opens
func on_player_fail() -> void:
	fail_screen.open()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_game") and !get_tree().paused and !isDialogPlaying:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pause_screen.open()
		get_tree().paused = true

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

# function for the opening scene
func opening_cutscene() -> void:
	CutsceneManager.add_cutscene(scene_path, "opening")
	CutsceneManager.play_cutscene("opening")

func on_dialogic_signal_play_bgm(event: String) -> void:
	if event == "end":
		# Play the lively audio
		if bgm:
			bgm.play()
		else:
			print("Error: 'lively' AudioStreamPlayer not found!")
	
func _on_finish_line_body_entered(body: Node2D) -> void:
	level_cleared()
