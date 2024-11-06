extends Control


# back button
func _on_back_btn_pressed() -> void:
	SceneManager.changeScene("res://scenes/ui-scenes/chapter-selection/chapter_selection.tscn")
