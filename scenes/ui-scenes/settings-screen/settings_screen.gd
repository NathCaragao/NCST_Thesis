extends Control


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_close_btn_pressed() -> void:
	var tween = create_tween()
	
	var screen_size = get_viewport_rect().size
	
	tween.tween_property(self, "position:y", screen_size.y, 0.3) \
		.set_trans(Tween.TRANS_BACK) \
		.set_ease(Tween.EASE_IN)
	
	tween.tween_callback(func(): visible = false)
