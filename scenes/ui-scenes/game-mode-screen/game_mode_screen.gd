# GAME MODE SCREEN
extends Control


# CAMPAIGN BUTTON PRESSED
func _on_campaign_btn_pressed() -> void:
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	
	# REDIRECT TO CHAPTER SELECTION SCREEN
	SceneManager.changeScene("res://scenes/ui-scenes/chapter-selection/chapter_selection.tscn")



# MULTIPLAYER MODE BUTTON PRESSED
func _on_multiplayer_btn_pressed() -> void:
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	
	# REDIRECT TO COOP CHARACTER SELECTION SCREEN
	SceneManager.changeScene("res://scenes/ui-scenes/coop-character-selection/coop_character_selection.tscn")

# GO BACK TO LOBBY
func _on_back_btn_pressed() -> void:
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	
	# CHANGE SCENE TO LOBBY SCREEN
	SceneManager.changeScene("res://scenes/ui-scenes/lobby-screen/lobby_screen.tscn")
