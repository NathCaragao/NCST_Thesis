# level 1.gd
extends Node2D
var scene_path : String = "res://scenes/cutscenes-collection/level 1/level_1_opening.tscn"
@onready var cutscene_layer: CanvasLayer = $CanvasLayer
@onready var combat = $bgm/combat
@onready var lively = $bgm/lively


@export var player : PlayerHercules
@export var fail_screen: Control
@export var pause_screen : Control
@export var victory_screen : Control
@export var nemean_lion : CharacterBody2D

@export var melee_sprite : TextureRect
@export var ranged_sprite : TextureRect

var paused : bool = false

func _ready() -> void:
	CutsceneManager.set_canvas_layer(cutscene_layer)
	player.connect("PlayerFail", Callable(self, "on_player_fail"))
	nemean_lion.connect("LionDefeated", Callable(self, "on_lion_defeated"))
	
	opening_cutscene()
	lively.play()
# when player dies: fail screen opens
func on_player_fail() -> void:
	fail_screen.open()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_game"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pause_screen.open()
		get_tree().paused = true
	
	
	# weapon mode UI indicator
	if Input.is_action_just_pressed("melee-mode"):
		melee_mode()
	elif Input.is_action_just_pressed("ranged-mode"):
		ranged_mode()

func on_lion_defeated() -> void:
	victory_screen.visible = true # shows the victory screen
	victory_screen.update_scores() # updates the scores
	
# function for the opening scene
func opening_cutscene() -> void:
	CutsceneManager.add_cutscene(scene_path, "opening1")
	CutsceneManager.play_cutscene("opening1")

func melee_mode() -> void:
	melee_sprite.visible = true
	ranged_sprite.visible = false

func ranged_mode() -> void:
	ranged_sprite.visible = true
	melee_sprite.visible = false
