# victory_screen.gd
extends Control


@onready var coins_val: Label = $VBoxContainer/HBoxContainer2/CoinsVal
@onready var score_val: Label = $VBoxContainer/HBoxContainer/ScoreVal
@export var player: PlayerHercules

func _ready() -> void:
	%MenuBtn.disabled = true
	%NextStageBtn.disabled = true

func update_scores() -> void:
	# Get the  current score from the ScoreManager
	# displays the general score
	score_val.text = str(ScoreManager.total_score)
	# displays the amount of coins collected
	coins_val.text = str(ScoreManager.collected_items["coin"])
	print("scores updated")

func menu_btn() -> void:
	# play screen transition
	LevelScreenTransition.transition()
	player_state_reset()
	await LevelScreenTransition.on_transition_finished
	
	SceneManager.changeScene("res://scenes/ui-scenes/lobby-screen/lobby_screen.tscn")
	# score UI
	ScoreUi.get_node('CanvasLayer').hide()

# resets players score and inv to a clean state
func player_state_reset() -> void:
	# reset score
	ScoreManager.reset_score()
	
	# reset player inventory
	player.inv.reset()

func enableButtons() -> void:
	%MenuBtn.disabled = false
	%NextStageBtn.disabled = false

# next level btn
func _on_next_stage_btn_pressed() -> void:
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	
	SceneManager.changeScene("res://scenes/ui-scenes/chapter-selection/chapter_selection.tscn")
