# pause_screen.gd
extends Control

@export var current_level_path : String
@export var settings_window : Control

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
	
	SceneManager.changeScene("res://scenes/ui-scenes/level-selection/level_selection_2.tscn")
