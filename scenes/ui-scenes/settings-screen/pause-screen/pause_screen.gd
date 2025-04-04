extends Control
@export var current_level_path : String
@export var player : PlayerHercules
func _ready() -> void:
	pass
func open() -> void:
	show()
func close() -> void:
	hide()
func restart_level() -> void:
	get_tree().paused = false
	close()
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	SceneManager.restartScene(current_level_path)
	player_state_reset()
func _on_resume_btn_pressed() -> void:
	close()
	get_tree().paused = false
func quit_level() -> void:
	get_tree().paused = false
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	SceneManager.changeScene("res://scenes/ui-scenes/chapter-selection/chapter_selection.tscn")
	ScoreUi.get_node('CanvasLayer').hide()
func player_state_reset() -> void:
	ScoreManager.reset_score()
	player.inv.reset()
