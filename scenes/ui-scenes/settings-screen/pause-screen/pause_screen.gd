# pause_screen.gd
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
	# unpause the game
	get_tree().paused = false
	close()
	# play screen transition
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	
	# change scene
	SceneManager.restartScene(current_level_path)
	player_state_reset()
	
	print("Level Restarted")

func _on_resume_btn_pressed() -> void:
	close()
	get_tree().paused = false

func quit_level() -> void:
	# unpause the game
	get_tree().paused = false
	# play screen transition
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	
	# switch scenes
	SceneManager.changeScene("res://scenes/ui-scenes/chapter-selection/chapter_selection.tscn")
	# hide score UI
	ScoreUi.get_node('CanvasLayer').hide()

# resets players score and inv to a clean state
func player_state_reset() -> void:
	# reset score
	ScoreManager.reset_score()
	
	# reset player inventory
	player.inv.reset()
