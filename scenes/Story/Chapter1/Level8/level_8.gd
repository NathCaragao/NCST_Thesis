# level 8.gd
extends Node2D

@onready var cutscene_layer: CanvasLayer = $CanvasLayer
var scene_path : String = "res://scenes/cutscenes-collection/level 8/level_8_opening.tscn"

@export var enemy_scenes : Array[PackedScene] = []
@onready var spawn_points : Array = [$SpawnArea/Spawn1, $SpawnArea/Spawn2, $SpawnArea/Spawn3,
$SpawnArea/Spawn4]
@export var fail_screen: Control
@export var pause_screen : Control
@export var victory_screen : Control
@onready var bgm = $bgm

@export var player : PlayerHercules
var paused : bool = false
var isDialogPlaying = false


@onready var interaction_area: InteractionArea = $NPCs/InteractionArea
@onready var interaction_area_2: InteractionArea = $NPCs/InteractionArea2
@onready var interaction_area_3: InteractionArea = $NPCs/InteractionArea3


func _ready() -> void:
	player_state_reset()
	
	enable_score_ui()
	CutsceneManager.set_canvas_layer(cutscene_layer)
	interaction_area.interact = Callable(self, "on_interact")
	interaction_area_2.interact = Callable(self, "on_interact2")
	interaction_area_3.interact = Callable(self, "on_interact3")
	player.connect("PlayerFail", Callable(self, "on_player_fail"))
	

	Dialogic.signal_event.connect(on_wave1)
	Dialogic.signal_event.connect(on_level_complete)
	Dialogic.signal_event.connect(on_dialogic_signal_play_bgm)
	Dialogic.timeline_started.connect(on_dialog_start)
	Dialogic.timeline_ended.connect(on_dialog_end)

	$NPCs/InteractionArea3/CollisionShape2D.disabled = true
	opening_cutscene()


func on_dialog_start():
	isDialogPlaying = true
	print_debug("Started dialog, isDialogPlaying: %s" % str(isDialogPlaying))

func on_dialog_end():
	isDialogPlaying = false
	print_debug("Ended dialog, isDialogPlaying: %s" % str(isDialogPlaying))

func on_dialogic_signal_play_bgm(event: String) -> void:
	if event == "end":
		if bgm:
			bgm.play()

func on_player_fail() -> void:
	fail_screen.open()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_game") and !get_tree().paused and !isDialogPlaying:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pause_screen.open()
		get_tree().paused = true

func spawn_enemy(index : int, spawn_point_index: int) -> void:
	if enemy_scenes.is_empty():
		return
	
	var enemy = enemy_scenes[index].instantiate()
	enemy.global_position = spawn_points[spawn_point_index].global_position

	call_deferred("add_child", enemy)
	print("Enemy spawned")


func spawn_activate():
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	
	spawn_enemy(1, 0)
	spawn_enemy(1, 1)
	spawn_enemy(1, 2)
	
	$NPCs/AmasonNPC4.queue_free()
	$NPCs/AmasonNPC5.queue_free()
	$NPCs/AmasonNPC6.queue_free()

func on_interact() -> void:
	Dialogic.start("S9_1")

func on_interact2() -> void:
	Dialogic.start("S9_2")
	$NPCs/InteractionArea2/CollisionShape2D.disabled = true
	$NPCs/InteractionArea3/CollisionShape2D.disabled = false

func on_interact3() -> void:
	Dialogic.start("S9_3")
	await Dialogic.timeline_ended
	
	$NPCs/Hypolita_npc.queue_free()
	spawn_enemy(0, 3)

func on_wave1(argument: String) -> void:
	if argument == "1Wave":
		spawn_activate()

func on_level_complete(argument: String) -> void:
	if argument == "9labordone":
		level_finish()
		var freeCurrencyCollectedThisLevel = ScoreManager.collected_items["coin"]
		for i in range(1, 4):
			if await ServerManager.updateUserFreeCurrency(freeCurrencyCollectedThisLevel) == OK:
				victory_screen.enableButtons()
				break
			elif i == 3:
				Notification.showMessage("Failed to save rewards to Server. Please restart the game", 5.0)
		ScoreManager.reset_score()

func level_finish() -> void:
	victory_screen.visible = true
	victory_screen.update_scores()
	ScoreUi.get_node('CanvasLayer').hide()
	
func opening_cutscene() -> void:
	CutsceneManager.add_cutscene(scene_path, "opening6")
	CutsceneManager.play_cutscene("opening6")

func enable_score_ui() -> void:
	ScoreUi.get_node('CanvasLayer').show()

func player_state_reset() -> void:
	ScoreManager.reset_score()
	player.inv.reset()
