extends Node2D

@onready var cutscene_layer: CanvasLayer = $CanvasLayer
var scene_path : String = "res://scenes/cutscenes-collection/level 9/level_9_opening.tscn"
var scene_path_ed : String = "res://scenes/cutscenes-collection/level 9/level_9_ending.tscn"

@onready var player = get_tree().get_first_node_in_group("Player")

@export var victory_screen : Control
@export var fail_screen : Control
@export var pause_screen : Control


func _ready() -> void:
	player.connect("PlayerFail", Callable(self, "on_player_fail"))
	CutsceneManager.set_canvas_layer(cutscene_layer)
	Dialogic.signal_event.connect(ending_scene)
	Dialogic.signal_event.connect(on_level_complete)
	
	opening_cutscene()

# when player dies: fail screen opens
func on_player_fail() -> void:
	fail_screen.open()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_game"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pause_screen.open()
		get_tree().paused = true

func on_level_complete(argument : String) -> void:
	if argument == "10laborcomplete":
		level_completed_screen()

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
