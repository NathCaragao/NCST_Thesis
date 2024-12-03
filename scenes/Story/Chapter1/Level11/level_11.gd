extends Node2D

@onready var cutscene_layer: CanvasLayer = $cutscenelvl11
var scene_path : String = "res://scenes/cutscenes-collection/level_11/level_11_opening.tscn"
@onready var bgm = $bgm

@export var enemy_scenes : Array[PackedScene] = []
@onready var spawn_points : Array = [$CeberusSpawn]

@onready var player = get_tree().get_first_node_in_group("Player")

@export var fail_screen: Control
@export var pause_screen : Control
@export var victory_screen : Control
@export var actor : PlayerHercules
var paused : bool = false

# ferryman area reference
@onready var interaction_area: InteractionArea = $Ferryman/InteractionArea
@onready var interaction_area_2: InteractionArea = $Ferryman/InteractionArea2


func _ready() -> void:
	enable_score_ui()
	CutsceneManager.set_canvas_layer(cutscene_layer)
	Dialogic.signal_event.connect(on_ceberus_fight)
	Dialogic.signal_event.connect(on_level_complete)
	player.connect("PlayerFail", Callable(self, "on_player_fail"))
	interaction_area.interact = Callable(self, "on_ferryman")
	interaction_area_2.interact = Callable(self, "on_ferryman_2")
	Dialogic.signal_event.connect(on_dialogic_signal_play_bgm)
	
	opening_cutscene_lvl11()

func on_dialogic_signal_play_bgm(event: String) -> void:
	if event == "end":
		# Play the lively audio
		if bgm:
			bgm.play()
# when player dies: fail screen opens
func on_player_fail() -> void:
	fail_screen.open()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_game"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pause_screen.open()
		get_tree().paused = true

# teleport activation
func _on_teleport_body_entered(body: Node2D) -> void:
	call_deferred("player_teleport")

func player_teleport() -> void:
	# in-game screen fade out transition
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	
	# teleport the player to the specified position
	actor.position.x = 2635
	actor.position.y = 4685

func on_ferryman() -> void:
	boat_teleport()

func on_ferryman_2() -> void:
	boat_teleport2()

func boat_teleport() -> void:
	# in-game screen fade out transition
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	
	actor.position.x = 9881
	actor.position.y = 4460

func boat_teleport2() -> void:
	# in-game screen fade out transition
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	
	actor.position.x = 7462
	actor.position.y = 4460
func opening_cutscene_lvl11() -> void:
	CutsceneManager.add_cutscene(scene_path, "opening12")
	CutsceneManager.play_cutscene("opening12")

func spawn_enemy(index : int, spawn_point_index: int) -> void:
	if enemy_scenes.is_empty():
		return
	
	var enemy = enemy_scenes[index].instantiate()
	enemy.global_position = spawn_points[spawn_point_index].global_position
	#get_parent().add_child(enemy)
	call_deferred("add_child", enemy)
	print("Enemy spawned")

func spawn_activate():
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	
	# spawn enemy here
	spawn_enemy(0, 0)

func on_ceberus_fight(argument: String) -> void:
	if argument == "ceberusfight":
		spawn_activate()

func on_level_complete(argument : String) -> void:
	if argument == "12laborcomplete":
		finish_screen()

func finish_screen() -> void:
	victory_screen.visible = true
	victory_screen.update_scores()

func enable_score_ui() -> void:
	ScoreUi.get_node('CanvasLayer').show()
