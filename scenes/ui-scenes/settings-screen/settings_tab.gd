extends Control



# Window Resolution Selection
func _on_res_option_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		1:
			DisplayServer.window_set_size(Vector2i(1366, 768))
		2:
			DisplayServer.window_set_size(Vector2i(1280, 720))


# Window Mode Selection
func _on_window_mode_item_selected(index: int) -> void:
	pass # Replace with function body.
