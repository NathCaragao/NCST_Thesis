extends Control
func _on_campaign_btn_pressed() -> void:
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	SceneManager.changeScene("res://scenes/ui-scenes/chapter-selection/chapter_selection.tscn")
func _on_multiplayer_btn_pressed() -> void:
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	SceneManager.changeScene("res://scenes/ui-scenes/coop-character-selection/coop_character_selection.tscn")
func _on_back_btn_pressed() -> void:
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	SceneManager.changeScene("res://scenes/ui-scenes/lobby-screen/lobby_screen.tscn")
