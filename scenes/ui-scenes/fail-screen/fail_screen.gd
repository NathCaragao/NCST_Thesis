extends Control
@export var current_level_path : String
@export var player : CharacterBody2D
@onready var respawn_btn: Button = $VBoxContainer/RespawnBtn
func _ready() -> void:
	respawn_btn.disabled = true
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
	ScoreUi.get_node('CanvasLayer').hide()
	player_state_reset()
func player_state_reset() -> void:
	ScoreManager.reset_score()
	player.inv.reset()
	QuestUi.hide_quest_box()
