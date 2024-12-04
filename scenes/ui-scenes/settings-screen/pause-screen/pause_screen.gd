# pause_screen.gd
extends Control

@export var current_level_path : String
@export var settings_window : Control
@export var player : PlayerHercules

func _ready() -> void:
	settings_window.process_mode = Node.PROCESS_MODE_ALWAYS


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


func open_settings() -> void:
	if get_tree().paused:
		settings_window.process_mode = Node.PROCESS_MODE_ALWAYS
		settings_window.visible = true

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
