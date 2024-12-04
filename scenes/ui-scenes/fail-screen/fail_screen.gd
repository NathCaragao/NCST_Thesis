extends Control

@export var current_level_path : String

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
