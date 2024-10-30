extends Control

# close button
func _on_close_btn_pressed() -> void:
	SceneManager.changeScene("res://scenes/ui-scenes/lobby-screen/lobby_screen.tscn")
