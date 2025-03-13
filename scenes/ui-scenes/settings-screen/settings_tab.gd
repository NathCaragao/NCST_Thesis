extends Control

@onready var master: HSlider = %Master
@onready var sfx: HSlider = %Sfx
@onready var music: HSlider = %MusicVal


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

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


func _on_window_mode_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			center_window()


func center_window() -> void:
	var screen_size = DisplayServer.screen_get_size()
	var window_size = DisplayServer.window_get_size()
	var centered_position = (screen_size - window_size) / 2
	DisplayServer.window_set_position(centered_position)

func settings_close() -> void:
	var tween = create_tween()
	
	var screen_size = get_viewport_rect().size
	
	tween.tween_property(self, "position:y", screen_size.y, 0.3) \
		.set_trans(Tween.TRANS_BACK) \
		.set_ease(Tween.EASE_IN)
	
	tween.tween_callback(func(): visible = false)

func _on_master_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)

func _on_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, value)

func _on_music_val_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, value)
