extends Control
func shop2_close() -> void:
	var tween = create_tween()
	var screen_size = get_viewport_rect().size
	tween.tween_property(self, "position:y", screen_size.y, 0.3) \
		.set_trans(Tween.TRANS_BACK) \
		.set_ease(Tween.EASE_IN)
	tween.tween_callback(func(): visible = false)
