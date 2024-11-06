# chapter_selection.gd
extends Control

# chapter 1 button
func _on_ch_btn_pressed() -> void:
	SceneManager.changeScene("res://scenes/ui-scenes/level-selection/level_selection.tscn")

# back button
func _on_back_btn_pressed() -> void:
	SceneManager.changeScene("res://scenes/ui-scenes/lobby-screen/lobby_screen.tscn")


func _on_multiplayer_btn_pressed() -> void:
	SceneManager.changeScene("res://scenes/multiplayerLevelManager/MultiplayerLevelManager.tscn")
