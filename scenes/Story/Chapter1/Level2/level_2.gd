extends Node2D
var scene_path : String = "res://scenes/cutscenes-collection/level 2/level_2_opening.tscn"
@onready var cutscene_layer: CanvasLayer = $CanvasLayer
@onready var swamp_bgm = $bgm/swamp_bgm

@export var player : PlayerHercules
@export var fail_screen: Control
@export var pause_screen : Control
@export var victory_screen : Control
@export var hydra : EnemyHydra


var paused : bool = false

func _ready() -> void:
	CutsceneManager.set_canvas_layer(cutscene_layer)
	player.connect("PlayerFail", Callable(self, "on_player_fail"))
	hydra.connect("HydraDefeated", Callable(self, "on_hydra_defeat"))
	Dialogic.signal_event.connect(on_dialogic_signal_play_bgm)
	
	opening_cutscene()
	
	
func on_dialogic_signal_play_bgm(event: String) -> void:
	if event == "end":
		# Play the lively audio
		if swamp_bgm:
			swamp_bgm.play()
		else:
			print("Error: 'lively' AudioStreamPlayer not found!")
# when player dies: fail screen opens
func on_player_fail() -> void:
	fail_screen.open()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_game"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pause_screen.open()
		get_tree().paused = true

func on_hydra_defeat() -> void:
	victory_screen.visible = true
	victory_screen.update_scores() # updates scores
func opening_cutscene() -> void:
	CutsceneManager.add_cutscene(scene_path, "opening1")
	CutsceneManager.play_cutscene("opening1")
