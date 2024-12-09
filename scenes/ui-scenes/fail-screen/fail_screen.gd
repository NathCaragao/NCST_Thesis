# fail_screen.gd
extends Control

@export var current_level_path : String
@export var player : PlayerHercules
@onready var respawn_btn: Button = $VBoxContainer/RespawnBtn

func _ready() -> void:
	respawn_btn.disabled = true

# restart btn
func _on_restart_btn_pressed() -> void:
	get_tree().paused = false
	SceneManager.restartScene(current_level_path)
	visible = false


func open() -> void:
	show()

func close() -> void:
	hide()

func quit_level() -> void:
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	
	SceneManager.changeScene("res://scenes/ui-scenes/chapter-selection/chapter_selection.tscn")
	
	# hides the score UI
	ScoreUi.get_node('CanvasLayer').hide()
	
	# resets the player score and Inventory
	player_state_reset()

# resets players score and inv to a clean state
func player_state_reset() -> void:
	# reset score
	ScoreManager.reset_score()
	
	# reset player inventory
	player.inv.reset()
