extends Control



# Window Resolution Selection
func _on_res_option_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
			center_window()
		1:
			DisplayServer.window_set_size(Vector2i(1366, 768))
			center_window()
		2:
			DisplayServer.window_set_size(Vector2i(1280, 720))
			center_window()


# Window Mode Selection	
func _on_window_mode_item_selected(index: int) -> void:
	match index:
		0:
			# changes the window to fullscreen mode
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		1:
			# changes the window to windowed mode
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			# puts the window to the center of the screen
			center_window()


# center window
func center_window() -> void:
	var screen_size = DisplayServer.screen_get_size()
	var window_size = DisplayServer.window_get_size()
	var centered_position = (screen_size - window_size) / 2
	DisplayServer.window_set_position(centered_position)
