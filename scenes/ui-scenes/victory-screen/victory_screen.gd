extends Control
@onready var coins_val: Label = $VBoxContainer/HBoxContainer2/CoinsVal
@onready var score_val: Label = $VBoxContainer/HBoxContainer/ScoreVal
@export var player: PlayerHercules
func _ready() -> void:
	%MenuBtn.disabled = true
	%NextStageBtn.disabled = true
func update_scores() -> void:
	score_val.text = str(ScoreManager.total_score)
	coins_val.text = str(ScoreManager.collected_items["coin"])
	print("scores updated")
func menu_btn() -> void:
	LevelScreenTransition.transition()
	player_state_reset()
	await LevelScreenTransition.on_transition_finished
	SceneManager.changeScene("res://scenes/ui-scenes/lobby-screen/lobby_screen.tscn")
	ScoreUi.get_node('CanvasLayer').hide()
func player_state_reset() -> void:
	ScoreManager.reset_score()
	player.inv.reset()
func enableButtons() -> void:
	%MenuBtn.disabled = false
	%NextStageBtn.disabled = false
func _on_next_stage_btn_pressed() -> void:
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	SceneManager.changeScene("res://scenes/ui-scenes/chapter-selection/chapter_selection.tscn")
